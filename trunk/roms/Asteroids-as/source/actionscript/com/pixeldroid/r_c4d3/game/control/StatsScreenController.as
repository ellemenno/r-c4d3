

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
	Handles collection and processing of game status information.
	Uses the debug screen of the IGameScreenFactory for display
	
	<p>
	Listens for the following signals: 
	GAME_TICK (ask the current screen to update)
	</p>
	
	@see IGameScreenFactory
	@see Signals
	*/
	public class StatsScreenController implements IDisposable
	{
		
		protected var controlsProxy:IGameControlsProxy;
		protected var screenContainer:DisplayObjectContainer;
		protected var screenFactory:IGameScreenFactory;
		protected var stats:ScreenBase;
		
		
		/**
		Constructor
		*/
		public function StatsScreenController(controls:IGameControlsProxy, container:DisplayObjectContainer, factory:IGameScreenFactory)
		{
			C.out(this, "constructor");
			controlsProxy = controls;
			screenContainer = container;
			screenFactory = factory;
		}
		
		
		
		// IDisposable interface
		
		/** @inheritDoc*/
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			
			// shut down stats and remove it from its container
			if (!stats.shutDown()) throw new Error("ERROR: " +stats.name +" unable to shut down");
			screenContainer.removeChild(stats as DisplayObject);
			screenContainer = null;
			
			// remove listeners from controls proxy and prep for garbage collection
			controlsProxy.removeEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.removeEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			controlsProxy = null;
			
			// remove listeners from messaging service
			Notifier.removeListener(Signals.GAME_TICK, gameTick);
			
			return true;
		}
		
		/** @inheritDoc*/
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			stats = screenContainer.addChild(screenFactory.getScreen(screenFactory.DEBUG) as DisplayObject) as ScreenBase;
			stats.initialize();
			
			// attach listeners to controls proxy
			controlsProxy.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			
			// attach listeners to messaging service
			Notifier.addListener(Signals.GAME_TICK, gameTick);
			
			return true;
		}
		
		
		
		// event handlers
		protected function onHatMotion(e:JoyHatEvent):void
		{
			stats.onHatMotion(e);
		}
		
		protected function onButtonMotion(e:JoyButtonEvent):void
		{
			stats.onButtonMotion(e);
		}
		
		
		
		// message callbacks
		protected function gameTick(dt:int):void
		{
			stats.onUpdateRequest(dt);
		}
		
	}
}