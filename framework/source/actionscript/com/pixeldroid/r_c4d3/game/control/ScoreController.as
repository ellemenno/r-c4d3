

package com.pixeldroid.r_c4d3.game.control
{

	import flash.events.Event;

	import com.pixeldroid.r_c4d3.data.DataEvent;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.interfaces.IDisposable;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;
	
	
	
	/**
	Handles communication with the IGameScoresProxy to retrieve and submit score data.
	
	<p>
	Listens for the following signals: 
	SCORES_RETRIEVE (load scores from the proxy), 
	SCORES_SUBMIT (save scores to the proxy), 
	</p>
	
	<p>
	Sends the following signal:
	SCORES_READY (score data retrieval has completed)
	</p>
	
	@see Signals
	*/
	public class ScoreController implements IDisposable
	{
		
		private var scoresProxy:IGameScoresProxy;
		
		
		/**
		Constructor
		*/
		public function ScoreController(scores:IGameScoresProxy)
		{
			C.out(this, "constructor");
			scoresProxy = scores;
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			
			// remove listeners from scores proxy and prep for garbage collection
			scoresProxy.removeEventListener(ScoreEvent.LOAD, onScoresLoaded);
			scoresProxy.removeEventListener(ScoreEvent.SAVE, onScoresSaved);
			scoresProxy.removeEventListener(DataEvent.ERROR, onScoresError);
			
			scoresProxy = null;
			
			Notifier.removeListener(Signals.SCORES_RETRIEVE, retrieveScores);
			Notifier.removeListener(Signals.SCORES_SUBMIT, submitScores);
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			// attach listeners to proxy
			scoresProxy.addEventListener(ScoreEvent.LOAD, onScoresLoaded);
			scoresProxy.addEventListener(ScoreEvent.SAVE, onScoresSaved);
			scoresProxy.addEventListener(DataEvent.ERROR, onScoresError);
			
			Notifier.addListener(Signals.SCORES_RETRIEVE, retrieveScores);
			Notifier.addListener(Signals.SCORES_SUBMIT, submitScores);
			
			return true;
		}
		
		
		
		// event handlers
		protected function onScoresLoaded(e:Event):void
		{
			C.out(this, "onScoresLoaded() - " +e);
			C.out(this, "\n" +scoresProxy.toString())
			
			Notifier.send(Signals.SCORES_READY, scoresProxy);
		}
		
		protected function onScoresSaved(e:Event):void
		{
			C.out(this, "onScoresSaved() - " +e);
		}
		
		protected function onScoresError(e:Event):void
		{
			C.out(this, "onScoresError() - " +e);
		}
		
		
		
		// message callbacks
		protected function retrieveScores():void
		{
			C.out(this, "retrieveScores()");
			scoresProxy.load();
		}
		
		protected function submitScores(entries:Array/*ScoreEntry*/):void
		{
			C.out(this, "submitScores() - received " +entries);
			scoresProxy.insertEntries(entries); // acceptance values modified in place
			scoresProxy.store();
		}
	}
}