
package
{
	import util.Notifier;
	
	public class W
	{
		
		public function W()
		{
			Notifier.addListener("frame.every", onSignal1);
			Notifier.addListener("frame.every", onSignal2);
			Notifier.addListener("frame.every", onSignal3);
		}
		
		private function onSignal1(message:Object):void
		{
			trace(this, "onSignal1 (frame.every) - " +message.frame);
			if (message.frame > 5) Notifier.removeListener("frame.every", onSignal1);
		}
		
		private function onSignal2(message:Object):void
		{
			trace(this, "onSignal2 (frame.every) - " +message.frame);
			if (message.frame > 7) Notifier.removeListener("frame.every", onSignal2);
		}
		
		private function onSignal3(message:Object):void
		{
			trace(this, "onSignal3 (frame.every) - " +message.frame);
			if (message.frame > 9) Notifier.removeListener("frame.every", onSignal3);
		}
		
	}
}
