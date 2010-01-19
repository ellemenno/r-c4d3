

package view.screen
{

	import flash.display.DisplayObject;
	
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;

	import GameSignals;
	import model.GameModel;
	import model.GlobalModel;
	import view.GameView;
	
	
	
	public class GameScreen extends ScreenBase
	{
		
		private var gameModel:GameModel;
		private var gameView:GameView;
		private var gameIsOver:Boolean;
		
		
		public function GameScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		
		// IDisposable interface
		override public function initialize():Boolean
		{
			backgroundColor = 0x000000;
			
			gameModel = new GameModel();
			gameModel.initialize();
			
			gameView = new GameView();
			addChild(gameView);
			gameView.initialize();
			
			gameIsOver = false;
			
			// attach listeners to messaging service
			Notifier.addListener(GameSignals.GAME_OVER, gameOver);
			
			stage.frameRate = 60;
			
			return super.initialize();
		}
		
		override public function shutDown():Boolean
		{
			gameModel.shutDown();
			gameModel = null;
			
			gameView.shutDown();
			removeChild(gameView);
			gameView = null;
			
			// attach listeners to messaging service
			Notifier.removeListener(GameSignals.GAME_OVER, gameOver);
			
			return super.shutDown();
		}

		
		
		// IController interface (pass-thru)
		override public function onUpdateRequest(dt:int):void
		{
			if (!gameIsOver) 
			{
				super.onUpdateRequest(dt);
				
				gameModel.onUpdateRequest(dt);
				gameView.onUpdateRequest(dt);
			}
		}
		
		override public function onHatMotion(e:JoyHatEvent):void
		{
			if (!gameIsOver) 
			{
				super.onHatMotion(e);
				if (GlobalModel.activePlayers[e.which] == true) gameModel.onHatMotion(e);
			}
		}
		

		
		private function gameOver():void
		{
			gameIsOver = true;
			C.out(this, "gameOver - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
