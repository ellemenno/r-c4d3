
package com.pixeldroid.r_c4d3.preloader.keyconfig
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import com.pixeldroid.r_c4d3.preloader.keyconfig.ICanFocus;

	
	public class Button extends SimpleButton implements ICanFocus
	{
		private static var globalIndex : int = 0; // TODO: debug code.
		private var index : int = globalIndex++;
		public override function toString() : String
		{
			return super.toString() + ", index = "+index;
		}
		
		private var textField : TextField;
		
		private var upSprite : ButtonSprite;
		private var overSprite : ButtonSprite;
		private var downSprite : ButtonSprite;
		
		public function get hasFocus() : Boolean { return _hasFocus; }
		private var _hasFocus : Boolean;
		
		// If we don't keep track of these ourselves, the calls to super.width
		//   and super.height will trample Sprite's state and then weird bugs
		//   happen like giant buttons that take up many screens.  It seems 
		//   easy to create situations where width and height will multiply
		//   themselves during drawing operations.  Thus we will ignore width
		//   and height, instead using w and h for our own usage.
		private var w : Number = 0;
		private var h : Number = 0;
		
		public override function get width() : Number { return w; }
		public override function set width(val : Number) : void { w = val; }
		
		public override function get height() : Number { return h; }
		public override function set height(val : Number) : void { h = val; }
		
		
		public function Button(labelText:String = "Submit")
		{
			upSprite = new ButtonSprite(labelText);
			overSprite = new ButtonSprite(labelText);
			downSprite = new ButtonSprite(labelText);
			
			tabEnabled = true;
			useHandCursor = true;
			focusRect = false; // Get rid of ugly yellow rectangle for focus.
			
			upState = upSprite;
			overState = overSprite;
			downState = downSprite;
			hitTestState = upSprite;
			
			// The sprites are redrawn on every frame to make sure that changes
			//   in things like width and height will be reflected.
			upSprite.addEventListener(Event.ENTER_FRAME, onUpEnterFrame);
			overSprite.addEventListener(Event.ENTER_FRAME, onOverEnterFrame);
			downSprite.addEventListener(Event.ENTER_FRAME, onDownEnterFrame);
			
			// These are needed for us to track our focus state.
			//addEventListener(FocusEvent.FOCUS_IN, focusIn);
			//addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			// TODO: temporary.
				//addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocusShift);
				//addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onMouseFocus);
			
			// TODO: Is this still needed?
			onUpEnterFrame(null);
		}
		
		public function finalize() : void
		{
			upSprite.removeEventListener(Event.ENTER_FRAME, onUpEnterFrame);
			overSprite.removeEventListener(Event.ENTER_FRAME, onOverEnterFrame);
			downSprite.removeEventListener(Event.ENTER_FRAME, onDownEnterFrame);
			
			//removeEventListener(FocusEvent.FOCUS_IN, focusIn);
			//removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
		}
		
		private function calcRounding() : Number
		{
			var r : Number;
			if ( w > h ) 
				r = h / 2;
			else
				r = w / 2;
			return r;
		}
		
		private function onUpEnterFrame( e : Event ) : void
		{
			draw( upSprite, 0xAAAAAA, 0xEFEFEF );
		}
		
		private function onOverEnterFrame( e : Event ) : void
		{
			draw( overSprite, 0xBBCCAA, 0xEFEFEF );
		}
		
		private function onDownEnterFrame( e : Event ) : void
		{
			//draw( downSprite, 0xBBCCAA, 0xDFEFCF );
			draw( downSprite, 0xBBCCAA, 0xDF3030 );
		}
		
		private function draw( sprite : ButtonSprite, outsideColor : int, insideColor : int ) : void
		{
			var r : Number = calcRounding();
			var g : Graphics = sprite.drawLayer.graphics;
			g.clear();
			g.lineStyle(2, outsideColor);
			g.beginFill(insideColor);
			g.drawRoundRect(0,0, w,h, r,r);
			g.endFill();
			
			if ( hasFocus )
			{
				g.lineStyle(1, outsideColor);
				g.drawRoundRect(-3,-3, w+6,h+6, r+3,r+3); 
			}
			
			positionLabel(sprite.textField, downSprite);
		}
		
		private function positionLabel(textField : TextField, sprite : Sprite):void
		{
			textField.width = w;
			textField.height = h;
			textField.x = 0;
			// Given what textHeight means, some magic in the form of 7/16 is 
			//   needed to make the text appear to be actually centered.
			textField.y = height*7/16 - textField.textHeight/2;
			
			// Make the text appear to depress when the button is held down.
			if ( sprite == downSprite )
				textField.y += height / 20;
		}
		
		public function wantFocus() : Boolean
		{
			return true;
		}
		
		public function onFocusIn()  : void { focusIn(null); }
		public function onFocusOut() : void { focusOut(null); }
		
		private function focusIn( e : FocusEvent ) : void
		{
			_hasFocus = true;
			//trace("Button.focus in!");
		}
		
		private function focusOut( e : FocusEvent ) : void
		{
			_hasFocus = false;
			//trace("Button.focus out!");
		}
		
		public function onFocusShift( e : FocusEvent ) : void
		{
			//trace("Button.focus changed!");
		}
		
		public function onMouseFocus( e : FocusEvent ) : void
		{
			//trace("Button.focus changed! (mouse)");
		}
	}
}

import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
	
/*private*/ class ButtonSprite extends Sprite
{
	public var drawLayer : Shape = new Shape();
	public var textField : TextField = new TextField();
	
	public function ButtonSprite( str : String )
	{
		super();
		
		var format : TextFormat = new TextFormat();
		format.font = "_sans";
		format.align = TextFormatAlign.CENTER;
		format.bold = true;
		format.color = 0x7f7f7f;
		format.size = 18;
		
		textField = new TextField();
		textField.text = str;
		textField.selectable = false;
		textField.setTextFormat(format);
		
		// The draw layer must be added first so that it is rendered behind the 
		//   text.
		addChild(drawLayer);
		
		// The text field must be added second so that it gets rendered in front
		//   of the other graphics.
		addChild(textField);
	}
}