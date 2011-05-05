
package com.pixeldroid.r_c4d3.game.screen
{
	import com.pixeldroid.r_c4d3.game.screen.ScreenTypeEnumerator;
	
	/**
	Implementors can be queried about their type
	*/
	public interface IScreen
	{
		function set type(value:ScreenTypeEnumerator):void;
		function get type():ScreenTypeEnumerator;
	}
}
