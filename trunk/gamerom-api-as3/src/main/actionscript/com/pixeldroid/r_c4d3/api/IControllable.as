
package com.pixeldroid.r_c4d3.api
{
	
	import com.pixeldroid.r_c4d3.api.events.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.api.events.JoyHatEvent;
	
	
	/**
	Implementors respond to joystick button and hat events.
	
	@see com.pixeldroid.r_c4d3.controls.JoyButtonEvent
	@see com.pixeldroid.r_c4d3.controls.JoyHatEvent
	*/
	public interface IControllable
	{
		function onHatMotion(e:JoyHatEvent):void
		function onButtonMotion(e:JoyButtonEvent):void
	}
}
