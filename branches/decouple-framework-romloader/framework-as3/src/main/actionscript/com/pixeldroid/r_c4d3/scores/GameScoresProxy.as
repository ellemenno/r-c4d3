

package com.pixeldroid.r_c4d3.scores 
{
	
	import flash.events.EventDispatcher;
	
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	

	/**
	Base class for high score storage and retrieval.
	
	<ul>
	<li>Scores are kept in descending order (highest first)</li>
	<li>Ties are allowed (same score, different initials), 
	    duplicates are not (first in wins)</li>
	</ul>
	*/
	public class GameScoresProxy extends EventDispatcher implements IGameScoresProxy
	{
		
		/** Least number of characters a valid id may contain */
		static public const GAMEID_MIN:int = 4;
		
		/** Most number of characters a valid id may contain */
		static public const GAMEID_MAX:int = 32;
		
		/** Upper limit of number of entries allowed */
		static public const ENTRIES_MAX:int = 100;
		
		
		protected var NUM_ENTRIES:int;
		
		protected var scores:Array;
		protected var initials:Array;
		
		protected var storeEvent:ScoreEvent;
		protected var retrieveEvent:ScoreEvent;

		
		private var _gameId:String; // subclasses access via gameId getter
		
		
		
		/**
		Constructor.
		
		@param id A unique identifier for this set of scores and initials.
		Must be at least GAMEID_MIN characters long, but no longer than GAMEID_MAX.
		@param capacity The total number of entries that may be stored (up to ENTRIES_MAX)
		*/
		public function GameScoresProxy(id:String, capacity:int=10)
		{
			super();
			
			storeEvent = new ScoreEvent(ScoreEvent.SAVE);
			retrieveEvent = new ScoreEvent(ScoreEvent.LOAD);
			
			NUM_ENTRIES = Math.min(ENTRIES_MAX, capacity);
			
			clear();
			openScoresTable(id);
		}
		
		
		
		/** @inheritdoc */
		public function openScoresTable(gameId:String):void
		{
			if (!isValidLength(gameId)) throw new Error("invalid length for game id '" +gameId+"'.");
			if (!isValidChars(gameId))  throw new Error("invalid chars for game id '" +gameId+"'.");
			
			// else ok
			_gameId = gameId;
		}
		
		/** @inheritdoc */
		public function closeScoresTable():void { _gameId = null; }
		
		
		/**
		Read the scores and initials from the storage medium.
		<strong>To be overridden by subclasses</strong>
		*/
		public function load():void { /* sub-classes should override this method */ }
		
		/**
		Write the scores and initials to the storage medium.
		<strong>To be overridden by subclasses</strong>
		*/
		public function store():void { /* sub-classes should override this method */ }
		
		/** @inheritdoc */
		public function clear():void
		{
			scores = [];
			initials = [];
		}
		
		
		/** @inheritdoc */
		public function get gameId():String { return _gameId; }
		
		/** @inheritdoc */
		public function get capacity():int { return NUM_ENTRIES; }
		
		/** @inheritdoc */
		public function get length():uint { return scores.length; }
		
		/** @inheritdoc */
		public function get emptySlots():int { return NUM_ENTRIES - scores.length; }
		
		
		/** @inheritdoc */
		public function getScore(i:int):Number 
		{
			if (0 <= i && i < NUM_ENTRIES) return (i < scores.length) ? scores[i] : NaN;
			throw new Error("Invalid index: " +i +", valid range is 0 - " +(NUM_ENTRIES-1));
		}
		
		/** @inheritdoc */
		public function getAllScores():Array 
		{
			var A:Array = scores.slice();
			while (A.length < NUM_ENTRIES) A.push(NaN);
			return A; 
		}
		
		/** @inheritdoc */
		public function getInitials(i:int):String 
		{
			if (0 <= i && i < NUM_ENTRIES) return (i < initials.length) ? initials[i] : null;
			throw new Error("Invalid index: " +i +", valid range is 0 - " +(NUM_ENTRIES-1));
		}
		
		/** @inheritdoc */
		public function getAllInitials():Array 
		{ 
			var A:Array = initials.slice();
			while (A.length < NUM_ENTRIES) A.push(null);
			return A; 
		}


		/** @inheritdoc */
		public function getAllEntries():Array
		{
			var A:Array = [];
			var S:Array = getAllScores();
			var I:Array = getAllInitials();
			
			var j:int = 0;
			var n:int = S.length;
			var e:ScoreEntry;
			while (j < n) 
			{
				e = new ScoreEntry(S[j], I[j]);
				e.setAccepted(true, this);
				A.push(e);
				j++;
			}
			while (j++ < NUM_ENTRIES) { A.push(null); }
			
			return A; 
		}
		
		
		/** @inheritdoc */
		public function insertEntries(entries:Array):void
		{
			if (!entries || entries.length == 0) return; // nothing to do
			
			var index:Array = entries.sortOn("value", Array.DESCENDING | Array.RETURNINDEXEDARRAY | Array.NUMERIC);
			var n:int = Math.min(entries.length, NUM_ENTRIES);
			var e:ScoreEntry;
			for (var j:int = 0; j < n; j++)
			{
				e = ScoreEntry(entries[index[j]]);
				e.setAccepted(_insert(e.value, e.label, scores, initials, NUM_ENTRIES), this);
			}
		}
		
		
		/**
		Generates a displayable list of initials (up to 10 chars) and scores (up to 12 digits).
		
		<p>
		The character and digit limits are arbitrary for this toString implementation. 
		Override this method to implement custom formats.
		</p>

		<p>
		The following is a sample of the type of output toString produces:		
<listing version="3.0" >
    1. Mr. Yellow : 999,999,999,999
    2. Mr. Green  :       1,234,567
    3. Ms. Red    :              89
    4. Ms. Magent :               0
</listing>
		</p>
		*/
		override public function toString():String
		{
			var s:String = "";
			var n:int = scores.length;
			var s1:String, s2:String, s3:String;
			for (var i:int = 0; i < n; i++) {
				s1 = pad((i+1).toString(), 5, " ");
				s2 = pad(initials[i].substring(0,10), 10, " ");
				s3 = pad(chunk(scores[i].toString(), 3, ","), 12, " ");
				s += s1 +". " +s2 +" : " +s3 +"\n";
			}
			
			return s;
		}
		
		
		
		/** @private */
		protected function isValidLength(s:String):Boolean
		{
			// verify length of id is within set limits
			return ((s.length >= GAMEID_MIN) && (s.length <= GAMEID_MAX));
		}
		
		/** @private */
		protected function isValidChars(s:String):Boolean
		{
			// verify lack of any characters not in approved list
			var invalid:RegExp = /[^a-zA-Z0-9\._-]/;
			return !invalid.test(s);
		}
		
		/** @private */
		protected function pad(s:String, x:Number, c:String):String 
		{
			while (s.length < x) { s = c + s; }
			return s;
		}
		
		/** @private */
		protected function chunk(s:String, x:Number, c:String):String 
		{
			var ss:String = "";
			var i:int = 0;
			var n:int = s.length;
			while (i < n) 
			{ 
				ss = s.charAt(n-1 - i) +ss;
				i++;
				if (i % x == 0 && i < n) ss = c +ss;
			}
			return ss;
		}
		
		/** 
		Score insertion algorithm.
		Override for alternate implementations.
		
		<p>
		This implementation allows ties, but not duplicates, per the following rules:
		</p>
		
		<ul>
		<li>S and I must match in length (let's call that L)</li>
		<li>If L &lt; max, the list is not yet full; candidate will always be allowed</li>
		<li>If L == max, the list is full; candidate will only be allowed if the following are true:
			<ul>
			<li>the candidate score is &gt;= the lowest score in the list</li>
			<li>if the candidate score is equal to another score already in the list, 
			the candidate initial must be different</li>
			</ul></li>
		<li>When the candidate is added to a full list, the lowest score is removed</li>
		</ul>
		
		@param score Numeric score; candidate for insertion
		@param initial String associated with score
		@param S array of numeric scores
		@param I array of string initials
		@param max Upper limit for total number of scores and initials
		*/
		protected function _insert(score:Number, initial:String, S:Array, I:Array, max:uint):Boolean 
		{
			if (S.length != I.length) throw new Error("Number of scores does not match number of initials");
			
			var added:Boolean = false;
			
			if (S.length == 0) 
			{
				S.push(score);
				I.push(initial);
				added = true;
			}
			else 
			{
				var resolved:Boolean = false;
				var k:int = 0;

				while (k < S.length) 
				{

					if (score > S[k]) 
					{
						resolved = true;
						S.splice(k, 0, score);
						I.splice(k, 0, initial);
						added = true;
						break;
					}

					if (score == S[k]) 
					{
						resolved = true;
						while (
							(k < S.length) &&
							(score == S[k])
						) {
							if (initial == I[k]) { return false; }
							k++;
						}
						S.splice(k, 0, score);
						I.splice(k, 0, initial);
						added = true;
						break;
					}

					k++;
				}

				if (S.length > max) 
				{
					S.pop();
					I.pop();
				}
				else if (!resolved && (S.length < max)) {
					S.push(score);
					I.push(initial);
					added = true;
				}
			}
			
			return added;
		}

	}

}
