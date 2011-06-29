

package view.screens
{
	
	import flash.text.TextField;
	
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	
	import FontAssets;
	
	
	
	public class HelpScreen extends ScreenBase
	{
		
		override protected function handleFirstScreen():void
		{
			backgroundColor = 0x555555;
			var text:String = "" +
				"How To Play:\n\n" +	
				"Eat dots for points.\n" +
				"Eat them quickly for more." +
				"";
			var textField:TextField = addChild(FontAssets.createTextField(text, FontAssets.telegramaRender(24, 0xffffff), width*.5)) as TextField;
			textField.x = width*.5 - textField.width*.5;
			textField.y = height*.5 - textField.height*.75;
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
