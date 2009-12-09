

package control
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	
	import control.IController;
	import control.Signals;
	import util.IDisposable;
	import util.f.Message;
	import view.screen.IScreen;
	import view.screen.ScreenBase;
	import view.screen.ScreenFactory;
	
	
	
	public class ScreenController implements IController, IDisposable
	{
		
		private var screenContainer:DisplayObjectContainer;
		private var screenFactory:ScreenFactory;
		private var currentScreen:ScreenBase;
		
		
		// Constructor
		public function ScreenController(container:DisplayObjectContainer)
		{
			C.out(this, "constructor", true);
			screenContainer = container;
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			currentScreen.shutDown();
			
			Message.remove(Signals.ATTRACT_LOOP_BEGIN);
			Message.remove(Signals.SCREEN_GO_NEXT);
			Message.remove(Signals.GAME_BEGIN);
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			screenFactory = new ScreenFactory();
			currentScreen = screenFactory.nullScreen;
			
			Message.add(nextScreen, Signals.ATTRACT_LOOP_BEGIN);
			Message.add(nextScreen, Signals.SCREEN_GO_NEXT);
			Message.add(gameBegin, Signals.GAME_BEGIN);
			
			return true;
		}
		
		
		
		// IController interface (pass-thru)
		public function onFrameUpdate(dt:int):void
		{
			currentScreen.onFrameUpdate(dt);
		}
		
		public function onHatMotion(e:JoyHatEvent):void
		{
			currentScreen.onHatMotion(e);
		}
		
		public function onButtonMotion(e:JoyButtonEvent):void
		{
			currentScreen.onButtonMotion(e);
		}
		
		
		
		// message callbacks
		private function nextScreen(e:Object):void
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
			
			C.out(this, "nextScreen() - moving from " +prevScreen +" to " +currentScreen.name);
			currentScreen.initialize();
		}
		
		private function gameBegin(e:Object):void
		{
			var prevScreen:String = currentScreen.name;
			currentScreen.shutDown();
			
			C.out(this, "gameBegin() - moving from " +prevScreen +" to " +currentScreen.name);
			setCurrentScreen(screenFactory.setupScreen);
			currentScreen.initialize();
		}
		
		
		
		// utility
		private function setCurrentScreen(screen:ScreenBase):void
		{
			while (screenContainer.numChildren > 0) screenContainer.removeChildAt(0);
			currentScreen = screenContainer.addChild(screen as DisplayObject) as ScreenBase;
		}
	}
}