
/*

Asteroids

*/

package
{

	import flash.display.DisplayObject;
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
	import util.f.Message;
	
	
	public class Asteroids extends Sprite implements IGameRom, IDisposable
	{
		
		private var controls:IGameControlsProxy;
		private var scores:IGameScoresProxy;
		private var screenManager:IDisposable;
		private var statsManager:IDisposable;
		private var scoreManager:IDisposable;
		
		private var debugLayer:Sprite;
		private var gameLayer:Sprite;
		private var lastTime:int
		
		
		
		public function Asteroids()
		{
			C.out(this, "Asteroids");
			initialize();
		}
		
		
		
		// IGameRom interface
		public function setControlsProxy(value:IGameControlsProxy):void
		{
			C.out(this, "setControlsProxy to " +getQualifiedClassName(value));
			if (!value) throw new Error("Error - expected IGameControlsProxy, got " +value);
			
			// store local ref to IGameControlsProxy and enable reporting (instead of actively polling)
			controls = value;
			controls.joystickEventState(JoyEventStateEnum.ENABLE, stage); // enable event reporting
			
			// activate players
			for (var i:int = 0; i < 4; i++) controls.joystickOpen(i); // activate joystick for players 1 - 4
			
			// instantiate and initialize controllers
			screenManager = new GameScreenController(controls, gameLayer) as IDisposable;
			screenManager.initialize();
			
			statsManager = new StatsScreenController(controls, debugLayer) as IDisposable;
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
			
			// instantiate and initialize controllers
			scoreManager = new ScoreController(scores) as IDisposable;
			scoreManager.initialize();
		}
		
		public function enterAttractLoop():void
		{
			C.out(this, "enterAttractLoop");
			// pass flow to game screen controller
			Message.send(null, Signals.ATTRACT_LOOP_BEGIN);
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
			scores = null;
			
			return true;
		}
		
		public function initialize():Boolean
		{
			// instantiate and initialize top level containers for screens and debug stats
			gameLayer = addChild(new Sprite()) as Sprite;
			debugLayer = addChild(new Sprite()) as Sprite;
			
			// initialize frame event reporting and timing
			lastTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			return true;
		}
		
		
		// event handlers
		private function onFrame(e:Event):void
		{
			var now:int = getTimer();
			var dt:int = now - lastTime;
			
			Message.send(dt, Signals.GAME_TICK);
			
			lastTime = now;
		}
		
	}

}
