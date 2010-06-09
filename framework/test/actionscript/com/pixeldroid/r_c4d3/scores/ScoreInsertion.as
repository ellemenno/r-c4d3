
package com.pixeldroid.r_c4d3.scores
{
	
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.GameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;
	
	import org.flexunit.Assert;
	
	
	public class ScoreInsertion {
		
		//TODO: test opening a new high score table
		//TODO: test clear
		
		[Test]
		public function emptyEntriesAreValid():void
		{
			var entries:Array = [];
			var scores:IGameScoresProxy = createScoresProxy();
			scores.insertEntries(entries);
			Assert.assertEquals("score list has no entries", 0, scores.length);
		}
		
		[Test]
		public function emptyScoreListHasEmptySlots():void
		{
			var capacity:int = 5;
			var entries:Array = [];
			var scores:IGameScoresProxy = createScoresProxy(capacity);
			scores.insertEntries(entries);
			Assert.assertEquals("score list has no entries", 0, scores.length);
			Assert.assertEquals("number of empty slots equal requested capacity", capacity, scores.emptySlots);
		}
		
		[Test]
		public function entriesReduceEmptySlots():void
		{
			var capacity:int = 5;
			var entries:Array = getEntries(capacity - 2);
			var scores:IGameScoresProxy = createScoresProxy(capacity);
			scores.insertEntries(entries);
			Assert.assertEquals("all entries were accepted", entries.length, scores.length);
			Assert.assertEquals("empty slots are reduced by number of entries", 2, scores.emptySlots);
		}
		
		[Test]
		public function extraEntriesAreValid():void
		{
			var capacity:int = 5;
			var entries:Array = getEntries(capacity + 2);
			var scores:IGameScoresProxy = createScoresProxy(capacity);
			scores.insertEntries(entries);
			assertFull(capacity, scores);
		}
		
		[Test]
		public function highestScoreIsFirstEntry():void
		{
			var entries:Array = getEntries(5);
			var highValue:int = entries.length - 1;
			var scores:IGameScoresProxy;
			
			// without extra capacity
			scores = createScoresProxy(entries.length);
			scores.insertEntries(entries);
			Assert.assertEquals(
				"highest value is at first postition", 
				highValue, scores.getScore(0)
			);
			
			// with extra capacity
			scores = createScoresProxy(entries.length + 3);
			scores.insertEntries(entries);
			Assert.assertEquals(
				"highest value is at first postition", 
				highValue, scores.getScore(0)
			);
		}
		
		[Test]
		public function lowestScoreIsLastEntry():void
		{
			var entries:Array = getEntries(5);
			var lowValue:int = 0;
			var scores:IGameScoresProxy;
			
			// without extra capacity
			scores = createScoresProxy(entries.length);
			scores.insertEntries(entries);
			Assert.assertEquals(
				"lowest value is at last (.length) postition", 
				lowValue, scores.getScore(scores.length - 1)
			);
			
			// with extra capacity
			scores = createScoresProxy(entries.length + 3);
			scores.insertEntries(entries);
			Assert.assertEquals(
				"lowest value is at last (.length) postition", 
				lowValue, scores.getScore(scores.length - 1)
			);
		}
		
		[Test]
		public function extraEntriesDropLowest():void
		{
			var entries:Array = getEntries(5);
			var capacity:int = 3;
			var scores:IGameScoresProxy = createScoresProxy(capacity);
			scores.insertEntries(entries);
			Assert.assertFalse("entry 0 is NOT accepted", ScoreEntry(entries[0]).accepted);
			Assert.assertFalse("entry 1 is NOT accepted", ScoreEntry(entries[1]).accepted);
			Assert.assertTrue("entry 2 is accepted", ScoreEntry(entries[2]).accepted);
			Assert.assertTrue("entry 3 is accepted", ScoreEntry(entries[3]).accepted);
			Assert.assertTrue("entry 4 is accepted", ScoreEntry(entries[4]).accepted);
			assertFull(capacity, scores);
		}
		
		[Test]
		public function withEmptySlotsLowScoreBumpsUp():void
		{
			var entries:Array = getEntries(5, 3);
			var scores:IGameScoresProxy = createScoresProxy(entries.length + 3);
			scores.insertEntries(entries);
			Assert.assertTrue("emptySlots > 0", (scores.emptySlots > 0));
			
			var oldLowValue:Number = scores.getScore(scores.length - 1);
			var newEntry:ScoreEntry = getEntry(oldLowValue - 1);
			scores.insertEntries([newEntry]);
			Assert.assertEquals(
				"old low entry is next to last", 
				oldLowValue, scores.getScore(scores.length - 2)
			);
			Assert.assertEquals(
				"new entry is at last postition", 
				newEntry.value, scores.getScore(scores.length - 1)
			);
		}
		
		[Test]
		public function withEmptySlotsHighScoreBumpsDown():void
		{
			var entries:Array = getEntries(5);
			var scores:IGameScoresProxy = createScoresProxy(entries.length + 3);
			scores.insertEntries(entries);
			Assert.assertTrue("emptySlots > 0", (scores.emptySlots > 0));
			
			var oldHighValue:Number = scores.getScore(0);
			var newEntry:ScoreEntry = getEntry(oldHighValue + 1);
			scores.insertEntries([newEntry]);
			Assert.assertEquals(
				"old high entry is at second postition", 
				oldHighValue, scores.getScore(1)
			);
			Assert.assertEquals(
				"new entry is at first postition", 
				newEntry.value, scores.getScore(0)
			);
		}
		
		[Test]
		public function withoutEmptySlotsLowScoreIsRejected():void
		{
			var capacity:int = 5;
			var entries:Array = getEntries(capacity, 3);
			var scores:IGameScoresProxy = createScoresProxy(capacity);
			scores.insertEntries(entries);
			assertFull(capacity, scores);
			
			var newEntry:ScoreEntry = getEntry(0);
			scores.insertEntries([newEntry]);
			assertFull(capacity, scores);
			
			var lowestValue:Number = scores.getScore(scores.length - 1);
			Assert.assertTrue("new entry is lower than lowest in list", (newEntry.value < lowestValue));
			Assert.assertFalse("new entry is NOT accepted", newEntry.accepted);
		}
		
		[Test]
		public function withoutEmptySlotsHighScoreBumpsOff():void
		{
			var capacity:int = 5;
			var entries:Array = getEntries(capacity);
			var scores:IGameScoresProxy = createScoresProxy(capacity);
			scores.insertEntries(entries);
			assertFull(capacity, scores);
			
			var newEntry:ScoreEntry = getEntry(capacity+1);
			scores.insertEntries([newEntry]);
			assertFull(capacity, scores);
			
			var highestValue:Number = scores.getScore(0);
			Assert.assertEquals("new entry is highest score", newEntry.value, highestValue);
		}
		
		
		protected function assertFull(capacity:int, scores:IGameScoresProxy):void
		{
			Assert.assertEquals("number of entries equals requested capacity", capacity, scores.length);
			Assert.assertEquals("empty slots equal zero", 0, scores.emptySlots);
		}
		
		protected function createScoresProxy(capacity:int=10, gameId:String="test.ScoreEntry"):IGameScoresProxy
		{
			return new GameScoresProxy(gameId, capacity);
		}
		
		protected function getEntry(i:int):ScoreEntry
		{
			return new ScoreEntry(i, i.toString());
		}
		
		protected function getEntries(n:int, initialValue:Number=0):Array/*<ScoreEntry>*/
		{
			var A:Array = [];
			var i:int = 0;
			while (i < n) A.push(getEntry(initialValue + i++));
			return A;
		}
		
	}
}


