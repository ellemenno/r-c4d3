
package com.pixeldroid.r_c4d3.game.control
{
	
	/**
	Message ids used for game-wide notification.
	
	@see com.pixeldroid.r_c4d3.game.control.Notifier
	*/
	public class Signals
	{
		static public const ATTRACT_LOOP_BEGIN:String = "screen.go.first";
		static public const SCREEN_GO_NEXT:String = "screen.go.next";
		static public const SCREEN_GO_TO:String = "screen.go.to";
		static public const GAME_BEGIN:String = "screen.go.game";
		static public const GAME_TICK:String = "game.tick";
		static public const GET_CONFIG:String = "get.config";
		static public const SCORES_RETRIEVE:String = "scores.retrieve";
		static public const SCORES_SUBMIT:String = "scores.submit";
		static public const SCORES_READY:String = "scores.ready";
	}
}
