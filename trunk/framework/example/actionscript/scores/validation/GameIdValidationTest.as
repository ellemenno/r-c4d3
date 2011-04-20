

package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.pixeldroid.r_c4d3.scores.GameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	import com.pixeldroid.r_c4d3.tools.console.Console;
	
	import com.pixeldroid.r_c4d3.Version;
	import com.pixeldroid.r_c4d3.tools.contextmenu.ContextMenuUtil;
	
	
	[SWF(width="600", height="400", frameRate="1", backgroundColor="#000000")]
    public class GameIdValidationTest extends Sprite
	{
	
		private var console:Console;
		
		
		public function GameIdValidationTest():void
		{
			super();
			addVersion();
			
			console = addChild(new Console(stage.stageWidth, stage.stageHeight)) as Console;
			C.enable(console);
			
			C.out(this, Version.productInfo);
			
			checkNames();
		}
		
		private function addVersion():void
		{
			ContextMenuUtil.addItem(this, Version.productInfo, false);
			ContextMenuUtil.addItem(this, Version.buildInfo, false);
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
					C.out(this, "- " +names[i]);
				}
				catch (e:Error) { C.out(this, "X " +names[i] +" " +e); }
			}
		}
		
	}
}

