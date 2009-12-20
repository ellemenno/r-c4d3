

package view.screen.attractloop
{

	import flash.display.DisplayObject;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;

	import model.AsteroidsModel;
	import view.screen.game.AsteroidsScreen;
	
	
	
	public class GameScreen extends ScreenBase
	{
		
		private var gameModel:AsteroidsModel;
		private var gameView:AsteroidsScreen;
		
		
		public function GameScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			if (!super.initialize()) return false;
			
			gameModel = new AsteroidsModel();
			//TODO: gameModel.initialize();
			
			gameView = addChild(new AsteroidsScreen() as DisplayObject) as AsteroidsScreen;
			gameView.initialize();
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
			//TODO: gameModel.stop();
			gameModel = null;
			/*
			gameView.shutDown();
			removeChild(gameView);
			gameView = null;
			*/
			
			return super.shutDown();
		}
		
		// IController interface (pass-thru)
		override public function onScreenUpdate(dt:int):void
		{
			super.onScreenUpdate(dt);
			
			gameModel.tick(dt);
			//TODO: poll model and update view
			gameView.onScreenUpdate(dt);
			
			if (timeElapsed > 3*1000) gameOver();
		}
		
		override public function onHatMotion(e:JoyHatEvent):void
		{
			// switch on e.player, then handle up/dn/lf/rg to update model
		}
		
		override public function onButtonMotion(e:JoyButtonEvent):void
		{
			// switch on e.player, then handle x/a/b/c to update model
		}
		
		
		private function gameOver():void
		{
			C.out(this, "gameOver - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
