
package com.pixeldroid.r_c4d3.tools.console
{

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
	
	import com.pixeldroid.r_c4d3.tools.console.ConsoleProperties;
	
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
		
		protected var background:Shape;
		protected var console:TextField;
		protected var loggingPaused:Boolean;
		protected var first:Boolean;
		protected var bufferMax:int;
	
		/**
		* Create a new Console with optional parameters.
		* 
		* @param properties Optional instance of ConsoleProperties for custom settings
		*
		* @see com.pixeldroid.r_c4d3.tools.console.ConsoleProperties
		*/
		public function Console(properties:ConsoleProperties=null)
		{
			super();
			
			if (properties == null) properties = new ConsoleProperties();
			
			addEventListener(Event.ADDED_TO_STAGE, registerKeyhandler);
		
			background = new Shape();
			background.graphics.beginFill(properties.backColor, properties.backAlpha);
			background.graphics.drawRect(0, 0, properties.width, properties.height);
			background.graphics.endFill();
			addChild(background);

			var format:TextFormat = new TextFormat();
			format.font = "FONT_CONSOLE";
			format.color = properties.foreColor;
			format.size = properties.fontSize;
			format.align = TextFormatAlign.LEFT;
			format.leading = properties.leading;
			
			console = new TextField();
			console.antiAliasType = (format.size > 24) ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
			console.gridFitType = GridFitType.PIXEL;
			console.embedFonts = true;
			console.defaultTextFormat = format;
			console.multiline = true;
			console.selectable = true;
			console.wordWrap = true;
			addChild(console);
			
			console.width = properties.width;
			console.height = properties.height;
			
			bufferMax = properties.bufferSize;
			
			loggingPaused = false;
			first = true;
		}
		
		


		/**
		* Append a message to the console.
		*
		* @param value Message to log
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
		* Retrieve human readable instructions for manipulating the console.
		*/
		public function get usage():String
		{
			var s:String = "";
			s += "Console Usage :\n";
			s += "  tick (`) toggles hide\n";
			s += "  ctrl-tick toggles pause\n";
			s += "  ctrl-bkspc clears";
			return s;
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
		*
		* <p>
		* If you overide this method, consider overriding the usage getter as well.
		* </p>
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
			log("");
			log(usage);
			log("");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		protected function toggleLog():void { (loggingPaused == true) ? resume() : pause(); }
		
		protected function toggleVis():void { (visible == false) ? show() : hide(); }
		
	}

}
