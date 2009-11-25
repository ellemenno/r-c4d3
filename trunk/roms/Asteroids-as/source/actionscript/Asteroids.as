
/*

Asteroids

*/

package
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import com.pixeldroid.r_c4d3.controls.JoyEventStateEnum;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameRom;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;

	import control.ScreenController;
	import control.Signals;
	import util.f.Message;
	

	public class Asteroids extends Sprite implements IGameRom
	{

		private var controls:IGameControlsProxy;
		private var scores:IGameScoresProxy;
		private var screens:ScreenController;
		
		private var debugLayer:Sprite;
		private var gameLayer:Sprite;
		private var lastTime:int



		public function Asteroids()
		{
			C.out(this, "Asteroids", true);
			
			gameLayer = addChild(new Sprite()) as Sprite;
			debugLayer = addChild(new Sprite()) as Sprite;
			
			lastTime = getTimer();
			screens = new ScreenController(gameLayer);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}


		// IGameRom API
		public function setControlsProxy(value:IGameControlsProxy):void
		{
			C.out(this, "setControlsProxy to " +value);
			
			// store locally, enable reporting, and activate all four players
			controls = value;
			controls.joystickEventState(JoyEventStateEnum.ENABLE, stage); // enable event reporting
			
			controls.joystickOpen(0); // activate joystick for player 1
			controls.joystickOpen(1); // activate joystick for player 2
			controls.joystickOpen(2); // activate joystick for player 3
			controls.joystickOpen(3); // activate joystick for player 4
			
			// pass controls proxy on to screen manager
			screens.controls = controls;
		}

		public function setScoresProxy(value:IGameScoresProxy):void
		{
			C.out(this, "setScoresProxy - TODO");
		}

		public function enterAttractLoop():void
		{
			C.out(this, "enterAttractLoop");
			Message.send(null, Signals.ATTRACT_LOOP_BEGIN);
		}
		
		
		// screen refreshes
		private function onFrame(e:Event):void
		{
			var now:int = getTimer();
			screens.onFrameUpdate(now - lastTime);
			lastTime = now;
		}
		
	}

}
