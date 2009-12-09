

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
	
	
	
	public class StatsScreenController implements IDisposable
	{
		
		private var controlsProxy:IGameControlsProxy;
		private var screenContainer:DisplayObjectContainer;
		private var stats:ScreenBase;
		
		
		// Constructor
		public function StatsScreenController(controls:IGameControlsProxy, container:DisplayObjectContainer)
		{
			C.out(this, "constructor");
			controlsProxy = controls;
			screenContainer = container;
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			if (!stats.shutDown()) throw new Error("ERROR: " +stats.name +" unable to shut down");
			
			// remove listeners from controls proxy and prep for garbage collection
			controlsProxy.removeEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.removeEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			controlsProxy = null;
			
			screenContainer = null;
			
			// remove listeners from messaging service
			Message.remove(Signals.GAME_TICK);
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			var screenFactory:ScreenFactory = new ScreenFactory();
			
			stats = screenContainer.addChild(screenFactory.debugScreen as DisplayObject) as ScreenBase;
			stats.initialize();
			
			// attach listeners to controls proxy
			controlsProxy.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion);
			controlsProxy.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion);
			
			// attach listeners to messaging service
			Message.add(gameTick, Signals.GAME_TICK);
			
			return true;
		}
		
		
		
		// event handlers
		private function onHatMotion(e:JoyHatEvent):void
		{
			stats.onHatMotion(e);
		}
		
		private function onButtonMotion(e:JoyButtonEvent):void
		{
			stats.onButtonMotion(e);
		}
		
		
		
		// message callbacks
		private function gameTick(e:Object):void
		{
			stats.onFrameUpdate(e as int);
		}
		
	}
}