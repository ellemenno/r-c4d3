

package com.pixeldroid.r_c4d3.game.control
{

	import com.pixeldroid.r_c4d3.api.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.api.events.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.api.events.JoyHatEvent;
	import com.pixeldroid.r_c4d3.api.IDisposable;
	import com.pixeldroid.r_c4d3.game.screen.IGameScreenFactory;
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.game.screen.ScreenTypeEnumerator;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	
	
	/**
	Implements the attract loop, connecting and disconnecting screens to the 
	controls proxy and update requests.
	
	<p>
	Relies on a provided IGameScreenFactory to create the screens and manage 
	their advancement order.
	</p>
	
	<p>
	Listens for the following signals:
	</p>
	<ul>
	<li>ATTRACT_LOOP_BEGIN (start the attract loop)</li>
	<li>SCREEN_GO_NEXT (advance to next screen in the attract loop)</li>
	<li>SCREEN_GO_TO (advance to a specific screen, identified by type)</li>
	<li>GAME_BEGIN (jump to the setup screen)</li>
	<li>GAME_TICK (ask the current screen to update)</li>
	</ul>
	
	@see com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory
	@see com.pixeldroid.r_c4d3.game.control.Signals
	@see com.pixeldroid.r_c4d3.game.view.screen.ScreenTypeEnumerator
	*/
	public class GameScreenController implements IDisposable
	{
		
		protected var controlsProxy:IGameControlsProxy;
		protected var screenContainer:DisplayObjectContainer;
		protected var screenFactory:IGameScreenFactory;
		protected var currentScreen:ScreenBase;
		
		
		/**
		Constructor.
	
		@param controls An IGameControlsProxy (provided by the rom loader)
		@param container A DisplayObjectContainer for screens to be added and removed
		@param factory An IGameScreenFactory to create screens and determine screen order
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
			removeListeners();
			
			// shut down current screen and remove it from its container
			if (!currentScreen.shutDown()) throw new Error("ERROR: " +currentScreen.type +" unable to shut down");
			screenContainer.removeChild(currentScreen as DisplayObject);
			
			screenContainer = null;
			controlsProxy = null;
			
			return true;
		}
		protected function removeListeners():void
		{
			// remove listeners from controls proxy and prep for garbage collection
			controlsProxy.removeEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.removeEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			
			// remove listeners from messaging service
			Notifier.removeListener(Signals.ATTRACT_LOOP_BEGIN, attractLoopBegin);
			Notifier.removeListener(Signals.SCREEN_GO_NEXT, nextScreen);
			Notifier.removeListener(Signals.SCREEN_GO_TO, toScreen);
			Notifier.removeListener(Signals.GAME_BEGIN, gameBegin);
			Notifier.removeListener(Signals.GAME_TICK, gameTick);
		}
		
		/** @inheritDoc */
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			currentScreen = screenContainer.addChild(screenFactory.getScreen(screenFactory.loopStartScreenType) as DisplayObject) as ScreenBase;
			addListeners();			
			
			return true;
		}
		protected function addListeners():void
		{
			// attach listeners to controls proxy
			controlsProxy.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			
			// attach listeners to messaging service
			Notifier.addListener(Signals.ATTRACT_LOOP_BEGIN, attractLoopBegin);
			Notifier.addListener(Signals.SCREEN_GO_NEXT, nextScreen);
			Notifier.addListener(Signals.SCREEN_GO_TO, toScreen);
			Notifier.addListener(Signals.GAME_BEGIN, gameBegin);
			Notifier.addListener(Signals.GAME_TICK, gameTick);
		}
		
		
		
		// event handlers
		protected function onHatMotion(e:JoyHatEvent):void
		{
			try { currentScreen.onHatMotion(e); }
			catch (e:Error) { handleError(e); }
		}
		
		protected function onButtonMotion(e:JoyButtonEvent):void
		{
			try { currentScreen.onButtonMotion(e); }
			catch (e:Error) { handleError(e); }
		}
		
		
		
		// message callbacks
		protected function gameTick(dt:int):void
		{
			try { currentScreen.onUpdateRequest(dt); }
			catch (e:Error) { handleError(e); }
		}
		
		protected function nextScreen():void
		{
			C.out(this, "nextScreen()");
			var nextType:ScreenTypeEnumerator = screenFactory.getNextScreenType(currentScreen.type) as ScreenTypeEnumerator;
			setCurrentScreen(screenFactory.getScreen(nextType));
		}
		
		protected function toScreen(nextType:ScreenTypeEnumerator):void
		{
			C.out(this, "toScreen() - nextType: " +nextType);
			setCurrentScreen(screenFactory.getScreen(nextType));
		}
		
		protected function attractLoopBegin():void
		{
			C.out(this, "attractLoopBegin()");
			setCurrentScreen(screenFactory.getScreen(screenFactory.loopStartScreenType));
		}
		
		protected function gameBegin():void
		{
			C.out(this, "gameBegin()");
			setCurrentScreen(screenFactory.getScreen(screenFactory.gameStartScreenType));
		}
		
		
		
		// utility
		protected function handleError(e:Error):void
		{
			C.out(this, e.getStackTrace());
			removeListeners();
		}
		
		protected function setCurrentScreen(screen:ScreenBase):void
		{
			var prevScreen:ScreenTypeEnumerator = currentScreen.type;
			
			var isShutDown:Boolean = currentScreen.shutDown();
			if (!isShutDown) throw new Error("ERROR: " +prevScreen +" unable to shut down");
			screenContainer.removeChild(currentScreen as DisplayObject);
			
			currentScreen = screenContainer.addChild(screen as DisplayObject) as ScreenBase;
			C.out(this, "setCurrentScreen() - moving from " +prevScreen +" to " +currentScreen.type);
			
			var isInitialized:Boolean = currentScreen.initialize();
			if (!isInitialized) throw new Error("ERROR: " +currentScreen.type +" unable to initialize");
		}
	}
}