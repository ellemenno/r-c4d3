
package com.pixeldroid.r_c4d3.api
{
	
	
	/**
	Simple class to provide strongly typed enumeration elements.
	
	@see com.pixeldroid.r_c4d3.api.IEnumerator
	*/
	public class Enumerator implements IEnumerator
	{
		private var _value:String;
		
		public function Enumerator(value:String):void { _value = value; }
		public function get value():String { return _value; }
		public function toString():String { return _value; }
	}
}
		
