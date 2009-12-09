
package com.pixeldroid.r_c4d3.interfaces
{
	
	import flash.events.IEventDispatcher;
	
	
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
		* Open an existing scores table or try to create a new one with the given game id.
		* <p>Must be called with a valid game id before any scores transactions can take place.
		* Valid game ids must be 1 - 32 lowercase alpha characters in length
		*
		* @param gameId A valid game id
		*/
		function openScoresTable(gameId:String):void;
		
		/**
		* Terminate access to scores and clean up.
		* 
		* <p><em>Note:</em> Call <code>store()</code> to push latest scores to storage before closing.</p>
		*
		* @see #store
		*/
		function closeScoresTable():void;
		
		
		/**
		* Retrieve the scores from the server.
		*
		* <p>Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.LOAD</code></p>
		*
		* @see com.pixeldroid.r_c4d3.scores.ScoreEvent#LOAD
		*/
		function load():void;
		
		/**
		* Submit the scores to the server.
		*
		* <p>Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.SAVE</code></p>
		*
		* @see com.pixeldroid.r_c4d3.scores.ScoreEvent#SAVE
		*/
		function store():void;
		
		/**
		* Clear the high score list, erasing all scores and initials.
		*
		* Empty scorelist is not recorded to storage medium until <code>store</code> is called
		*
		* @see #store
		*/
		function clear():void;
		
		
		/**
		* Retrieve the currently active game id.
		*/
		function get gameId():String;
		
		/**
		* Retrieve the total number of slots allocated for score storage (maximium of 100, default of 10)
		*
		* <p>Read only, set via the HighScores constructor. See length for the 
		* actual number of scores currently in the high scores table</p>
		*
		* @see #length
		*/
		function get totalScores():int;
		
		
		/**
		* Retrieve the total number of entries currently in the score list.
		*/
		function get length():uint;
		
		
		/**
		* Retrieve a score by zero-based rank index.
		* 
		* <p><em>Note:</em> Scores are stored in descending order (largest first).</p>
		*
		* @param i Index of score to retrieve. [0, MAX_SCORES)
		* @return The score matching the rank index; null if rank is invalid or no scores exist.
		*/
		function getScore(i:int):Number;
		
		/**
		* Retrieve all scores.
		* 
		* <p><em>Note:</em> Scores are stored in descending order (largest first).</p>
		*/
		function getAllScores():Array;
		
		
		/**
		* Retrieve a set of initials by zero-based rank index.
		* 
		* <p><em>Note:</em> Initials are stored in descending order based on the score they are associated with (largest first).</p>
		*
		* @param i Index of initials to retrieve. [0, MAX_SCORES)
		* @return The initials string matching the rank index; null if rank is invalid or no scores exist.
		*/
		function getInitials(i:int):String;
		
		/**
		* Retrieve all initials.
		* 
		* <p><em>Note:</em> Initials are stored in descending order based on the score they are associated with (largest first).</p>
		*/
		function getAllInitials():Array;
		
		
		/**
		* Submit a score and associated initials string for inclusion into the 
		* score list, possibly bumping off the lowest score, or failing to be added.
		* 
		* <p>The new score and initials string will be added in rank order if they qualify,
		* or not added at all if they don't.</p>
		* 
		* <p>If adding the new score and initals string creates more than
		* MAX_SCORES entries, then the lowest rank score will be bumped off the list.</p>
		*
		* @param s The score to add
		* @param i The string of initials to add
		* @return true if score was added, false if 
		*/
		function insert(s:Number, i:String):Boolean;
		
		/**
		* Submit all scores and initials into the score list at once.
		*
		* @param s The score to add
		* @param i The string of initials to add
		* @return Array of Booleans matching the input order; 
		* true if the corresponding score was added, false if not
		*/
		function insertAll(s:Array, i:Array):Array;
		
		
		/**
		* Generate a human-readable version of the score list.
		* @return A human-readable version of the contents of the score list.
		*/
		function toString():String;
		
	}
}