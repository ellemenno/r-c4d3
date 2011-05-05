
package com.pixeldroid.r_c4d3.game.screen
{
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.game.screen.ScreenTypeEnumerator;
	

	/**
	Defines an interface for game screen creation and sequencing.
	
	<p>
	Implementors of this interface can be provided to the GameScreenController.
	</p>
	
	@see com.pixeldroid.r_c4d3.game.view.screen.ScreenType
	@see com.pixeldroid.r_c4d3.game.view.screen.ScreenBase
	@see com.pixeldroid.r_c4d3.game.control.GameScreenController
	*/
	public interface IGameScreenFactory
	{
		
		/**
		Retrieve the type of screen that begins the attract loop sequence 
		(default is ScreenType.TITLE).
		*/
		function get loopStartScreenType():ScreenTypeEnumerator;
		
		/**
		Retrieve the type of screen to jump to when exiting the attract loop 
		sequence and starting game play (default is ScreenType.SETUP).
		*/
		function get gameStartScreenType():ScreenTypeEnumerator;
		
		/**
		Retrieve the type of screen to jump to when leaving the provided type.
		
		@param currentType The type enumerator for the screen preceeding the desired screen
		*/
		function getNextScreenType(currentType:ScreenTypeEnumerator):ScreenTypeEnumerator;
		
		/**
		Retrieve the screen implementation associated with the provided type. 
		
		@param type The type enumerator associated with the screen instance
		*/
		function getScreen(type:ScreenTypeEnumerator):ScreenBase;
	}
}
