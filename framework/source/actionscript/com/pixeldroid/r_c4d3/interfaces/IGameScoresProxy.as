
package com.pixeldroid.r_c4d3.interfaces
{
	
	import flash.events.IEventDispatcher;
	
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	
	
	/**
	Dispatched when the score saving process has completed.
	@eventType com.pixeldroid.r_c4d3.scores.ScoreEvent.SAVE
	*/
	[Event(name="SAVE", type="com.pixeldroid.r_c4d3.scores.ScoreEvent")]
	
	/**
	Dispatched when the score retrieval process has completed.
	@eventType com.pixeldroid.r_c4d3.scores.ScoreEvent.LOAD
	*/
	[Event(name="LOAD", type="com.pixeldroid.r_c4d3.scores.ScoreEvent")]
	
	/**
	Dispatched when the score posting or retrieval process fails.
	@eventType com.pixeldroid.data.DataEvent.ERROR
	*/
	[Event(name="ERROR", type="com.pixeldroid.data.DataEvent")]


	/**
	Implementors provide access to high score storage and retrieval.
	*/
	public interface IGameScoresProxy extends IEventDispatcher
	{
		
		/**
		Open an existing scores table or try to create a new one with the given game id.
		
		<p>
		Must be called with a valid game id before any scores transactions can take place.
		Valid game ids must be 1 - 32 lowercase alpha characters in length.
		</p>
		
		@param gameId A valid game id
		*/
		function openScoresTable(gameId:String):void;
		
		/**
		Terminate access to scores and clean up.
		
		<p>
		<em>Note:</em> Call <code>store()</code> to push latest scores to storage before closing.
		</p>
		
		@see #store
		*/
		function closeScoresTable():void;
		
		
		/**
		Retrieve the scores from the server.
		
		<p>
		Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.LOAD</code>
		</p>
		
		@see com.pixeldroid.r_c4d3.scores.ScoreEvent#LOAD
		*/
		function load():void;
		
		/**
		Submit the scores to the server.
		
		<p>
		Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.SAVE</code>
		</p>
		
		@see com.pixeldroid.r_c4d3.scores.ScoreEvent#SAVE
		*/
		function store():void;
		
		/**
		Clear the high score list, erasing all scores and initials.
		
		<p>
		Empty scorelist is not recorded to storage medium until <code>store</code> is called
		</p>
		
		@see #store
		*/
		function clear():void;
		
		
		/**
		Retrieve the currently active game id.
		*/
		function get gameId():String;
		
		/**
		Retrieve the total number of slots allocated for score storage (maximium of 100, default of 10).
		
		<p>
		Read only, set via the HighScores constructor. See length for the 
		actual number of scores currently in the high scores table.
		</p>
		
		@see #length
		*/
		function get totalScores():int;
		
		
		/**
		Retrieve the total number of entries currently in the score list.
		*/
		function get length():uint;
		
		
		/**
		Retrieve a score by zero-based rank index.
		
		<p>
		<em>Note:</em> Scores are stored in descending order (largest first).
		</p>
		
		@param i Index of score to retrieve. [0, MAX_SCORES)
		@return The score matching the rank index; NaN if rank is invalid or no scores exist.
		*/
		function getScore(i:int):Number;
		
		/**
		Retrieve all scores, as an array of Numbers.
		
		<p>
		<em>Note:</em> Scores are stored in descending order (largest first); 
		'empty' slots contain <code>NaN</code>.
		</p>
		*/
		function getAllScores():Array/*Number*/;
		
		
		/**
		Retrieve a set of initials by zero-based rank index.
		
		<p>
		<em>Note:</em> Initials are stored in descending order based on the score they are associated with (largest first).
		</p>
		
		@param i Index of initials to retrieve. [0, MAX_SCORES)
		@return The initials string matching the rank index; null if rank is invalid or no scores exist.
		*/
		function getInitials(i:int):String;
		
		/**
		Retrieve all initials, as an array of Strings.
		
		<p>
		<em>Note:</em> Initials are stored in descending order based on the score they are associated with (largest first); 
		'empty' slots contain <code>null</code>.
		</p>
		*/
		function getAllInitials():Array/*String*/;
		
		
		/**
		Retrieve all entries, as an array of ScoreEntry instances.
		
		<p>
		<em>Note:</em> Entries are stored in descending order based on the score they are associated with (largest first); 
		'empty' slots contain <code>null</code>.
		</p>
		*/
		function getAllEntries():Array/*ScoreEntry*/;
		
		
		/**
		Submit a batch of score entry candidates into the score list at once.
		
		<p>
		The individual score entries will be added in rank order if they qualify,
		or not added at all if they don't.
		</p>
		
		<p>
		If adding the new score entries creates more than MAX_SCORES entries, 
		then the lowest rank score(s) will be rejected from the list, 
		possibly removing scores that were previously accepted.
		</p>
		
		<p>
		Array elements will be modified to update their <code>accepted</code> property, 
		to indicate inclusion into or rejection from the scores table, 
		but the order of the elements in the provided array will not be altered.
		</p>
		
		<p>
		Subsequent calls to insertEntries may result in updates to the high
		score table that invalidate previously provided <code>accepted</code> values.
		</p>
		
		@param entries Array of the score entries to add. 
		*/
		function insertEntries(entries:Array/*ScoreEntry*/):void;
		
		
		/**
		Generate a human-readable version of the score list.
		
		@return A human-readable version of the contents of the score list.
		*/
		function toString():String;
		
	}
}