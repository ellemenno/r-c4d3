

package view.screen
{
	
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	
	import view.screen.IScreen;
	
	
	
	public class ScreenBase extends Sprite implements IScreen
	{
		
		protected var _type:String;
		
		
		
		public function ScreenBase():void
		{
			C.out(this, "base constructor");
			super();
		}
		
		
		
		public function set type(value:String):void
		{
			C.out(this, "set type() - " +value);
			_type = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		
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
