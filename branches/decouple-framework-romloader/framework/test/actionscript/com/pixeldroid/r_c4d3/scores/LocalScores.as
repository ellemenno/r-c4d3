
package com.pixeldroid.r_c4d3.scores
{
	
	import com.pixeldroid.r_c4d3.data.DataEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.LocalGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;
	
	import org.flexunit.Assert;
	
	
	public class LocalScores {
		
		protected var highScores:IGameScoresProxy;
		
		[Before]
		public function setUp():void
		{
			highScores = createScoresProxy();
			Assert.assertTrue("scores proxy is a LocalGameScoresProxy", (highScores is LocalGameScoresProxy));
			Assert.assertNotNull("scores proxy is not null", highScores);
		}
		
		[After]
		public function tearDown():void
		{
			highScores.closeScoresTable();
			highScores = null;
		}
		
		[Test]
		public function simpleLoad():void
		{
			// local scores does use events, but is not asynchronous
			highScores.addEventListener(ScoreEvent.LOAD, onLoaded, false,0,true);
			highScores.addEventListener(DataEvent.ERROR, onError, false,0,true);
			highScores.load();
		}

		[Test]
		public function simpleStore():void
		{
			// local scores does use events, but is not asynchronous
			highScores.addEventListener(ScoreEvent.SAVE, onSaved, false,0,true);
			highScores.addEventListener(DataEvent.ERROR, onError, false,0,true);
			highScores.store();
		}
		
		
		
		protected function onSaved(e:ScoreEvent):void
		{
			Assert.assertTrue("save completed successfully: " +e.message, e.success);
		}
		
		protected function onLoaded(e:ScoreEvent):void
		{
			Assert.assertTrue("load completed successfully: " +e.message, e.success);
		}
		
		protected function onError(e:DataEvent):void
		{
			Assert.fail(e.message);
		}
		
		
		
		protected function createScoresProxy(capacity:int=10, gameId:String="test.ScoreEntry"):IGameScoresProxy
		{
			return new LocalGameScoresProxy(gameId, capacity);
		}
	
	}
}

