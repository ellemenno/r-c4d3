
package com.pixeldroid.r_c4d3.interfaces
{
	
	
	/**
	Implementors support time delta update requests.
	*/
	public interface IUpdatable
	{
		/** @param dt Time elapsed (ms) */ function onUpdateRequest(dt:int):void
	}
}
