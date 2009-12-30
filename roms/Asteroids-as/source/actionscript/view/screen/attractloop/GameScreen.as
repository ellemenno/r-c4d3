

package view.screen.attractloop
{

	import flash.display.DisplayObject;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;

	import model.GameModel;
	import model.GlobalModel;
	import view.screen.game.GameView;
	
	
	
	public class GameScreen extends ScreenBase
	{
		
		private var gameModel:GameModel;
		private var gameView:GameView;
		
		
		public function GameScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			if (!super.initialize()) return false;
			
			gameModel = new GameModel(stage.stageWidth, stage.stageHeight, GlobalModel.activePlayers.length);
			gameModel.initialize();
			
			gameView = addChild(new GameView() as DisplayObject) as GameView;
			gameView.initialize();
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
			gameModel.shutDown();
			gameModel = null;
			
			gameView.shutDown();
			removeChild(gameView);
			gameView = null;
			
			return super.shutDown();
		}
		
		// IController interface (pass-thru)
		override public function onUpdateRequest(dt:int):void
		{
			super.onUpdateRequest(dt);
			
			gameModel.onUpdateRequest(dt);
			gameView.onUpdateRequest(dt);
			
			// TODO: proper end game conditions
			if (timeElapsed > 15*1000) gameOver();
		}
		
		override public function onHatMotion(e:JoyHatEvent):void
		{
			super.onHatMotion(e);
			if (GlobalModel.activePlayers[e.which] == false) return;
			
			var player:int = e.which;
			//C.out(this, "player " +player +" e.value: " +e.value);
			
			if (e.isLeft)       gameModel.turnLeft(e.which);
			else if (e.isRight) gameModel.turnRight(e.which);
			if (!e.isLeft && !e.isRight) gameModel.noTurn(e.which);
		}
		
		override public function onButtonMotion(e:JoyButtonEvent):void
		{
			super.onButtonMotion(e);
			
			if (GlobalModel.activePlayers[e.which] == false)
			{
				// TODO: announce new player joining game in progress
				C.out(this, "// TODO: announce new player joining game in progress");
				GlobalModel.activePlayers[e.which] = true;
			}
			
			switch(e.button)
			{
				case JoyButtonEvent.BTN_X : if (e.pressed == JoyButtonEvent.PRESSED) { gameModel.fire(e.which); } break;
				case JoyButtonEvent.BTN_A : gameModel.accelerate(e.which, e.pressed); break;
				case JoyButtonEvent.BTN_C : gameModel.decelerate(e.which, e.pressed); break;
			}
		}
		
		
		private function gameOver():void
		{
			C.out(this, "gameOver - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
