
/*

Asteroids

*/

package
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	

	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyEventStateEnum;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameRom;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;

	import control.IController;
	import control.ScreenController;
	import control.Signals;
	import util.IDisposable;
	import util.f.Message;
	import view.screen.DebugScreen;
	import view.screen.ScreenBase;
	

	public class Asteroids extends Sprite implements IGameRom, IDisposable
	{

		private var controls:IGameControlsProxy;
		private var scores:IGameScoresProxy;
		private var screens:IController;
		private var stats:ScreenBase;
		
		private var debugLayer:Sprite;
		private var gameLayer:Sprite;
		private var lastTime:int



		public function Asteroids()
		{
			C.out(this, "Asteroids", true);
			initialize();
		}
		
		
		
		// IGameRom interface
		public function setControlsProxy(value:IGameControlsProxy):void
		{
			C.out(this, "setControlsProxy to " +value);
			
			// store local ref to IGameControlsProxy and enable reporting (instead of actively polling)
			controls = value;
			controls.joystickEventState(JoyEventStateEnum.ENABLE, stage); // enable event reporting
			
			// activate all four players
			controls.joystickOpen(0); // activate joystick for player 1
			controls.joystickOpen(1); // activate joystick for player 2
			controls.joystickOpen(2); // activate joystick for player 3
			controls.joystickOpen(3); // activate joystick for player 4
			
			// attach listeners to proxy
			controls.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controls.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
		}

		public function setScoresProxy(value:IGameScoresProxy):void
		{
			C.out(this, "setScoresProxy - TODO");
			
			// store local ref to IGameScoresProxy
			scores = value;
		}

		public function enterAttractLoop():void
		{
			C.out(this, "enterAttractLoop");
			// pass flow to controller
			Message.send(null, Signals.ATTRACT_LOOP_BEGIN);
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			IDisposable(screens).shutDown();
			stats.shutDown();
			
			debugLayer.removeChild(stats);
			removeChild(debugLayer);
			removeChild(gameLayer);
			
			removeEventListener(Event.ENTER_FRAME, onFrame);
			controls.removeEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controls.removeEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			controls = null;
			
			scores = null;
			
			return true;
		}
		
		public function initialize():Boolean
		{
			// initialize top level containers for screens and debug stats
			gameLayer = addChild(new Sprite()) as Sprite;
			debugLayer = addChild(new Sprite()) as Sprite;
			
			screens = new ScreenController(gameLayer) as IController; // TODO: ControllerBase to implement IController and IDisposable?
			IDisposable(screens).initialize();
			
			stats = debugLayer.addChild(new DebugScreen() as DisplayObject) as ScreenBase;
			stats.initialize();
			
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
			
			screens.onFrameUpdate(dt);
			stats.onFrameUpdate(dt);
			
			lastTime = now;
		}
		
		private function onHatMotion(e:JoyHatEvent):void
		{
			screens.onHatMotion(e);
			stats.onHatMotion(e);
		}
		
		private function onButtonMotion(e:JoyButtonEvent):void
		{
			screens.onButtonMotion(e);
			stats.onButtonMotion(e);
		}
		
	}

}
