
package com.pixeldroid.r_c4d3.scores 
{
	
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.interfaces.IScoreEntry;

	/**
	Value Object for storing scores associated with player data.
	Designed for use with IGameScoreProxy implementors.
	
	@see com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy
	*/
	public class ScoreEntry implements IScoreEntry
	{
		
		private var _value:Number = 0;
		private var _label:String = "";
		private var _accepted:Boolean = false;

		
		/**
		Constructor.
		
		@param value Initial score value (optional)
		@param value Initial player data (optional)
		*/
		public function ScoreEntry(number:Number=NaN, string:String=null) {
			if (!isNaN(number)) _value = number;
			if (string != null) _label = string;
		}

		
		/** @inheritDoc */
		public function set value(number:Number):void { _value = number; }
		public function get value():Number { return _value; }
	
		/** @inheritDoc */
		public function set label(string:String):void { _label = string; }
		public function get label():String { return _label; }

		
		/** @inheritDoc */
		public function get accepted():Boolean { return _accepted; }
	
		/**
		@private
		*/ // for IGameScoresProxy use only
		public function setAccepted(value:Boolean, authorization:IGameScoresProxy):void
		{
			if ( !(authorization && authorization.gameId && authorization.gameId.length > 0) ) throw new Error("Invalid authorization; this method for GameScoresProxy use only");
			else _accepted = value;
		}
		
		/** @inheritDoc */
		public function clone():IScoreEntry {
			return new ScoreEntry(_value, _label);
		}
		
		/** @inheritDoc */
		public function toString():String 
		{
			return _value +" " +_label;
		}		
	}
}
