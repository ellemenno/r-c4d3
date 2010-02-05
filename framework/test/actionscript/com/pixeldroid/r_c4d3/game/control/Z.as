
package com.pixeldroid.r_c4d3.game.control
{
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	
	public class Z
	{
		
		public function Z()
		{
			Notifier.addListener("frame.odd", onSignal);
		}
		
		private function onSignal(message:Object):void
		{
			trace(this, "onSignal (frame.odd) - " +message.frame);
			if (message.frame > 9) Notifier.removeListener("frame.odd", onSignal);
		}
		
	}
}
