

package view.screen.attractloop
{
	
	import flash.text.TextField;
	
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	
	import model.GlobalModel;
	
	import FontAssets;
	
	
	
	public class SetupScreen extends ScreenBase
	{
		
		
		public function SetupScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override protected function onFirstScreen():void
		{
			backgroundColor = 0x333333;
			var title:TextField = addChild(FontAssets.createTextField("Setup Screen", FontAssets.blojbytesdepa())) as TextField;
			title.x = 15;
			title.y = 15;
			
			for (var i:int = 0; i < GlobalModel.playerNames.length; i++)
			{
				GlobalModel.playerNames[i] = str(5);
			}
			C.out(this, "onFirstScreen - new player names are: " +GlobalModel.playerNames);
		}
		
		override public function onUpdateRequest(dt:int):void
		{
			super.onUpdateRequest(dt);
			
			if (timeElapsed > 3*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
		private function rnd(hi:int, lo:int=0):int
		{
			return Math.floor(Math.random()*(hi-lo)) + lo;
		}
		
		private function str(length:int):String
		{
			var alpha:String = "RRRRSSSSTTTTLLLLNNNNEEEEAAABCDEFGHIIIJKLMNOOOPQRSTUUUVWXYZ";
			var string:String = "";
			while (string.length < length) string += alpha.charAt(rnd(alpha.length));
			return string;
		}
		
	}
}
