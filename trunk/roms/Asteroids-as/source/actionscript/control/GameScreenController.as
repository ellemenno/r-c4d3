

package control
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	
	import control.Signals;
	import util.IDisposable;
	import util.f.Message;
	import view.screen.ScreenBase;
	import view.screen.ScreenFactory;
	
	
	
	public class GameScreenController implements IDisposable
	{
		
		private var controlsProxy:IGameControlsProxy;
		private var screenContainer:DisplayObjectContainer;
		private var screenFactory:ScreenFactory;
		private var currentScreen:ScreenBase;
		
		
		// Constructor
		public function GameScreenController(controls:IGameControlsProxy, container:DisplayObjectContainer)
		{
			C.out(this, "constructor");
			controlsProxy = controls;
			screenContainer = container;
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			if (!currentScreen.shutDown()) throw new Error("ERROR: " +currentScreen.name +" unable to shut down");
			
			// remove listeners from controls proxy and prep for garbage collection
			controlsProxy.removeEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.removeEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			controlsProxy = null;
			
			screenContainer = null;
			
			// remove listeners from messaging service
			Message.remove(Signals.ATTRACT_LOOP_BEGIN);
			Message.remove(Signals.SCREEN_GO_NEXT);
			Message.remove(Signals.GAME_BEGIN);
			Message.remove(Signals.GAME_TICK);
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			screenFactory = new ScreenFactory();
			currentScreen = screenFactory.nullScreen;
			
			// attach listeners to controls proxy
			controlsProxy.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			
			// attach listeners to messaging service
			Message.add(nextScreen, Signals.ATTRACT_LOOP_BEGIN);
			Message.add(nextScreen, Signals.SCREEN_GO_NEXT);
			Message.add(gameBegin, Signals.GAME_BEGIN);
			Message.add(gameTick, Signals.GAME_TICK);
			
			return true;
		}
		
		
		
		// event handlers
		private function onHatMotion(e:JoyHatEvent):void
		{
			currentScreen.onHatMotion(e);
		}
		
		private function onButtonMotion(e:JoyButtonEvent):void
		{
			currentScreen.onButtonMotion(e);
		}
		
		
		
		// message callbacks
		private function gameTick(e:Object):void
		{
			currentScreen.onFrameUpdate(e as int);
		}
		
		private function nextScreen(e:Object):void
		{
			C.out(this, "nextScreen()");
			switch (currentScreen.name)
			{
				case ScreenFactory.NULL:
				setCurrentScreen(screenFactory.titleScreen);
				break;
				
				case ScreenFactory.TITLE:
				setCurrentScreen(screenFactory.helpScreen);
				break;
				
				case ScreenFactory.HELP:
				setCurrentScreen(screenFactory.setupScreen);
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
				
				default:
				throw new Error("ERROR: unrecognized screen type '" +currentScreen.name +"'");
				break;
			}
		}
		
		private function gameBegin(e:Object):void
		{
			C.out(this, "gameBegin()");
			setCurrentScreen(screenFactory.setupScreen);
		}
		
		
		
		// utility
		private function setCurrentScreen(screen:ScreenBase):void
		{
			var prevScreen:String = currentScreen.name;
			
			var isShutDown:Boolean = currentScreen.shutDown();
			if (!isShutDown) throw new Error("ERROR: " +prevScreen +" unable to shut down");
			
			while (screenContainer.numChildren > 0) screenContainer.removeChildAt(0);
			currentScreen = screenContainer.addChild(screen as DisplayObject) as ScreenBase;
			C.out(this, "setCurrentScreen() - moving from " +prevScreen +" to " +currentScreen.name);
			
			var isInitialized:Boolean = currentScreen.initialize();
			if (!isInitialized) throw new Error("ERROR: " +currentScreen.name +" unable to initialize");
		}
	}
}