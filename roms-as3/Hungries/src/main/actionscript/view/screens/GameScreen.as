

package view.screens
{

	import flash.display.DisplayObject;
	
	import com.pixeldroid.r_c4d3.api.events.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;

	import model.GameSignals;
	import model.GameModel;
	import model.GlobalModel;
	import view.GameView;
	
	
	
	public class GameScreen extends ScreenBase
	{
		
		private var gameModel:GameModel;
		private var gameView:GameView;
		private var gameIsPlaying:Boolean = false;
		
		
		override protected function customInitialization():Boolean
		{
			C.out(this, "customInitialization() - setting frame rate to 60fps");
			
			backgroundColor = 0x000000;
			
			gameModel = new GameModel();
			gameModel.initialize();
			
			gameView = new GameView();
			addChild(gameView);
			gameView.initialize();
			
			// attach listeners to messaging service
			Notifier.addListener(GameSignals.GAME_OVER, gameOver);
			
			stage.frameRate = 60;
			
			return true;
		}
		
		override protected function customShutDown():Boolean
		{
			C.out(this, "customShutDown()");
			
			gameModel.shutDown();
			gameModel = null;
			
			gameView.shutDown();
			removeChild(gameView);
			gameView = null;
			
			// detach listeners from messaging service
			Notifier.removeListener(GameSignals.GAME_OVER, gameOver);
			
			return true;
		}

		override protected function handleFirstScreen():void
		{
			gameIsPlaying = true;
		}
		
		override protected function handleUpdateRequest(dt:int):void
		{
			if (gameIsPlaying) 
			{
				if (!gameModel || !gameView) C.out(this, "handleUpdateRequest() - model or view is null");
				gameModel.onUpdateRequest(dt);
				gameView.onUpdateRequest(dt);
			}
		}
		
		override protected function handleHatMotion(e:JoyHatEvent):void
		{
			if (gameIsPlaying) 
			{
				if (GlobalModel.activePlayers[e.which] == true) gameModel.onHatMotion(e);
			}
		}
		

		
		private function gameOver():void
		{
			gameIsPlaying = false;
			C.out(this, "gameOver() - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
