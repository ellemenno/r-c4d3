
package com.pixeldroid.r_c4d3.data
{
	import com.pixeldroid.r_c4d3.api.IEnumerator;
	
	/**
	Implementors can be queried about their type
	*/
	public interface ITypable
	{
		function set type(value:IEnumerator):void;
		function get type():IEnumerator;
	}
}
