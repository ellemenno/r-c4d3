

package control
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	
	import control.Signals;
	import util.f.Message;
	import view.screen.IScreen;
	import view.screen.ScreenFactory;
	
	
	
	public class ScreenController
	{
		
		private var screenContainer:DisplayObjectContainer;
		private var screenFactory:ScreenFactory;
		private var currentScreen:IScreen;
		
		
		public function ScreenController(container:DisplayObjectContainer)
		{
			screenContainer = container;
			screenFactory = new ScreenFactory();
			currentScreen = screenFactory.nullScreen;
			
			Message.add(next, Signals.ATTRACT_LOOP_BEGIN);
			Message.add(next, Signals.SCREEN_GO_NEXT);
			Message.add(game, Signals.GAME_BEGIN);
		}
		
		
		public function set controls(controlProxy:IGameControlsProxy):void
		{
			controlProxy.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlProxy.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
		}
		
		
		// message callbacks
		private function next(e:Object):void
		{
			var prevScreen:String = currentScreen.name;
			currentScreen.shutDown();
			
			switch (prevScreen)
			{
				case ScreenFactory.NULL:
				setCurrentScreen(screenFactory.titleScreen);
				break;
				
				case ScreenFactory.TITLE:
				setCurrentScreen(screenFactory.helpScreen);
				break;
				
				case ScreenFactory.HELP:
				setCurrentScreen(screenFactory.scoresScreen);
				break;
				
				case ScreenFactory.SETUP:
				setCurrentScreen(screenFactory.gameScreen);
				break;
				
				case ScreenFactory.GAME:
				setCurrentScreen(screenFactory.scoresScreen);
				break;
				
				case ScreenFactory.SCORES:
				setCurrentScreen(screenFactory.titleScreen);
				break;
			}
			
			C.out(this, "next() - moving from " +prevScreen +" to " +currentScreen.name);
			currentScreen.initialize();
		}
		
		private function game(e:Object):void
		{
			setCurrentScreen(screenFactory.setupScreen);
		}
		
		
		// control events (pass-thru)
		public function onFrameUpdate(dt:int):void
		{
			currentScreen.onFrameUpdate(dt);
		}
		
		private function onHatMotion(e:JoyHatEvent):void
		{
			currentScreen.onHatMotion(e);
		}
		
		private function onButtonMotion(e:JoyButtonEvent):void
		{
			currentScreen.onButtonMotion(e);
		}
		
		
		// utility
		private function setCurrentScreen(screen:IScreen):void
		{
			while (screenContainer.numChildren > 0) screenContainer.removeChildAt(0);
			currentScreen = screenContainer.addChild(screen as DisplayObject) as IScreen;
		}
	}
}