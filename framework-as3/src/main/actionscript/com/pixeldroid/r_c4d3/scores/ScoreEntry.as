
package com.pixeldroid.r_c4d3.scores 
{
	
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;

	/**
	Value Object for storing scores associated with player data.
	Designed for use with IGameScoreProxy implementors.
	
	@see com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy
	*/
	public class ScoreEntry 
	{
		
		private var _accepted:Boolean = false;
		
	
		/**
		The score.
		*/
		public var value:Number;
	
		/**
		The player data (e.g. initials).
		*/
		public var label:String;


		
		/**
		Constructor.
		
		@param value Initial score value (optional)
		@param value Initial player data (optional)
		*/
		public function ScoreEntry(value:Number=NaN, label:String=null) {
			if (!isNaN(value)) this.value = value;
			if (label != null) this.label = label;
		}

		
		
		/**
		When submitted to an IGameScoresProxy, this flag will be set indicating 
		whether the score was accepted into the high score list (true) or not (false).
		*/
		public function get accepted():Boolean { return _accepted; }
	
		/**
		@private
		*/ // for IGameScoresProxy use only
		public function setAccepted(value:Boolean, authorization:IGameScoresProxy):void
		{
			if ( !(authorization && authorization.gameId && authorization.gameId.length > 0) ) throw new Error("Invalid authorization; this method for GameScoresProxy use only");
			else _accepted = value;
		}
		
		/**
		* @inheritDoc
		*/
		public function clone():ScoreEntry {
			return new ScoreEntry(value, label);
		}
		
		/**
		Returns a simple human readable string.
		*/
		public function toString():String 
		{
			return value +" " +label;
		}		
	}
}
