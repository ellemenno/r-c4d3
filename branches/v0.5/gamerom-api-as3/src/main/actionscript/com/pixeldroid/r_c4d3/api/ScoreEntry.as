
package com.pixeldroid.r_c4d3.api
{
	
	import com.pixeldroid.r_c4d3.api.IScoreEntry;

	/**
	Value Object for storing scores associated with player data.
	Designed for submitting to IGameScoreProxy implementors.
	
	@see com.pixeldroid.r_c4d3.api.IGameScoresProxy
	*/
	public class ScoreEntry implements IScoreEntry
	{
		
		private var _value:Number;
		private var _label:String;
		private var _accepted:Boolean;

		
		/**
		Constructor.
		
		@param value Initial score value (optional)
		@param value Initial player data (optional)
		*/
		public function ScoreEntry(number:Number=0, string:String="")
		{
			_value = number;
			_label = string;
			_accepted = false;
		}

		
		/** @inheritDoc */
		public function set value(number:Number):void { _value = number; }
		public function get value():Number { return _value; }
	
		/** @inheritDoc */
		public function set label(string:String):void { _label = string; }
		public function get label():String { return _label; }
		
		/** @inheritDoc */
		public function get isAccepted():Boolean { return _accepted; }

		/** @inheritDoc */
		public function setAccepted(boolean:Boolean):void { _accepted = boolean; }
		
		/** @inheritDoc */
		public function clone():IScoreEntry { return new ScoreEntry(_value, _label); }
		
		/** @inheritDoc */
		public function toString():String 
		{
			return _value +" " +_label;
		}		
	}
}
