
package com.pixeldroid.r_c4d3.scores {
	
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	import com.pixeldroid.r_c4d3.scores.HighScores;

	
	
	/**
	<code>LocalHighScores</code> extends the abstract HighScores base class to
	store high scores and initials on the local hard drive,	using a local SharedObject.
	
	@see com.pixeldroid.r_c4d3.scores.HighScores
	*/
	public class LocalHighScores extends HighScores {
	
	
		/**
		Constructor.
		@param id A unique identifier for this set of scores and initials
		@param maxScores The maximum number of entries to store
		*/
		public function LocalHighScores(id:String=null, maxScores:int=10) {
			super(id, maxScores);
		}
		
		
		
		/**
		Retrieve the scores from local storage.
		<p>Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.LOAD</code></p>
		*/
		override public function load():void {
			if (!gameId) throw new Error("Error: openScoresTable() must be called prior to calling load");
			
			var message:String;
			var LSO:SharedObject = SharedObject.getLocal(gameId);
			
			if (LSO.data.scoreList == null)
			{
				message = "New local shared object created for '" +gameId +"'";
				LSO.data.scoreList = emptyScoreList;
			}
			else message = "Existing local shared object loaded from '" +gameId +"'";
			
			scores = LSO.data.scoreList.scores;
			initials = LSO.data.scoreList.initials;
			
			retrieveEvent.success = true;
			retrieveEvent.message = message;
			dispatchEvent(retrieveEvent);
		}
		
		
		/**
		Submit the scores to local storage.
		<p>Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.SAVE</code></p>
		*/
		override public function store():void {
			if (!gameId) throw new Error("Error: openScoresTable() must be called prior to calling store");
			
			var LSO:SharedObject = SharedObject.getLocal(gameId);
			if (LSO.data.scoreList == null) LSO.data.scoreList = emptyScoreList;
			
			LSO.data.scoreList.scores = this.scores;
			LSO.data.scoreList.initials = this.initials;
			var message:String = LSO.flush();
			
			storeEvent.success = (message == SharedObjectFlushStatus.FLUSHED);
			storeEvent.message = message;
			dispatchEvent(storeEvent);
		}
		
		
		
		private function get emptyScoreList():Object { return { scores:[], initials:[] }; }
	
	}
	
}