
package com.pixeldroid.r_c4d3.controls
{

	/**
	Enumerations for use with IGameControlsProxy to control event broadcasting.
	@see com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy
	*/
	public class JoyEventStateEnum {
	
		private var memberVar:int; // prevent the haxe extern gen from optimizing this class into an enum

		/** Indicates the current state is requested */ 
		public static const QUERY:String  = "QUERY";
		
		/** Indicates event broadcasting should be enabled */ 
		public static const ENABLE:String = "ENABLE";
		
		/** Indicates event broadcasting should be disabled */ 
		public static const IGNORE:String = "IGNORE";
		
	}
}