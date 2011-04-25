

package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.GameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;
	import com.pixeldroid.r_c4d3.tools.console.Console;
	
	import com.pixeldroid.r_c4d3.Version;
	import com.pixeldroid.r_c4d3.tools.contextmenu.ContextMenuUtil;
	
	
	[SWF(width="600", height="400", frameRate="1", backgroundColor="#000000")]
    public class GameScoresProxyTest extends Sprite
	{
	
		protected var console:Console;
		protected var scores:IGameScoresProxy;
		
		
		public function GameScoresProxyTest():void
		{
			super();
			addVersion();
			
			console = addChild(new Console(stage.stageWidth, stage.stageHeight)) as Console;
			C.enable(console);
			
			C.out(this, Version.productInfo);
			
			scores = createScoresProxy();
			scores.addEventListener(ScoreEvent.SAVE, onSave);
			scores.addEventListener(ScoreEvent.LOAD, onLoad);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		
		
		private function addVersion():void
		{
			ContextMenuUtil.addItem(this, Version.productInfo, false);
			ContextMenuUtil.addItem(this, Version.buildInfo, false);
		}
		
		protected function createScoresProxy():IGameScoresProxy
		{
			return new GameScoresProxy("GameScoresProxyTest");
		}
		
		protected function onSave(e:ScoreEvent):void
		{
			C.out(this, e.toString());
		}
		
		protected function onLoad(e:ScoreEvent):void
		{
			C.out(this, e.toString());
		}
		
		
		protected function onFrame(e:Event):void
		{
			C.out(this, "\n" +scores.toString());
			C.out(this, " ");
			
			var i:String;
			var s:Number;
			if (scores.length > 0)
			{
				i = scores.getInitials(rnd(scores.length));
				if (rnd(10) < 5) s = scores.getScore(rnd(scores.length));
			}
			scores.insertEntries( makeEntries(s, i) );
		}
		
		protected function makeEntries(s:Number=NaN, i:String=null):Array/*ScoreEntry*/
		{
			var A:Array = [];
			var score:Number;
			var initials:String;
			var n:int = rnd(15);
			while (A.length < n)
			{
				score = isNaN(s) ? rnd(999999999) : s;
				initials = (i == null) ? str(3) : i;
				A.push(new ScoreEntry(score, initials));
			}
			C.out(this, A.toString());
			C.out(this, " ");
			return A;
		}
		
		protected function rnd(hi:int, lo:int=0):int
		{
			return Math.floor(Math.random()*(hi-lo)) + lo;
		}
		
		protected function str(length:int):String
		{
			var alpha:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			var string:String = "";
			while (string.length < length) string += alpha.charAt(rnd(alpha.length));
			return string;
		}
		
	}
}

