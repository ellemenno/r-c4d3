

package view.screen.attractloop
{
	
	import flash.text.TextField;
	
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	
	import FontAssets;
	
	
	
	public class ScoresScreen extends ScreenBase
	{
		
		
		public function ScoresScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override protected function onFirstScreen():void
		{
			backgroundColor = 0x555555;
			var title:TextField = addChild(FontAssets.createTextField("High Scores", FontAssets.blojbytesdepa())) as TextField;
			title.x = 15;
			title.y = 15;
		}
		
		override public function onScreenUpdate(dt:int):void
		{
			super.onScreenUpdate(dt);
			
			if (timeElapsed > 3*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
