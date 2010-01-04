

package com.pixeldroid.r_c4d3.game.control
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.interfaces.IDisposable;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory;
	
	
	
	/**
	Handles game state at the attract loop level by advancing through the screens specified in IGameScreenFactory.
	
	<p>
	Listens for the following signals: 
	ATTRACT_LOOP_BEGIN (start the attract loop), 
	SCREEN_GO_NEXT (advance to next screen in the attract loop), 
	GAME_BEGIN (jump to the setup screen), 
	GAME_TICK (ask the current screen to update)
	</p>
	
	@see IGameScreenFactory
	@see Signals
	*/
	public class GameScreenController implements IDisposable
	{
		
		protected var controlsProxy:IGameControlsProxy;
		protected var screenContainer:DisplayObjectContainer;
		protected var screenFactory:IGameScreenFactory;
		protected var currentScreen:ScreenBase;
		
		
		/**
		Constructor
		*/
		public function GameScreenController(controls:IGameControlsProxy, container:DisplayObjectContainer, factory:IGameScreenFactory)
		{
			C.out(this, "constructor");
			controlsProxy = controls;
			screenContainer = container;
			screenFactory = factory;
		}
		
		
		
		// IDisposable interface
		/** @inheritDoc */
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
		
		/** @inheritDoc */
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			currentScreen = screenContainer.addChild(screenFactory.getScreen(screenFactory.NULL) as DisplayObject) as ScreenBase;
			
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
		protected function onHatMotion(e:JoyHatEvent):void
		{
			currentScreen.onHatMotion(e);
		}
		
		protected function onButtonMotion(e:JoyButtonEvent):void
		{
			currentScreen.onButtonMotion(e);
		}
		
		
		
		// message callbacks
		protected function gameTick(dt:int):void
		{
			currentScreen.onUpdateRequest(dt);
		}
		
		protected function nextScreen():void
		{
			C.out(this, "nextScreen()");
			switch (currentScreen.name)
			{
				case screenFactory.NULL:
				setCurrentScreen(screenFactory.getScreen(screenFactory.TITLE));
				break;
				
				case screenFactory.TITLE:
				setCurrentScreen(screenFactory.getScreen(screenFactory.HELP));
				break;
				
				case screenFactory.HELP:
				setCurrentScreen(screenFactory.getScreen(screenFactory.SETUP));
				break;
				
				case screenFactory.SETUP:
				setCurrentScreen(screenFactory.getScreen(screenFactory.GAME));
				break;
				
				case screenFactory.GAME:
				setCurrentScreen(screenFactory.getScreen(screenFactory.SCORES));
				break;
				
				case screenFactory.SCORES:
				setCurrentScreen(screenFactory.getScreen(screenFactory.TITLE));
				break;
				
				default:
				throw new Error("ERROR: unrecognized screen type '" +currentScreen.name +"'");
				break;
			}
		}
		
		protected function gameBegin():void
		{
			C.out(this, "gameBegin()");
			setCurrentScreen(screenFactory.getScreen(screenFactory.SETUP));
		}
		
		
		
		// utility
		protected function setCurrentScreen(screen:ScreenBase):void
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