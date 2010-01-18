
package com.pixeldroid.r_c4d3.interfaces
{
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	

	/**
	Defines an interface for game screen creation and sequencing.
	
	<p>
	Implementors of this interface can be provided to the GameScreenController.
	</p>
	
	@see com.pixeldroid.r_c4d3.game.control.GameScreenController
	@see com.pixeldroid.r_c4d3.game.view.screen.ScreenBase
	*/
	public interface IGameScreenFactory
	{
		/** Screen type representing the gameplay screen */ function get GAME():String;
		/** Screen type representing the instructions screen */ function get HELP():String;
		/** Screen type representing the null screen */ function get NULL():String;
		/** Screen type representing the high scores screen */ function get SCORES():String;
		/** Screen type representing the player setup screen */ function get SETUP():String;
		/** Screen type representing the title screen */ function get TITLE():String;
		/** Screen type representing the performance stats screen */ function get DEBUG():String;

		
		/**
		Retrieve the type of screen that begins the attract loop sequence 
		(usually NULL).
		*/
		function get loopStartScreenType():String;
		
		/**
		Retrieve the type of screen to jump to when exiting the attract loop 
		sequence and starting game play (usually SETUP or GAME).
		*/
		function get gameStartScreenType():String;
		
		/**
		Retrieve the type of screen that follows the provided type in the 
		attract loop sequence.
		
		@param currentType A valid IGameScreenFactory type
		*/
		function getNextScreenType(currentType:String):String;
		
		/**
		Retrieve the screen implementation associated with the provided type. 
		
		@param type A valid IGameScreenFactory type
		*/
		function getScreen(type:String):ScreenBase;
	}
}
