

package com.pixeldroid.r_c4d3.scores 
{
	
	import flash.events.EventDispatcher;
	
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	

	/**
	* Base class for high score storage and retrieval.
	*
	* Notes:<ul>
	* <li>Scores are kept in descending order (highest first)</li>
	* <li>Ties are allowed (same score, different initials), duplicates are not</li>
	*/
	public class HighScores extends EventDispatcher implements IGameScoresProxy
	{
		
		
		private var _gameId:String; // subclasses access via gameId getter
		
		protected var MAX_SCORES:int;
		
		protected var scores:Array;
		protected var initials:Array;
		
		protected var storeEvent:ScoreEvent;
		protected var retrieveEvent:ScoreEvent;
		
		
		
		/**
		* Constructor.
		* 
		* @param id A unique identifier for this set of scores and initials
		* @param maxScores The maximum number of entries to store (up to 100)
		*/
		public function HighScores(id:String=null, maxScores:int=10)
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
			if (gameId.length > 0 && gameId.length <= 32 && isApprovedChars(gameId))
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
			var s:Number = (0 <= i && i < scores.length) ? scores[i] : null;
			return s;
		}
		
		/** @inheritdoc */
		public function getAllScores():Array { return scores.slice(); }
		
		/** @inheritdoc */
		public function getInitials(i:int):String 
		{
			var s:String = (0 <= i && i < initials.length) ? initials[i] : null;
			return s;
		}
		
		/** @inheritdoc */
		public function getAllInitials():Array { return initials.slice(); }
		
		
		/** @inheritdoc */
		public function insert(s:Number, i:String):Boolean 
		{
			return _insert(s, i, scores, initials, MAX_SCORES);
		}
		
		/** @inheritdoc */
		public function insertAll(s:Array, i:Array):Array
		{
			var n:int = Math.min(s.length, MAX_SCORES);
			var A:Array = [];
			for (var j:int = 0; j < n; j++)
			{
				A.push(_insert(s[j], i[j], scores, initials, MAX_SCORES));
			}
			return A;
		}
		
		
		/** @inheritdoc */
		override public function toString():String {
		
			var hr:String = "- - - - - - - - - - - - - - - -\n";
			var s:String = hr;
			s += " High Scores (game id = '" +_gameId +"')\n";
			
			var totalScores:uint = scores.length;
			var p:String;
			for (var i:uint = 0; i < totalScores; i++) {
				p = pad((i+1).toString(), 5, " ");
				s += p +". " +initials[i] +" : " +scores[i] +"\n";
			}
			s += hr;
			
			return s;
		}
		
		
		
		protected function initialize():void {
			scores = [];
			initials = [];
		}
		
		
		
		private function isApprovedChars(s:String):Boolean
		{
			return ("abc".match(/\W/g).length == 0);
		}
		
		private static function pad(s:String, x:Number, c:String):String {
			while (s.length < x) { s = c + s; }
			return s;
		}
		
		/*
		TODO: adding smaller scores first will give false positive, and then they'll be removed as the higher ones bump them out..
		need to receive all scores at once, sort highest first, then try adding and return results in matching array of booleans
		*/
		private static function _insert(score:Number, initial:String, S:Array, I:Array, max:uint):Boolean {
			var added:Boolean = false;
			
			if (S.length == 0) {
				S.push(score);
				I.push(initial);
				added = true;
			}
			
			else {
				var resolved:Boolean = false;
				var k:uint = 0;

				while (k < S.length) {

					if (score > S[k]) {
						resolved = true;
						S.splice(k, 0, score);
						I.splice(k, 0, initial);
						added = true;
						break;
					}

					if (score == S[k]) {
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

				if (S.length > max) {
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
