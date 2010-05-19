

package com.pixeldroid.r_c4d3.game.view.screen
{
	
	import com.pixeldroid.r_c4d3.data.ResourcePool;
	import com.pixeldroid.r_c4d3.game.view.screen.DebugScreen;
	import com.pixeldroid.r_c4d3.game.view.screen.NullScreen;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
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
			
		/** @inheritDoc */ public function get GAME():String { return "GAME" }
		/** @inheritDoc */ public function get HELP():String { return "HELP" }
		/** @inheritDoc */ public function get NULL():String { return "NULL" }
		/** @inheritDoc */ public function get SCORES():String { return "SCORES" }
		/** @inheritDoc */ public function get SETUP():String { return "SETUP" }
		/** @inheritDoc */ public function get TITLE():String { return "TITLE" }
		/** @inheritDoc */ public function get DEBUG():String { return "DEBUG" }
		
		/** @inheritDoc */
		public function get loopStartScreenType():String { return NULL; }
		
		/** @inheritDoc */
		public function get gameStartScreenType():String { return SETUP; }

		/** @inheritDoc */
		public function getNextScreenType(currentType:String):String
		{
			var nextType:String;
			switch (currentType)
			{
				case NULL  : nextType = TITLE;  break;
				case TITLE : nextType = HELP;   break;
				case HELP  : nextType = SETUP;  break;
				case SETUP : nextType = GAME;   break;
				case GAME  : nextType = SCORES; break;
				case SCORES: nextType = TITLE;  break;
				
				default:
				throw new Error("unrecognized screen type '" +currentType +"'");
				break;
			}
			return nextType;
		}
		
		/** @inheritDoc */
		public function getScreen(type:String):ScreenBase
		{
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
		protected function retrieveScreen(type:String):ScreenBase
		{
			var screen:ScreenBase;
			switch (type)
			{
				case GAME   : 
				case HELP   : 
				case NULL   : 
				case SCORES : 
				case SETUP  : 
				case TITLE  : screen = screens.retrieve(NullScreen, type) as ScreenBase; break;
				
				case DEBUG  : screen = screens.retrieve(DebugScreen, type) as ScreenBase; break;
				
				default: throw new Error("unsupported screen type: " +type); break;
			}
			return screen;
		}
		
	}
}