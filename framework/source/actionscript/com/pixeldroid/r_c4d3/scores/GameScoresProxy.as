

package com.pixeldroid.r_c4d3.scores 
{
	
	import flash.events.EventDispatcher;
	
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	

	/**
	* Base class for high score storage and retrieval.
	*
	* <ul>
	* <li>Scores are kept in descending order (highest first)</li>
	* <li>Ties are allowed (same score, different initials), duplicates are not</li>
	* </ul>
	*/
	public class GameScoresProxy extends EventDispatcher implements IGameScoresProxy
	{
		
		/** Least number of characters a valid id may contain */
		public static const GAMEID_MIN:int = 4;
		
		/** Most number of characters a valid id may contain */
		public static const GAMEID_MAX:int = 32;
		
		private var _gameId:String; // subclasses access via gameId getter
		
		protected var MAX_SCORES:int;
		
		protected var scores:Array;
		protected var initials:Array;
		
		protected var storeEvent:ScoreEvent;
		protected var retrieveEvent:ScoreEvent;
		
		
		
		/**
		* Constructor.
		* 
		* @param id A unique identifier for this set of scores and initials.
		* Must be at least GAMEID_MIN characters long, but no longer than GAMEID_MAX.
		* @param maxScores The maximum number of entries to store (up to 100)
		*/
		public function GameScoresProxy(id:String, maxScores:int=10)
		{
			super();
			
			MAX_SCORES = Math.min(100, maxScores);
			if(id) openScoresTable(id);
			
			storeEvent = new ScoreEvent(ScoreEvent.SAVE);
			retrieveEvent = new ScoreEvent(ScoreEvent.LOAD);
			
			initialize();
		}
		
		
		
		/** @inheritdoc */
		public function openScoresTable(gameId:String):void
		{
			if (gameId.length >= GAMEID_MIN 
				&& gameId.length <= GAMEID_MAX 
				&& isApprovedChars(gameId)
			)
			{
				_gameId = gameId;
			}
			else throw new Error("Error: invalid game id '" +gameId+"'");
		}
		
		/** @inheritdoc */
		public function closeScoresTable():void { _gameId = null; }
		
		
		/**
		* Read the scores and initials from the storage medium.
		* <strong>To be overridden by subclasses</strong>
		*/
		public function load():void { /* sub-classes should override this method */ }
		
		/**
		* Write the scores and initials to the storage medium.
		* <strong>To be overridden by subclasses</strong>
		*/
		public function store():void { /* sub-classes should override this method */ }
		
		/** @inheritdoc */
		public function clear():void
		{
			scores = [];
			initials = [];
		}
		
		
		/** @inheritdoc */
		public function get length():uint { return scores.length; }
		
		/** @inheritdoc */
		public function get gameId():String { return _gameId; }
		
		/** @inheritdoc */
		public function get totalScores():int { return MAX_SCORES; }
		
		/** @inheritdoc */
		public function getScore(i:int):Number 
		{
			if (0 <= i && i < MAX_SCORES) return (i < scores.length) ? scores[i] : NaN;
			throw new Error("Invalid index: " +i +", valid range is 0 - " +(MAX_SCORES-1));
		}
		
		/** @inheritdoc */
		public function getAllScores():Array 
		{
			var A:Array = scores.slice();
			while (A.length < MAX_SCORES) A.push(NaN);
			return A; 
		}
		
		/** @inheritdoc */
		public function getInitials(i:int):String 
		{
			if (0 <= i && i < MAX_SCORES) return (i < initials.length) ? initials[i] : null;
			throw new Error("Invalid index: " +i +", valid range is 0 - " +(MAX_SCORES-1));
		}
		
		/** @inheritdoc */
		public function getAllInitials():Array 
		{ 
			var A:Array = initials.slice();
			while (A.length < MAX_SCORES) A.push(null);
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
			while (j++ < MAX_SCORES) { A.push(null); }
			
			return A; 
		}
		
		
		/** @inheritdoc */
		public function insertEntries(entries:Array):void
		{
			if (!entries || entries.length == 0) return; // nothing to do
			
			var index:Array = entries.sortOn("value", Array.DESCENDING | Array.RETURNINDEXEDARRAY | Array.NUMERIC);
			var n:int = Math.min(entries.length, MAX_SCORES);
			var e:ScoreEntry;
			for (var j:int = 0; j < n; j++)
			{
				e = ScoreEntry(entries[index[j]]);
				e.setAccepted(_insert(e.value, e.label, scores, initials, MAX_SCORES), this);
			}
		}
		
		
		/** @inheritdoc */
		override public function toString():String {
		
			var hr:String = "- - - - - - - - - - - - - - - -\n";
			var s:String = hr;
			s += " High Scores (game id = '" +_gameId +"', max " +MAX_SCORES +")\n";
			
			var n:int = scores.length;
			var p:String;
			for (var i:int = 0; i < n; i++) {
				p = pad((i+1).toString(), 5, " ");
				s += p +". " +initials[i] +" : " +scores[i] +"\n";
			}
			s += hr;
			
			return s;
		}
		
		
		
		/** @private */
		protected function initialize():void {
			scores = [];
			initials = [];
		}
		
		/** @private */
		protected function isApprovedChars(s:String):Boolean
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
