
package com.pixeldroid.r_c4d3.api
{
	
	
	/**
	Implementors provide access to runtime configuration data.
	*/
	public interface IGameConfigProxy
	{
		
		/** Is run-time logging requested? */
		function get loggingEnabled():Boolean
		
		/** Are performance stats requested? */
		function get statsEnabled():Boolean
		
		/** IGameRom swf to load */
		function get romUrl():String;
		
		/** Game id for scores storage and retrieval */
		function get gameId():String;

		/** Were key codes defined for player 1? */    function get p1HasKeys():Boolean;
		/** Key code for player 1 Up */                function get p1U():uint;
		/** Key code for player 1 Right */             function get p1R():uint;
		/** Key code for player 1 Down */              function get p1D():uint;
		/** Key code for player 1 Left */              function get p1L():uint;
		/** Key code for player 1 Button X (yellow) */ function get p1X():uint;
		/** Key code for player 1 Button A (red) */    function get p1A():uint;
		/** Key code for player 1 Button B (blue) */   function get p1B():uint;
		/** Key code for player 1 Button C (green) */  function get p1C():uint;

		/** Were key codes defined for player 2? */    function get p2HasKeys():Boolean;
		/** Key code for player 2 Up */                function get p2U():uint;
		/** Key code for player 2 Right */             function get p2R():uint;
		/** Key code for player 2 Down */              function get p2D():uint;
		/** Key code for player 2 Left */              function get p2L():uint;
		/** Key code for player 2 Button X (yellow) */ function get p2X():uint;
		/** Key code for player 2 Button A (red) */    function get p2A():uint;
		/** Key code for player 2 Button B (blue) */   function get p2B():uint;
		/** Key code for player 2 Button C (green) */  function get p2C():uint;

		/** Were key codes defined for player 3? */    function get p3HasKeys():Boolean;
		/** Key code for player 3 Up */                function get p3U():uint;
		/** Key code for player 3 Right */             function get p3R():uint;
		/** Key code for player 3 Down */              function get p3D():uint;
		/** Key code for player 3 Left */              function get p3L():uint;
		/** Key code for player 3 Button X (yellow) */ function get p3X():uint;
		/** Key code for player 3 Button A (red) */    function get p3A():uint;
		/** Key code for player 3 Button B (blue) */   function get p3B():uint;
		/** Key code for player 3 Button C (green) */  function get p3C():uint;

		/** Were key codes defined for player 4? */    function get p4HasKeys():Boolean;
		/** Key code for player 4 Up */                function get p4U():uint;
		/** Key code for player 4 Right */             function get p4R():uint;
		/** Key code for player 4 Down */              function get p4D():uint;
		/** Key code for player 4 Left */              function get p4L():uint;
		/** Key code for player 4 Button X (yellow) */ function get p4X():uint;
		/** Key code for player 4 Button A (red) */    function get p4A():uint;
		/** Key code for player 4 Button B (blue) */   function get p4B():uint;
		/** Key code for player 4 Button C (green) */  function get p4C():uint;
		
		/** 
			Arbitrary property request 
			@param propertyName - name attribute value of property node to retrieve
		*/
		function getPropertyValue(propertyName:String):String;
		
		/**
			Xml data source
			@param value - xml source string
		*/
		function set xmlString(value:String):void;
		function get xmlString():String;
		
	}
}