
package com.pixeldroid.r_c4d3.interfaces
{
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	
	
	public interface IControllable
	{
		function onHatMotion(e:JoyHatEvent):void
		function onButtonMotion(e:JoyButtonEvent):void
	}
}
