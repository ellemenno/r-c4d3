

package view.screen
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	
	import util.IControllable;
	import util.IDisposable;
	import view.screen.IScreen;
	
	
	
	public class ScreenBase extends Sprite implements IScreen, IControllable, IDisposable
	{
		
		protected var _type:String;
		protected var timeElapsed:int;
		
		
		
		public function ScreenBase():void
		{
			C.out(this, "base constructor");
			super();
		}
		
		
		
		protected function set backgroundColor(value:uint):void
		{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			graphics.clear();
			graphics.beginFill(value);
			graphics.drawRect(0,0, w,h);
			graphics.endFill();
		}
		
		protected function clear():void
		{
			graphics.clear();
			var d:DisplayObject;
			while (numChildren > 0)
			{
				d = removeChildAt(0);
				if (d is ScreenBase) (d as ScreenBase).shutDown();
			}
		}
		
		protected function onFirstScreen():void
		{
			// to be overridden by subclasses to draw first view on screen
			// updates will be prompted via onScreenUpdate
		}
		
		
		// IScreen interface
		public function set type(value:String):void
		{
			C.out(this, "set type() - " +value);
			_type = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			clear();
			var t:String;
			
			if (timeElapsed < 1000) t = timeElapsed +"ms";
			else
			{
				var s:int = Math.floor(timeElapsed*.001);
				var m:int = (s >= 60) ? Math.floor(s/60) : 0;
				t = (m > 0) ? m +"m " +(s - m*60) +"s" : s +"s";
			}
			
			C.out(this, "base shutDown() - lifetime was " +t);
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "base initialize()");
			timeElapsed = 0;
			onFirstScreen();
			
			return true;
		}
		
		
		// IController interface
		public function onHatMotion(e:JoyHatEvent):void
		{
			C.out(this, "onHatMotion: " +e);
		}
		
		public function onButtonMotion(e:JoyButtonEvent):void
		{
			C.out(this, "onButtonMotion: " +e);
		}
		
		public function onScreenUpdate(dt:int):void
		{
			timeElapsed += dt;
		}
	}
}
