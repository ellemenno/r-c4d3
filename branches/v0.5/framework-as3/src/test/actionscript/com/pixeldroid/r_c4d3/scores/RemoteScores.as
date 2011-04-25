
package com.pixeldroid.r_c4d3.scores
{
	
	import com.pixeldroid.r_c4d3.data.DataEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.RemoteGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;	
	
	
	public class RemoteScores {
		
		protected const ACCESSURL:String = "http://accad.osu.edu/arcade/scores/";
		protected const GAMEID:String = "test";
		protected const TIMEOUT:int = 5000;
		
		protected var highScores:IGameScoresProxy;
		
		[Before]
		public function setUp():void
		{
			highScores = createScoresProxy();
			Assert.assertTrue("scores proxy is a RemoteGameScoresProxy", (highScores is RemoteGameScoresProxy));
			Assert.assertNotNull("scores proxy is not null", highScores);
		}
		
		[After]
		public function tearDown():void
		{
			highScores.closeScoresTable();
			highScores = null;
		}
		
		[Test(async)]
		public function simpleLoad():void
		{
			highScores.addEventListener(ScoreEvent.LOAD, createAsyncHandler(onLoaded, onTimeout), false,0,true);
			highScores.addEventListener(DataEvent.ERROR, createAsyncHandler(onError, onTimeout), false,0,true);
			highScores.load();
		}

		[Test(async)]
		public function simpleStore():void
		{
			highScores.addEventListener(ScoreEvent.SAVE, createAsyncHandler(onSaved, onTimeout), false,0,true);
			highScores.addEventListener(DataEvent.ERROR, createAsyncHandler(onError, onTimeout), false,0,true);
			highScores.store();
		}
		
		
		
		protected function onSaved(e:ScoreEvent, passThroughData:Object):void
		{
			Assert.assertTrue("save completed successfully: " +e.message, e.success);
		}
		
		protected function onLoaded(e:ScoreEvent, passThroughData:Object):void
		{
			Assert.assertTrue("load completed successfully: " +e.message, e.success);
		}
		
		protected function onError(e:DataEvent, passThroughData:Object):void
		{
			Assert.fail(e.message);
		}
		
		protected function onTimeout(passThroughData:Object):void
		{
			Assert.fail("Method timed out.");
		}
		
		
		
		protected function createAsyncHandler(onCompletion:Function, onTimeout:Function, timeoutMillis:int=TIMEOUT, dataObject:Object=null):Function
		{
			return Async.asyncHandler(this, onCompletion, timeoutMillis, dataObject, onTimeout);
		}
		
		protected function createScoresProxy(capacity:int=10, gameId:String=GAMEID, accessUrl:String=ACCESSURL):IGameScoresProxy
		{
			return new RemoteGameScoresProxy(gameId, accessUrl, capacity);
		}
	
	}
}

