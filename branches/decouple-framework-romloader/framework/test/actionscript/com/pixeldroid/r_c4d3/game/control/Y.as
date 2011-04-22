
package com.pixeldroid.r_c4d3.game.control
{
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	
	public class Y
	{
		
		public function Y()
		{
			Notifier.addListener("frame.even", onSignal);
		}
		
		private function onSignal(message:Object):void
		{
			trace(this, "onSignal (frame.even) - " +message.frame);
			if (message.frame > 9) Notifier.removeListener("frame.even", onSignal);
		}
		
	}
}
