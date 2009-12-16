

package view.screen.attractloop
{
	
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import FontAssets;
	
	import control.Signals;
	import util.f.Message;
	import view.screen.ScreenBase;
	
	
	public class TitleScreen extends ScreenBase
	{
		
		
		public function TitleScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			if (!super.initialize()) return false;
			C.out(this, "initialize");
			
			backgroundColor = 0x777777;
			
			var title:TextField = addChild(FontAssets.createTextField("ASTEROIDS", FontAssets.deLarge(120, 0xffffff, TextFormatAlign.CENTER), width)) as TextField;
			title.x = width*.5 - title.width*.5;
			title.y = height*.5 - title.height*.75;
			
			Message.add(gameTick, Signals.GAME_TICK);
			
			return true;
		}
		private function gameTick(e:Object):void
		{
			C.out(this, "gameTick(" +(e as int) +")");
		}
		
		override public function shutDown():Boolean
		{
			graphics.clear();
			return super.shutDown();;
		}
		
		override public function onFrameUpdate(dt:int):void
		{
			C.out(this, "onFrameUpdate");
			super.onFrameUpdate(dt);
			
			if (timeElapsed > 3*1000) timeOut();
		}
		
		
		private function timeOut():void
		{
			C.out(this, "timeOut - sending SCREEN_GO_NEXT signal");
			Message.send(null, Signals.SCREEN_GO_NEXT);
		}
		
	}
}
