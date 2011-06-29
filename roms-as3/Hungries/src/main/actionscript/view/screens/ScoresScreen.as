

package view.screens
{
	
	import flash.text.TextField;
	
	import com.pixeldroid.r_c4d3.api.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	
	import FontAssets;
	
	
	
	public class ScoresScreen extends ScreenBase
	{
		
		protected var scores:TextField;
		
		
		override protected function customInitialization():Boolean
		{
			C.out(this, "customInitialization()");
			
			Notifier.addListener(Signals.SCORES_READY, displayScores);
			return true;
		}
		
		override protected function customShutDown():Boolean
		{
			C.out(this, "customShutDown()");
			
			Notifier.removeListener(Signals.SCORES_READY, displayScores);
			return true;
		}
		
		override protected function handleFirstScreen():void
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
			C.out(this, "handleFirstScreen() - sending SCREEN_RETRIEVE signal");
			Notifier.send(Signals.SCORES_RETRIEVE);
		}
		
		override protected function handleUpdateRequest(dt:int):void
		{
			if (timeElapsed > 15*1000) timeOut();
		}
		

		
		private function displayScores(scoresProxy:IGameScoresProxy):void
		{
			C.out(this, "displayScores() - displaying latest scores from proxy");
			scores.text = scoresProxy.toString();
		}
		
		private function timeOut():void
		{
			C.out(this, "timeOut() - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
