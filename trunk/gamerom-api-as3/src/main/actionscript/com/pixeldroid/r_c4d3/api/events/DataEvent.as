
package com.pixeldroid.r_c4d3.api.events
{

	import flash.events.Event;

	/**
	<code>DataEvent</code> objects are dispatched in response to asynchronous data requests.
	*/
	public class DataEvent extends Event
	{
		
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
		Value of the <code>type</code> property of the event object for a <code>ready</code> event.
		
		@eventType ready
		*/
		public static const READY:String = "READY";
		
		/**
		Value of the <code>type</code> property of the event object for a <code>error</code> event.
		
		@eventType error
		*/
		public static const ERROR:String = "ERROR";

		/**
		Information payload from the event broadcaster.
		*/
		public var data:Object;

		/**
		Additional information from the event broadcaster.
		*/
		public var message:String;
		
		/**
		 <code>true</code> for operations that complete without error.
		 */
		public var success:Boolean;


		/**
		Constructor.
		
		<p>
		Creates a new DataEvent instance for a specific data event type.
		</p>
		
		@param type The data event flavor, e.g. <code>DataEvent.LOAD</code>
		*/
		public function DataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable); // bubbles and cancelable are optional
		}
		
		/** @inheritDoc */
		public override function clone():Event
		{
			// override clone so the event can be redispatched
			var e:DataEvent = new DataEvent(type, bubbles, cancelable);
			e.data = data;
			e.message = message;
			e.success = success;
			return e;
		}
		
		/** @inheritDoc */
		public override function toString():String {
			var s:String = "[DataEvent]";
			s += "\nSuccess ?: " +success;
			s += "\nMessage: " +message;
			s += "\nData: " +data;
			return s;
		}
		
	}
}
