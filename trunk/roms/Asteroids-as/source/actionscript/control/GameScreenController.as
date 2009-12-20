

package control
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	
	import control.Signals;
	import util.IDisposable;
	import util.Notifier;
	import view.screen.ScreenBase;
	import view.screen.ScreenFactory;
	
	
	
	public class GameScreenController implements IDisposable
	{
		
		private var controlsProxy:IGameControlsProxy;
		private var screenContainer:DisplayObjectContainer;
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
			
			// shut down current screen and remove it from its container
			if (!currentScreen.shutDown()) throw new Error("ERROR: " +currentScreen.name +" unable to shut down");
			screenContainer.removeChild(currentScreen as DisplayObject);
			screenContainer = null;
			
			// remove listeners from controls proxy and prep for garbage collection
			controlsProxy.removeEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.removeEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			controlsProxy = null;
			
			// remove listeners from messaging service
			Notifier.removeListener(Signals.ATTRACT_LOOP_BEGIN, nextScreen);
			Notifier.removeListener(Signals.SCREEN_GO_NEXT, nextScreen);
			Notifier.removeListener(Signals.GAME_BEGIN, gameBegin);
			Notifier.removeListener(Signals.GAME_TICK, gameTick);
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			currentScreen = screenContainer.addChild(ScreenFactory.nullScreen as DisplayObject) as ScreenBase;
			
			// attach listeners to controls proxy
			controlsProxy.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			
			// attach listeners to messaging service
			Notifier.addListener(Signals.ATTRACT_LOOP_BEGIN, nextScreen);
			Notifier.addListener(Signals.SCREEN_GO_NEXT, nextScreen);
			Notifier.addListener(Signals.GAME_BEGIN, gameBegin);
			Notifier.addListener(Signals.GAME_TICK, gameTick);
			
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
				setCurrentScreen(ScreenFactory.titleScreen);
				break;
				
				case ScreenFactory.TITLE:
				setCurrentScreen(ScreenFactory.helpScreen);
				break;
				
				case ScreenFactory.HELP:
				setCurrentScreen(ScreenFactory.setupScreen);
				break;
				
				case ScreenFactory.SETUP:
				setCurrentScreen(ScreenFactory.gameScreen);
				break;
				
				case ScreenFactory.GAME:
				setCurrentScreen(ScreenFactory.scoresScreen);
				break;
				
				case ScreenFactory.SCORES:
				setCurrentScreen(ScreenFactory.titleScreen);
				break;
				
				default:
				throw new Error("ERROR: unrecognized screen type '" +currentScreen.name +"'");
				break;
			}
		}
		
		private function gameBegin(e:Object):void
		{
			C.out(this, "gameBegin()");
			setCurrentScreen(ScreenFactory.setupScreen);
		}
		
		
		
		// utility
		private function setCurrentScreen(screen:ScreenBase):void
		{
			var prevScreen:String = currentScreen.name;
			
			var isShutDown:Boolean = currentScreen.shutDown();
			if (!isShutDown) throw new Error("ERROR: " +prevScreen +" unable to shut down");
			screenContainer.removeChild(currentScreen as DisplayObject);
			
			currentScreen = screenContainer.addChild(screen as DisplayObject) as ScreenBase;
			C.out(this, "setCurrentScreen() - moving from " +prevScreen +" to " +currentScreen.name);
			
			var isInitialized:Boolean = currentScreen.initialize();
			if (!isInitialized) throw new Error("ERROR: " +currentScreen.name +" unable to initialize");
		}
	}
}