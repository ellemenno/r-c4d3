

package view.screen.attractloop
{
	
	import flash.text.TextField;
	
	import FontAssets;
	
	import control.Signals;
	import util.Notifier;
	import view.screen.ScreenBase;
	
	
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
