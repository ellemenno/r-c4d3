
/*
from test/actionscript
mxmlc com/pixeldroid/r_c4d3/scores/GameIdValidationTest.as -sp=./ -sp=../../source/actionscript
*/
package com.pixeldroid.r_c4d3.scores
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.pixeldroid.r_c4d3.scores.GameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	import com.pixeldroid.r_c4d3.tools.console.Console;
	
	
	[SWF(width="600", height="400", frameRate="1", backgroundColor="#000000")]
    public class GameIdValidationTest extends Sprite
	{
	
		private var C:Console;
		
		
		public function GameIdValidationTest():void
		{
			super();
			addChildren();
			checkNames();
		}
		
		private function addChildren():void
		{
			C = addChild(new Console(stage.stageWidth, stage.stageHeight)) as Console;
		}
		
		private function checkNames():void
		{
			var names:Array = [
				"abc", "abc.def", "abc_def", "abc-def", "123456", "..9*9", 
				"..!yea", "..^_^", "<<>>", ":):)", "", "____", "a@bb",
				"A A A", "longer.than.thirty-two.characters."
			];
			var n:int = names.length;
			var gp:GameScoresProxy;
			for (var i:int = 0; i < n; i++)
			{
				try 
				{ 
					gp = new GameScoresProxy(names[i]); 
					C.out("- " +names[i]);
				}
				catch (e:Error) { C.out("X " +names[i] +" " +e); }
			}
		}
		
	}
}

