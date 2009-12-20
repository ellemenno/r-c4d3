
package util
{
	import flash.utils.Dictionary;

	/**
	Global registry of callback functions associated with string trigger signals.
	
	<p>
	A simple way to send messages around an application without direct coupling.
	</p>
	*/
	public class Notifier
	{
		
		static private var registry:Dictionary;
		static private var counters:Dictionary;
		
		
		/**
		Adds a function to the list of functions to be called when signal is sent.
		
		@param signal Trigger that callback will be associated with
		@param callback Function to call when trigger signal is sent
		
		@see #send
		@see #removeListener
		*/
		static public function addListener(signal:String, callback:Function):void
		{
			if (!registry)
			{
				registry = new Dictionary(true);
				counters = new Dictionary(true);
			}
			if (!registry[signal])
			{
				registry[signal] = new Dictionary(true);
				counters[signal] = 0;
			}
			
			(registry[signal] as Dictionary)[callback] = callback;
			counters[signal] = (counters[signal] as int) + 1;
		}
		
		
		/**
		Reports if there are currently any listeners for the given signal.
		*/
		static public function hasListener(signal:String):Boolean
		{
			return (counters && (counters[signal] as int) > 0);
		}
		
		
		/**
		Reports how many listeners for the given signal there currently are.
		*/
		static public function howManyListeners(signal:String):int
		{
			return (counters != null) ? (counters[signal] as int) : 0;
		}
		
		
		/**
		Removes a previously added function from the list of functions to be called when signal is sent.
		
		<p>
		Does nothing if the function was not previously added.
		</p>
		
		@param signal Trigger that callback was associated with
		@param callback Function reference to remove
		
		@see #addListener
		*/
		static public function removeListener(signal:String, callback:Function):void
		{
			if (registry && registry[signal])
			{
				(registry[signal] as Dictionary)[callback] = null;
				counters[signal] = (counters[signal] as int) - 1;
			}
		}
		
		
		/**
		Calls all functions listening for signal.
		
		<p>
		Sends optional message, if present
		</p>
		
		@param signal Trigger that target callbacks are associated with
		@param message Optional argument to pass to callback functions
		
		@return The number of listeners called
		*/
		static public function send(signal:String, message:*=undefined):int
		{
			if (!registry) return 0;
			if (!registry[signal]) return 0;
			
			var i:int = 0;
			var listeners:Dictionary = registry[signal] as Dictionary;
			for each (var callback:* in listeners) {
				if (message === undefined) (callback as Function)();
				else (callback as Function)(message);
				i++;
			}
			return i;
		}
		
	}
}