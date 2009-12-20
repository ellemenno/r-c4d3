

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
		
		
		override public function initialize():Boolean
		{
			if (!super.initialize()) return false;
			
			backgroundColor = 0x333333;
			var title:TextField = addChild(FontAssets.createTextField("Setup Screen", FontAssets.blojbytesdepa())) as TextField;
			title.x = 15;
			title.y = 15;
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
			return super.shutDown();;
		}
		
		override public function onFrameUpdate(dt:int):void
		{
			super.onFrameUpdate(dt);
			
			if (timeElapsed > 3*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
