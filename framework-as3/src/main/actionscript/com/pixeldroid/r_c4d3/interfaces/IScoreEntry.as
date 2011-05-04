
package com.pixeldroid.r_c4d3.interfaces
{

	/**
	Value Object for storing scores associated with player data.
	Designed for use with IGameScoreProxy implementors.
	
	@see com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy
	*/
	public interface IScoreEntry 
	{
	
		/**
		The score.
		*/
		function set value(number:Number):void;
		/** @private */
		function get value():Number;
	
		/**
		The player data (e.g. initials).
		*/
		function set label(string:String):void;
		/** @private */
		function get label():String;
		
		/**
		When submitted to an IGameScoresProxy, this flag will be set indicating 
		whether the score was accepted into the high score list (true) or not (false).
		*/
		function get accepted():Boolean;
		
		/**
		Returns a duplicate score entry
		*/
		function clone():IScoreEntry;
		
		/**
		Returns a simple human readable string.
		*/
		function toString():String;
	}
}
