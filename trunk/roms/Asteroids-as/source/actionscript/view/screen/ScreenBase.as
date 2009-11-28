

package view.screen
{
	
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	
	import control.IController;
	import util.IDisposable;
	import view.screen.IScreen;
	
	
	
	public class ScreenBase extends Sprite implements IScreen, IController, IDisposable
	{
		
		protected var _type:String;
		
		
		
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
			C.out(this, "shutDown()");
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
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
			//C.out(this, "onFrameUpdate (" +dt +"ms elapsed)");
		}
	}
}
