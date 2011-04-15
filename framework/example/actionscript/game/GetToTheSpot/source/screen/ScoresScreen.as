

package screen
{
	
	import flash.text.TextField;
	
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	
	import FontAssets;
	
	
	
	public class ScoresScreen extends ScreenBase
	{
		
		protected var scores:TextField;
		
		
		
		public function ScoresScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		// IDisposable interface
		override public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			
			Notifier.removeListener(Signals.SCORES_READY, displayScores);
			
			return super.shutDown();
		}
		
		override public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			Notifier.addListener(Signals.SCORES_READY, displayScores);
			
			return super.initialize();
		}
		
		override protected function onFirstScreen():void
		{
			backgroundColor = 0x555555;
			var title:TextField = addChild(FontAssets.createTextField("High Scores", FontAssets.telegramaRender())) as TextField;
			title.x = 15;
			title.y = 15;
			
			scores = addChild(FontAssets.createTextField("loading scores...", FontAssets.telegramaRender())) as TextField;
			scores.x = 15;
			scores.width = stage.stageWidth - 15 - 15;
			scores.y = 15 + title.y + title.height;
			
			// send request for scores
			C.out(this, "onFirstScreen - sending SCREEN_RETRIEVE signal");
			Notifier.send(Signals.SCORES_RETRIEVE);
		}
		
		override public function onUpdateRequest(dt:int):void
		{
			super.onUpdateRequest(dt);
			
			if (timeElapsed > 5*1000) timeOut();
		}
		

		
		private function displayScores(scoresProxy:IGameScoresProxy):void
		{
			C.out(this, "displayScores - displaying latest scores from proxy");
			scores.text = scoresProxy.toString();
		}
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
