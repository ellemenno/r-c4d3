

package com.pixeldroid.r_c4d3.game.screen
{
	import com.pixeldroid.r_c4d3.game.screen.ScreenTypeEnumerator;
	
	/**
	Enumeration of typical game screen types.
	
	<p>
	This class may be extended to indtroduce new screen types,
	but types declared in this class may not be overridden.
	</p>
	
	@see com.pixeldroid.r_c4d3.game.view.screen.ScreenTypeEnumerator
	@see com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory
	*/
	public class ScreenType
	{
		static public const NULL:ScreenTypeEnumerator = new ScreenTypeEnumerator("NULL");
		static public const DEBUG:ScreenTypeEnumerator = new ScreenTypeEnumerator("DEBUG");
		
		static public const GAME:ScreenTypeEnumerator = new ScreenTypeEnumerator("GAME");
		static public const HELP:ScreenTypeEnumerator = new ScreenTypeEnumerator("HELP");
		static public const SCORES:ScreenTypeEnumerator = new ScreenTypeEnumerator("SCORES");
		static public const SETUP:ScreenTypeEnumerator = new ScreenTypeEnumerator("SETUP");
		static public const TITLE:ScreenTypeEnumerator = new ScreenTypeEnumerator("TITLE");
	}
}

