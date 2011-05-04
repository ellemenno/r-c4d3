

package com.pixeldroid.r_c4d3.game.view.screen
{
	
	import com.pixeldroid.r_c4d3.data.ResourcePool;
	import com.pixeldroid.r_c4d3.game.view.screen.DebugScreen;
	import com.pixeldroid.r_c4d3.game.view.screen.NullScreen;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenType;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenTypeEnumerator;
	import com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory;
	
	
	/**
	Creates screens for the attract loop and manages their advancement order.
	
	<p>
	This base implementation is designed to be extended and overidden to 
	return screens appropriate to a particular game. It only returns instances 
	of NullScreen and DebugScreen.
	</p>
	
	@see com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory
	@see com.pixeldroid.r_c4d3.game.control.Signals
	*/
	public class ScreenFactory implements IGameScreenFactory
	{
		/** Screen cache */
		protected var screens:ResourcePool = new ResourcePool();
		
		/** @inheritDoc */
		public function get loopStartScreenType():ScreenTypeEnumerator { return ScreenType.TITLE; }
		
		/** @inheritDoc */
		public function get gameStartScreenType():ScreenTypeEnumerator { return ScreenType.SETUP; }

		/** @inheritDoc */
		public function getNextScreenType(currentType:ScreenTypeEnumerator):ScreenTypeEnumerator
		{
			var nextType:ScreenTypeEnumerator;
			switch (currentType)
			{
				case ScreenType.NULL  : nextType = loopStartScreenType; break;
				
				case ScreenType.TITLE : nextType = ScreenType.HELP;   break;
				case ScreenType.HELP  : nextType = ScreenType.SETUP;  break;
				case ScreenType.SETUP : nextType = ScreenType.GAME;   break;
				case ScreenType.GAME  : nextType = ScreenType.SCORES; break;
				case ScreenType.SCORES: nextType = ScreenType.TITLE;  break;
				
				default:
				throw new Error("unrecognized screen type '" +currentType +"'");
				break;
			}
			return nextType;
		}
		
		/** @inheritDoc */
		public function getScreen(type:ScreenTypeEnumerator):ScreenBase
		{
			// new screens won't have type set; doing it here so overriders of
			// retrieveScreen don't have to remember to
			var screen:ScreenBase = retrieveScreen(type);
			screen.type = type;
			
			return screen;
		}
		
		
		/**
		Retrieve the screen associated with the provided type.
		
		<p>
		This base implementation is designed to be extended and overidden to 
		return screens appropriate to a particular game. It only returns instances 
		of NullScreen and DebugScreen.
		</p>
		*/
		protected function retrieveScreen(type:ScreenTypeEnumerator):ScreenBase
		{
			var screen:ScreenBase;
			switch (type)
			{
				case ScreenType.GAME   : 
				case ScreenType.HELP   : 
				case ScreenType.NULL   : 
				case ScreenType.SCORES : 
				case ScreenType.SETUP  : 
				case ScreenType.TITLE  : screen = screens.retrieve(NullScreen, type) as ScreenBase; break;
				
				case ScreenType.DEBUG  : screen = screens.retrieve(DebugScreen, type) as ScreenBase; break;
				
				default: throw new Error("unsupported screen type: " +type); break;
			}
			return screen;
		}
		
	}
}