
package
{
	import util.Notifier;
	
	public class X
	{
		
		public function X()
		{
			Notifier.addListener("frame.every", onSignal);
		}
		
		private function onSignal(message:Object):void
		{
			trace(this, "onSignal (frame.every) - " +message.frame);
			if (message.frame > 9) Notifier.removeListener("frame.every", onSignal);
		}
		
	}
}
