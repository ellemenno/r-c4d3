
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import W;
	import X;
	import Y;
	import Z;
	import util.Notifier;
	
	[SWF(width="100", height="50", frameRate="1", backgroundColor="#000000")]
	public class SignalTest extends Sprite
	{
		private var f:int;
		private var listeners:Array;
		
		
		public function SignalTest()
		{
			super();
			
			f = 0;
			stage.frameRate = 1;
			
			createChildren();
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function createChildren():void
		{
			listeners = [ new W(), new X(), new Y(), new Z() ];
		}
		
		private function onFrame(e:Event):void
		{
			f++;
			trace(Notifier.send("nobody"), " notices sent for 'nobody'");
			trace(Notifier.send("frame.every", {frame:f}), " notices sent for 'frame.every'");
			if (f % 2 == 0) trace(Notifier.send("frame.even", {frame:f}), " notices sent for 'frame.even'");
			else trace(Notifier.send("frame.odd", {frame:f}), " notices sent for 'frame.odd'");
			trace("");
			
			trace("still has listener for 'frame.every' ?", Notifier.hasListener("frame.every"));
			trace("still has listener for 'frame.even' ?", Notifier.hasListener("frame.even"));
			trace("still has listener for 'frame.odd' ?", Notifier.hasListener("frame.odd"));
			trace("");
			
			if (!Notifier.hasListener("frame.every") && !Notifier.hasListener("frame.even") && !Notifier.hasListener("frame.odd")) removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
	}
}