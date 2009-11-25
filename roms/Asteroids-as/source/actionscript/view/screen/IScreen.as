
package view.screen
{
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	
	
	public interface IScreen
	{
		function set name(value:String):void;
		function get name():String;
		function set type(value:String):void;
		function get type():String;
		function initialize():Boolean;
		function shutDown():Boolean;
		function onHatMotion(e:JoyHatEvent):void
		function onButtonMotion(e:JoyButtonEvent):void
		function onFrameUpdate(dt:int):void
	}
}
