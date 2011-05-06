
package com.pixeldroid.r_c4d3.game
{

	import com.pixeldroid.r_c4d3.api.IDisposable;
	import com.pixeldroid.r_c4d3.api.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.api.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.api.IGameRom;
	import com.pixeldroid.r_c4d3.api.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.api.JoyEventStateEnumerator;
	import com.pixeldroid.r_c4d3.game.control.GameScreenController;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.ScoreController;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.control.StatsScreenController;
	import com.pixeldroid.r_c4d3.game.screen.IGameScreenFactory;
	import com.pixeldroid.r_c4d3.game.screen.ScreenFactory;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	
	/**
	A basic IGameRom implementation to cover the boring stuff.
	
	<p>
	Subclasses should override <code>createGameScreenFactory</code> to provide a proper set of game screens.
	</p>
	
	<p>
	The game, stats, and score controllers may be overridden as well, to provide custom implementation or disable. 
	The game and stats controllers listen for the GAME_TICK signal to request screen updates from their screens. 
	The score controller listens for SCORES_SUBMIT and SCORES_RETRIEVE to transfer score data to and from the storage medium.
	</p>
	
	@see #createGameScreenFactory 
	@see #createGameScreenController
	@see #createStatsScreenController
	@see #createScoreController
	@see com.pixeldroid.r_c4d3.game.control.Signals
	*/
	public class GameBase extends Sprite implements IGameRom, IDisposable
	{
		
		protected var config:IGameConfigProxy;
		protected var controls:IGameControlsProxy;
		protected var scores:IGameScoresProxy;
		protected var screens:IGameScreenFactory;
		
		protected var screenManager:IDisposable;
		protected var statsManager:IDisposable;
		protected var scoreManager:IDisposable;
		
		protected var debugLayer:Sprite;
		protected var gameLayer:Sprite;
		
		protected var lastTime:int
		
		
		
		/**
		Constructor
		*/
		public function GameBase()
		{
			super();
			
			C.out(this, "GameBase constructor");
			initialize();
		}
		
		
		
		// IGameRom interface
		/** @inheritDoc */
		public function setConfigProxy(value:IGameConfigProxy):void
		{
			C.out(this, "setConfigProxy to " +getQualifiedClassName(value));
			if (!value) throw new Error("Error - expected IGameConfigProxy, got " +value);
			
			// store local ref to IGameConfigProxy
			config = value;
		}
		
		/** @inheritDoc */
		public function setControlsProxy(value:IGameControlsProxy):void
		{
			C.out(this, "setControlsProxy to " +getQualifiedClassName(value));
			if (!value) throw new Error("Error - expected IGameControlsProxy, got " +value);
			
			// store local ref to IGameControlsProxy
			controls = value;
			
			// activate players and enable event reporting (instead of actively polling)
			for (var i:int = 0; i < 4; i++) controls.joystickOpen(i); // activate joystick for players 1 - 4
			controls.joystickEventState(JoyEventStateEnumerator.ENABLE, stage); // enable event reporting
			
			// instantiate and initialize managers
			screenManager = createGameScreenController(controls, gameLayer, screens);
			if (!screenManager) throw new Error("createGameScreenController not implemented or returned null");
			screenManager.initialize();
			
			// only create stats controller when in debug player and config says statsEnabled=true
			if (Capabilities.isDebugger && config.statsEnabled == true)
			{
				statsManager = createStatsScreenController(controls, debugLayer, screens);
				if (statsManager) statsManager.initialize();
				else C.out(this, "setControlsProxy - no statsManager to initialize");
			}
		}
		
		/** @inheritDoc */
		public function setScoresProxy(value:IGameScoresProxy):void
		{
			C.out(this, "setScoresProxy to " +getQualifiedClassName(value));
			if (!value) throw new Error("Error - expected IGameScoresProxy, got " +value);
			
			// store local ref to IGameScoresProxy
			scores = value;
			
			// activate score table for this game
			scores.openScoresTable(config.gameId);
			
			// instantiate and initialize manager
			scoreManager = new ScoreController(scores) as IDisposable;
			if (scoreManager) scoreManager.initialize();
			else C.out(this, "setScoresProxy - no scoreManager to initialize");
		}
		
		/** @inheritDoc */
		public function enterAttractLoop():void
		{
			C.out(this, "enterAttractLoop");
			
			// initialize frame event reporting and timing
			lastTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			// pass flow to game screen controller
			Notifier.send(Signals.ATTRACT_LOOP_BEGIN);
		}
		
		
		
		// IDisposable interface
		/** @inheritDoc */
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			if (scoreManager) scoreManager.shutDown();
			if (statsManager) statsManager.shutDown();
			screenManager.shutDown();
			
			scoreManager = null;
			screenManager = null;
			statsManager = null;
			
			removeChild(debugLayer);
			removeChild(gameLayer);
			
			removeEventListener(Event.ENTER_FRAME, onFrame);
			Notifier.removeListener(Signals.GET_CONFIG, getConfig);
			
			controls = null;
			
			scores.closeScoresTable();
			scores = null;
			
			screens = null;
			
			return true;
		}
		
		/** @inheritDoc */
		public function initialize():Boolean
		{
			// create factory for retrieving game screens
			screens = createGameScreenFactory();
			
			// instantiate and initialize top level containers for screens and debug stats
			gameLayer = addChild(new Sprite()) as Sprite;
			debugLayer = addChild(new Sprite()) as Sprite;
			
			// listen for requests to receive config proxy
			Notifier.addListener(Signals.GET_CONFIG, getConfig);
			
			// rest of initialization happens when scores and controls proxies are set
			
			return true;
		}
		
		
		// event handlers
		protected function onFrame(e:Event):void
		{
			var now:int = getTimer();
			var dt:int = now - lastTime;
			
			Notifier.send(Signals.GAME_TICK, dt);
			lastTime = now;
		}
		
		protected function getConfig(callback:Function):void
		{
			// provide config proxy reference to callback
			callback(config);
		}
		
		
		// factory methods - override in subclasses
		
		/**
		Override to introduce your own set of game screens
		
		@see ScreenFactory
		*/
		protected function createGameScreenFactory():IGameScreenFactory
		{
			return new ScreenFactory();
		}
		
		/**
		Override to insert your own game screen controller
		
		@see GameScreenController
		*/
		protected function createGameScreenController(controlsProxy:IGameControlsProxy, container:Sprite, screenFactory:IGameScreenFactory):IDisposable
		{
			return new GameScreenController(controlsProxy, container, screenFactory) as IDisposable
		}
		
		/**
		Override to insert your own stats screen controller, or return null
		
		@see StatsScreenController
		*/
		protected function createStatsScreenController(controlsProxy:IGameControlsProxy, container:Sprite, screenFactory:IGameScreenFactory):IDisposable
		{
			return new StatsScreenController(controlsProxy, container, screenFactory) as IDisposable
		}
		
		/**
		Override to insert your own score controller, or return null
		
		@see ScoreController
		*/
		protected function createScoreController(scoresProxy:IGameScoresProxy):IDisposable
		{
			return new ScoreController(scoresProxy) as IDisposable
		}

	}

}