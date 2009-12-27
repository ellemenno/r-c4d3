

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
			
			// TODO: get num players from somewhere -- globals?
			gameModel = new AsteroidsModel(stage.stageWidth, stage.stageHeight, 4);
			gameModel.initialize();
			
			gameView = addChild(new AsteroidsScreen() as DisplayObject) as AsteroidsScreen;
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
		override public function onScreenUpdate(dt:int):void
		{
			super.onScreenUpdate(dt);
			
			gameModel.tick(dt);
			//view will receive notice sent from model and updates sprites accordingly
			
			// TODO: proper end game conditions
			if (timeElapsed > 5*1000) gameOver();
		}
		
		override public function onHatMotion(e:JoyHatEvent):void
		{
			super.onHatMotion(e);
			var player:int = e.which;
			//C.out(this, "player " +player +" e.value: " +e.value);
			
			if (e.isCentered) gameModel.coast(e.which);
			else
			{
				if (e.isDown)    gameModel.decelerate(e.which);
				else if (e.isUp) gameModel.accelerate(e.which);
				if (!e.isDown && !e.isUp) gameModel.noThrust(e.which);
				
				if (e.isLeft)       gameModel.turnLeft(e.which);
				else if (e.isRight) gameModel.turnRight(e.which);
				if (!e.isLeft && !e.isRight) gameModel.noTurn(e.which);
			}
		}
		
		override public function onButtonMotion(e:JoyButtonEvent):void
		{
			super.onButtonMotion(e);
			switch(e.button)
			{
				case JoyButtonEvent.BTN_X : gameModel.fire(e.which); break;
			}
		}
		
		
		private function gameOver():void
		{
			C.out(this, "gameOver - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
	}
}
