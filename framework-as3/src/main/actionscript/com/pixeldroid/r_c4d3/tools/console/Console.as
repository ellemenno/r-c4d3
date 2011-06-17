﻿
package com.pixeldroid.r_c4d3.tools.console {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	/**
	Implements a simple on-screen display for viewing run-time text messages.
	
	<p>
	New messages accumulate at the bottom of the console, 
	old messages roll off the top.
	</p>
	
	<p>
	The console can be hidden, shown, paused, resumed, and cleared. Text in the console is selectable 
	so it can be copied to the clipboard.
	</p>
	
	<p>
	The buffer size is also configurable. As the buffer fills up, oldest lines are discarded first. 
	</p>
	
	<p>
	The console is scrollable by dragging a selection inside it with the cursor, 
	or clicking to give it focus and using the arrow keys, but does not provide a scrollbar.
	</p>
	
	<p>
	This class embeds a distributable font named "ProggyTiny.ttf",
	Copyright 2004 by Tristan Grimmer.
	</p>
	
	@see http://proggyfonts.com/index.php?menu=download
	
	@example The following code shows a simple console instantiation; 
	see the constructor documentation for more options:
<listing version="3.0" >
package {
   import com.pixeldroid.r_c4d3.tools.console.Console;
   import flash.display.Sprite;

   public class MyConsoleExample extends Sprite {
	  public var console:Console = new Console();
	  public function MyConsoleExample() {
		 super();
		 addChild(console);
		 console.log("Hello World");
	  }
   }
}
</listing>
	
	@example The console may be used in conjunction with the C logger:
<listing version="3.0" >
package {
   import com.pixeldroid.r_c4d3.tools.console.Console;
   import flash.display.Sprite;

   public class MyConsoleLoggingExample extends Sprite {
	  private var console:Console = new Console();
	  public function MyConsoleExample() {
		 super();
		 addChild(console);
		 C.enable(console);
		 C.out("Hello World"); // C.outs for all classes will log to console now
	  }
   }
}
</listing>
	*/
	public class Console extends Sprite {
		
		[Embed(mimeType="application/x-font", source="ProggyTiny.ttf", fontName="FONT_CONSOLE", embedAsCFF="false")]
		protected static var FONT_CONSOLE:Class;

		protected static const WIDTH:Number = 780;
		protected static const HEIGHT:Number = 200;
		protected static const BACK_COLOR:uint = 0x000000;
		protected static const FORE_COLOR:uint = 0xffffff;
		protected static const FONT_SIZE:Number = 16;
		protected static const BACK_ALPHA:Number = .8;
		protected static const BUFFER_SIZE:int = 64;
		protected static const LEADING:int = 2;
		
		protected var background:Shape;
		protected var console:TextField;
		protected var loggingPaused:Boolean;
		protected var first:Boolean;
		protected var bufferMax:int;
	
		/**
		* Create a new Console with optional parameters.
		* 
		* @param width Width of console (pixels)
		* @param height Height of console (pixels)
		* @param bgColor Console background color
		* @param fgColor Console text color
		* @param txtSize Console text size
		* @param bgAlpha Console background alpha
		* @param buffer Max number of recent lines to retain
		*/
		public function Console (
			width:Number = WIDTH,
			height:Number = HEIGHT,
			bgColor:uint = BACK_COLOR, 
			fgColor:uint = FORE_COLOR,
			txtSize:Number = FONT_SIZE,
			bgAlpha:Number = BACK_ALPHA,
			buffer:int = BUFFER_SIZE,
			leading:int = LEADING
		) {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, registerKeyhandler);
		
			background = new Shape();
			background.graphics.beginFill(bgColor, bgAlpha);
			background.graphics.drawRect(0, 0, width, height);
			background.graphics.endFill();
			addChild(background);

			var format:TextFormat = new TextFormat();
			format.font = "FONT_CONSOLE";
			format.color = fgColor;
			format.size = txtSize;
			format.align = TextFormatAlign.LEFT;
			format.leading = leading;
			
			console = new TextField();
			console.antiAliasType = (txtSize > 24) ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
			console.gridFitType = GridFitType.PIXEL;
			console.embedFonts = true;
			console.defaultTextFormat = format;
			console.multiline = true;
			console.selectable = true;
			console.wordWrap = true;
			addChild(console);
			
			console.width = width;
			console.height = height;
			
			loggingPaused = false;
			first = true;
			bufferMax = buffer;
		}
		
		


		/**
		* Append a message to the console.
		*/
		public function log(value:String):void {
			if (loggingPaused == false) {
				console.appendText(value +"\n");
				var overage:int = console.numLines - bufferMax;
				if (overage > 0) console.replaceText(0, console.getLineOffset(overage), "");
				console.scrollV = console.maxScrollV;
			}
		}
	
	
		/**
		* Clear all messages from the console.
		*/
		public function clear():void {
			console.replaceText(0, console.length, "");
		}
	
	
		/**
		* Pause the console. Messages received while paused are ignored.
		*/
		public function pause():void {
			log("<PAUSE>");
			loggingPaused = true;
		}
	
	
		/**
		* Resume the console.
		*/
		public function resume():void {
			loggingPaused = false;
			log("<RESUME>");
		}
	
	
		/**
		* Hide the console. Messages are still received.
		*/
		public function hide():void {
			visible = false;
		}
	
	
		/**
		* Show the console.
		*/
		public function show():void {
			visible = true;
		}

		
		/**
		* Override to change keyboard shortcuts.
		* By default:
		* <ul>
		* <li>tick (`) toggles hide</li>
		* <li>ctrl-tick toggles pause</li>
		* <li>ctrl-bkspc clears</li>
		* </ul>
		*/
		protected function keyDownHandler(e:KeyboardEvent):void {
			if ("`" == String.fromCharCode(e.charCode))
			{
				if (e.ctrlKey == true) toggleLog();
				else                   toggleVis();
			}
			else if ((e.keyCode == Keyboard.BACKSPACE) && (e.ctrlKey == true)) clear();
		}
		
		protected function registerKeyhandler(e:Event):void {
			log(": : : : : : : : : : : : : :");
			log(": tick (`) toggles hide");
			log(": ctrl-tick toggles pause");
			log(": ctrl-bkspc clears");
			log("");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		protected function toggleLog():void { (loggingPaused == true) ? resume() : pause(); }
		
		protected function toggleVis():void { (visible == false) ? show() : hide(); }
		
	}

}