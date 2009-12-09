

package view.screen
{
	
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
			var s:int = Math.floor(timeElapsed*.001);
			var m:int = (s >= 60) ? Math.floor(s/60) : 0;
			var t:String = (m > 0) ? m +"m " +(s - m*60) +"s" : s +"s";
			C.out(this, "shutDown() " +t +" elapsed");
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			timeElapsed = 0;
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
		
		public function onFrameUpdate(dt:int):void
		{
			timeElapsed += dt;
			//C.out(this, "onFrameUpdate (" +dt +"ms elapsed)");
		}
	}
}
