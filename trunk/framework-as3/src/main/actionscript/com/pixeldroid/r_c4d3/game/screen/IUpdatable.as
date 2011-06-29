
package com.pixeldroid.r_c4d3.game.screen
{
	
	
	/**
	Implementors support time delta update requests.
	*/
	public interface IUpdatable
	{
		/** @param dt Time elapsed (ms) */ function onUpdateRequest(dt:int):void
	}
}
