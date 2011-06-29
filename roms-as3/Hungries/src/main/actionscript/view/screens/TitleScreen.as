

package view.screens
{
	
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	
	import FontAssets;
	
	
	
	public class TitleScreen extends ScreenBase
	{
		
		override protected function handleFirstScreen():void
		{
			backgroundColor = 0x777777;
			var title:TextField = addChild(FontAssets.createTextField("HUNGRIES", FontAssets.deLarge(120, 0xffffff, TextFormatAlign.CENTER), width)) as TextField;
			title.x = width*.5 - title.width*.5;
			title.y = height*.5 - title.height*.75;
		}
		
		override protected function handleUpdateRequest(dt:int):void
		{
			if (timeElapsed > 3*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut() - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
