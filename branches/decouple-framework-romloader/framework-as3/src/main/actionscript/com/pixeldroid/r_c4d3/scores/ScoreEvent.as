﻿
package com.pixeldroid.r_c4d3.scores {

	import flash.events.Event;

	/**
	<code>ScoreEvent</code> objects are dispatched in response to load and store requests on a HighScores subclass.
	
	@see com.pixeldroid.r_c4d3.scores.LocalHighScores
	@see com.pixeldroid.r_c4d3.scores.RemoteHighScores
	*/
	public class ScoreEvent extends Event {

	
		/**
		Value of the <code>type</code> property of the event object for a <code>save</code> event.
		
		@eventType save
		*/
		public static const SAVE:String = "SAVE";

		/**
		Value of the <code>type</code> property of the event object for a <code>load</code> event.
		
		@eventType load
		*/
		public static const LOAD:String = "LOAD";
		
		/**
		<code>true</code> for operations that complete without error.
		*/
		public var success:Boolean;
		
		/**
		Additional information from the event broadcaster.
		*/
		public var message:String;


		/**
		Creates a new ScoreEvent instance for a specific score event type.
		
		@param type The score event flavor, e.g. <code>ScoreEvent.SAVE</code>
		*/
		public function ScoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		/** @inheritDoc */
		public override function clone():Event {
			// override clone so the event can be redispatched
			var e:ScoreEvent = new ScoreEvent(type, bubbles, cancelable);
			e.success = success;
			e.message = message;
			return e;
		}
		
		/** @inheritDoc */
		public override function toString():String {
			var s:String = "[ScoreEvent]";
			s += "\nSuccess ?: " +success;
			s += "\nMessage: " +message;
			return s;
		}
		
	}
}