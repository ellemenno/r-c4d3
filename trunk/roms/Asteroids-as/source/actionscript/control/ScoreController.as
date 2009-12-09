

package control
{

	import flash.events.Event;

	import com.pixeldroid.r_c4d3.data.DataEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;
	
	import control.Signals;
	import util.IDisposable;
	import util.f.Message;
	
	
	
	public class ScoreController implements IDisposable
	{
		
		private var scoresProxy:IGameScoresProxy;
		
		
		// Constructor
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
			
			scoresProxy.closeScoresTable();
			scoresProxy = null;
			
			Message.remove(Signals.SCORES_RETRIEVE);
			Message.remove(Signals.SCORES_SUBMIT);
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			// attach listeners to proxy
			scoresProxy.addEventListener(ScoreEvent.LOAD, onScoresLoaded);
			scoresProxy.addEventListener(ScoreEvent.SAVE, onScoresSaved);
			scoresProxy.addEventListener(DataEvent.ERROR, onScoresError);
			
			Message.add(retrieveScores, Signals.SCORES_RETRIEVE);
			Message.add(submitScores, Signals.SCORES_SUBMIT);
			
			return true;
		}
		
		
		
		// event handlers
		private function onScoresLoaded(e:Event):void
		{
			C.out(this, "onScoresLoaded() - " +e);
			C.out(this, scoresProxy.toString())
		}
		
		private function onScoresSaved(e:Event):void
		{
			C.out(this, "onScoresSaved() - " +e);
		}
		
		private function onScoresError(e:Event):void
		{
			C.out(this, "onScoresError() - " +e);
		}
		
		
		
		// message callbacks
		private function retrieveScores(e:Object):void
		{
			C.out(this, "retrieveScores()");
			scoresProxy.load();
		}
		
		private function submitScores(e:Object):void
		{
			C.out(this, "submitScores()");
			/*
			TODO:
			var playerScores:Array = [
				{ score:1, initials:"a" },
			];
			var n:int = playerScores.length;
			for (var j:int = 0; j < n; j++)
			{
				if (scoresProxy.insert(playerScores[j].score, playerScores[j].initials)) C.out(this, "player " +playerScores[j].initials +" made the score table");
			}
			*/
		}
	}
}