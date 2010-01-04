
package com.pixeldroid.r_c4d3.scores 
{
	
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;

	/**
	*/
	public class ScoreEntry 
	{
		
		private var _accepted:Boolean = false;
		
	
		/**
		*/
		public var value:Number;
	
		/**
		*/
		public var label:String;


		
		/**
		*/
		public function ScoreEntry(value:Number=NaN, label:String=null) {
			if (!isNaN(value)) this.value = value;
			if (label != null) this.label = label;
		}

		
		
		/**
		*/
		public function get accepted():Boolean { return _accepted; }
	
		/**
		*/
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
		*/
		public function toString():String 
		{
			return value +" " +label;
		}		
	}
}
