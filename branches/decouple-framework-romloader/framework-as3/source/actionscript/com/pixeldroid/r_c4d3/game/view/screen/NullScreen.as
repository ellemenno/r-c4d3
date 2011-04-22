

package com.pixeldroid.r_c4d3.game.view.screen
{
	
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	
	
	/**
	A minimal ScreenBase implementation to avoid null reference checking.
	
	<p>
	The null screen is typically the value for <code>loopStartScreenType</code>
	in IGameScreenFactory implementations, so that no resources consumed by the 
	attract loop before it is added to the display list.
	</p>
	
	@see com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory
	*/
	public class NullScreen extends ScreenBase
	{
		
		
		public function NullScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
	}
}
