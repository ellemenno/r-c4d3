

package screen
{
	
	import flash.text.TextField;
	
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	
	import FontAssets;
	
	
	
	public class HelpScreen extends ScreenBase
	{
		
		
		public function HelpScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override protected function onFirstScreen():void
		{
			backgroundColor = 0x555555;
			var text:String = "" +
				"How To Play:\n\n" +	
				"Get to the spot!" +
				"";
			var textField:TextField = addChild(FontAssets.createTextField(text, FontAssets.telegramaRender(24, 0xffffff), width*.5)) as TextField;
			textField.x = width*.5 - textField.width*.5;
			textField.y = height*.5 - textField.height*.75;
		}
		
		override public function onUpdateRequest(dt:int):void
		{
			super.onUpdateRequest(dt);
			
			if (timeElapsed > 1.5*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
