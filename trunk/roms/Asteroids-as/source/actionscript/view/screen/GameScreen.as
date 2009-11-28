

package view.screen
{

	import flash.display.DisplayObject;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	
	import control.Signals;
	import model.AsteroidsModel;
	import util.f.Message;
	import view.screen.ScreenBase;
	import view.screen.AsteroidsScreen;
	
	
	
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
			C.out(this, "initialize()");
			gameModel = new AsteroidsModel();
			//TODO: gameModel.initialize();
			
			gameView = addChild(new AsteroidsScreen() as DisplayObject) as AsteroidsScreen;
			gameView.initialize();
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			//TODO: gameModel.stop();
			gameModel = null;
			
			gameView.shutDown();
			removeChild(gameView);
			gameView = null;
			
			return true;
		}
		
		// IController interface (pass-thru)
		override public function onFrameUpdate(dt:int):void
		{
			gameModel.tick(dt);
			// poll model and update view
			gameView.onFrameUpdate(dt);
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
			Message.send(null, Signals.SCREEN_GO_NEXT);
		}
		
	}
}
