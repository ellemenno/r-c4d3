
package com.pixeldroid.r_c4d3.api
{
	
	import com.pixeldroid.r_c4d3.api.Enumerator;

	/**
	Enumerator for setting or querying control event broadcasting mode on an IGameControlsProxy.
	 * 
	@see com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy
	*/
	public class JoyEventStateEnumerator extends Enumerator {

		/** Indicates the current state is requested */ 
		public static const QUERY:JoyEventStateEnumerator  = new JoyEventStateEnumerator("QUERY");
		
		/** Indicates event broadcasting should be enabled */ 
		public static const ENABLE:JoyEventStateEnumerator = new JoyEventStateEnumerator("ENABLE");
		
		/** Indicates event broadcasting should be disabled */ 
		public static const IGNORE:JoyEventStateEnumerator = new JoyEventStateEnumerator("IGNORE");
		
		
		public function JoyEventStateEnumerator(value:String):void { super(value); }
		
	}
}