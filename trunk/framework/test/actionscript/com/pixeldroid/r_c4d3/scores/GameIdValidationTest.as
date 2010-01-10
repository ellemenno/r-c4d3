
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
				"abc", "abc.def", "abc_def", "abc-def", "123", 
				"9*9", "!yea", "^_^", "<>", ":)", "", "_", "a@b",
				"A A A", "longer.than.thirty-two.characters."
			];
			C.out("''.length = " + ("".length));
			C.out("names[10].length = " + (names[10].length));
			var n:int = names.length;
			var gp:GameScoresProxy;
			for (var i:int = 0; i < n; i++)
			{
				try 
				{ 
					gp = new GameScoresProxy(names[i]); 
					C.out(names[i] +" passes");
				}
				catch (e:Error) { C.out(names[i] +" fails"); }
			}
		}
		
	}
}

