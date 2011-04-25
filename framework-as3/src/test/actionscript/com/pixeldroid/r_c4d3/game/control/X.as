
package com.pixeldroid.r_c4d3.game.control
{
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	
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
