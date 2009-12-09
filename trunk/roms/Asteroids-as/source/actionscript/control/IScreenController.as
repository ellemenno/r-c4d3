
package control
{
	
	import flash.events.Event;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	
	import util.IDisposable;
	
	
	public interface IScreenController extends IDisposable
	{
		function onHatMotion(e:JoyHatEvent):void
		function onButtonMotion(e:JoyButtonEvent):void
		function onFrameUpdate(dt:int):void
	}
}
