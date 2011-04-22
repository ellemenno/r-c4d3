
package com.pixeldroid.r_c4d3.scores
{
	
	import com.pixeldroid.r_c4d3.scores.GameScoresProxy;
	
	import org.flexunit.Assert;
	
	
	public class GameIdValidation {
		
		[Test]
		public function lengthEqualToMinCharsIsValid():void
		{
			var name:String = repeatChar("a", GameScoresProxy.GAMEID_MIN);
			Assert.assertEquals(name.length, GameScoresProxy.GAMEID_MIN);
			assertGoodName(name);
		}
		
		[Test]
		public function lengthEqualToMaxCharsIsValid():void
		{
			var name:String = repeatChar("a", GameScoresProxy.GAMEID_MAX);
			Assert.assertEquals(name.length, GameScoresProxy.GAMEID_MAX);
			assertGoodName(name);
		}
		
		[Test]
		public function lengthBetweenMinAndMaxCharsIsValid():void
		{
			var midlength:int = .5 * (GameScoresProxy.GAMEID_MAX - GameScoresProxy.GAMEID_MIN) + GameScoresProxy.GAMEID_MIN;
			var name:String = repeatChar("a", midlength);
			Assert.assertTrue(name.length > GameScoresProxy.GAMEID_MIN);
			Assert.assertTrue(name.length < GameScoresProxy.GAMEID_MAX);
			assertGoodName(name);
		}
		
		
		[Test]
		public function emptyStringIsNotValid():void
		{
			var name:String = "";
			assertBadName(name);
		}
		
		[Test]
		public function lengthShorterThanMinCharsIsNotValid():void
		{
			var name:String = "a";
			Assert.assertTrue(
				name.length +" < " +GameScoresProxy.GAMEID_MIN,
				name.length < GameScoresProxy.GAMEID_MIN
			);
			assertBadName(name);
		}
		
		[Test]
		public function lengthLongerThanMaxCharsIsNotValid():void
		{
			var name:String = repeatChar("a", GameScoresProxy.GAMEID_MAX + 1);
			Assert.assertTrue(
				name.length +" > " +GameScoresProxy.GAMEID_MAX,
				name.length > GameScoresProxy.GAMEID_MAX
			);
			assertBadName(name);
		}
		
		
		protected const badChars:String = " `~!@#$%^&*()=+|[{]};:',<>/?\r\n\t\"\\";
		
		[Test]
		public function badCharsAreNotValid():void
		{
			for (var i:int = 0, n:int = badChars.length; i < n; i++)
			{
				var name:String = repeatChar(badChars.charAt(i), GameScoresProxy.GAMEID_MIN);
				Assert.assertEquals(name.length, GameScoresProxy.GAMEID_MIN);
				assertBadName(name);
			}
		}
		
		protected const goodChars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-";
		
		[Test]
		public function goodCharsAreValid():void
		{
			for (var i:int = 0, n:int = goodChars.length; i < n; i++)
			{
				var name:String = repeatChar(goodChars.charAt(i), GameScoresProxy.GAMEID_MIN);
				Assert.assertEquals(name.length, GameScoresProxy.GAMEID_MIN);
				assertGoodName(name);
			}
		}
		
		
		protected function repeatChar(char:String, length:int):String
		{
			var string:String = "";
			while (string.length < length) string += char;
			return string;
		}
		
		protected function isValidName(name:String):Boolean
		{
			var isValid:Boolean = true;
			try { new GameScoresProxy(name); }
			catch (e:Error) { isValid = false; }
			return isValid;
		}
		
		protected function assertBadName(name:String):void
		{
			Assert.assertFalse("'" +name +"' should NOT be valid", isValidName(name));
		}
		
		protected function assertGoodName(name:String):void
		{
			Assert.assertTrue("'" +name +"' should be valid", isValidName(name));
		}
		
	}
}


