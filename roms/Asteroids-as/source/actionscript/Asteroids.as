
/*

Asteroids

*/

package
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.utils.getQualifiedClassName;
	
	import com.pixeldroid.r_c4d3.controls.JoyEventStateEnum;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameRom;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	
	import control.GameScreenController;
	import control.StatsScreenController;
	import control.ScoreController;
	import control.Signals;
	import util.IDisposable;
	import util.Notifier;
	import view.screen.IGameScreenFactory;
	import view.screen.ScreenFactory;
	
	
	public class Asteroids extends Sprite implements IGameRom, IDisposable
	{
		
		private var controls:IGameControlsProxy;
		private var scores:IGameScoresProxy;
		private var screens:IGameScreenFactory;
		
		private var screenManager:IDisposable;
		private var statsManager:IDisposable;
		private var scoreManager:IDisposable;
		
		private var debugLayer:Sprite;
		private var gameLayer:Sprite;
		
		private var lastTime:int
		
		
		
		public function Asteroids()
		{
			super();
			
			C.out(this, "Asteroids");
			initialize();
		}
		
		
		
		// IGameRom interface
		public function setControlsProxy(value:IGameControlsProxy):void
		{
			C.out(this, "setControlsProxy to " +getQualifiedClassName(value));
			if (!value) throw new Error("Error - expected IGameControlsProxy, got " +value);
			
			// store local ref to IGameControlsProxy
			controls = value;
			
			// activate players and enable event reporting (instead of actively polling)
			for (var i:int = 0; i < 4; i++) controls.joystickOpen(i); // activate joystick for players 1 - 4
			controls.joystickEventState(JoyEventStateEnum.ENABLE, stage); // enable event reporting
			
			// instantiate and initialize mangers
			screenManager = createGameScreenController(controls, gameLayer, screens);
			screenManager.initialize();
			
			statsManager = createStatsScreenController(controls, debugLayer, screens);
			statsManager.initialize();
		}
		
		public function setScoresProxy(value:IGameScoresProxy):void
		{
			C.out(this, "setScoresProxy to " +getQualifiedClassName(value));
			if (!value) throw new Error("Error - expected IGameScoresProxy, got " +value);
			
			// store local ref to IGameScoresProxy (manager will be created in initialize)
			scores = value;
			
			// activate score table for this game
			scores.openScoresTable("r-c4d3.asteroids");
			
			// instantiate and initialize manager
			scoreManager = new ScoreController(scores) as IDisposable;
			scoreManager.initialize();
		}
		
		public function enterAttractLoop():void
		{
			C.out(this, "enterAttractLoop");
			stage.frameRate = 10;
			
			// initialize frame event reporting and timing
			lastTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			// pass flow to game screen controller
			Notifier.send(Signals.ATTRACT_LOOP_BEGIN);
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			scoreManager.shutDown();
			screenManager.shutDown();
			statsManager.shutDown();
			
			scoreManager = null;
			screenManager = null;
			statsManager = null;
			
			removeChild(debugLayer);
			removeChild(gameLayer);
			
			removeEventListener(Event.ENTER_FRAME, onFrame);
			
			controls = null;
			
			scores.closeScoresTable();
			scores = null;
			
			screens = null;
			
			return true;
		}
		
		public function initialize():Boolean
		{
			// create factory for retrieving game screens
			screens = createGameScreenFactory();
			
			// instantiate and initialize top level containers for screens and debug stats
			gameLayer = addChild(new Sprite()) as Sprite;
			debugLayer = addChild(new Sprite()) as Sprite;
			
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
		
		
		// factory methods
		protected function createGameScreenFactory():IGameScreenFactory
		{
			return new ScreenFactory();
		}
		
		protected function createGameScreenController(controlsProxy:IGameControlsProxy, gameLayer:Sprite, screenFactory:IGameScreenFactory):IDisposable
		{
			return new GameScreenController(controlsProxy, gameLayer, screenFactory) as IDisposable
		}
		
		protected function createStatsScreenController(controlsProxy:IGameControlsProxy, gameLayer:Sprite, screenFactory:IGameScreenFactory):IDisposable
		{
			return new StatsScreenController(controlsProxy, gameLayer, screenFactory) as IDisposable
		}
		
		protected function createScoreController(scoresProxy:IGameScoresProxy):IDisposable
		{
			return new ScoreController(scoresProxy) as IDisposable
		}
		
	}

}
