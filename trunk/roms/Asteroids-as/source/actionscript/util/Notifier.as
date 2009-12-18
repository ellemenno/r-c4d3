
package util
{
	import flash.utils.Dictionary;

	public class Notifier
	{
		
		static private var registry:Dictionary;
		static private var counters:Dictionary;
		
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
		
		static public function hasListener(signal:String):Boolean
		{
			return (counters && (counters[signal] as int) > 0);
		}
		
		static public function removeListener(signal:String, callback:Function):void
		{
			if (registry && registry[signal])
			{
				(registry[signal] as Dictionary)[callback] = null;
				counters[signal] = (counters[signal] as int) - 1;
			}
		}
		
		static public function send(signal:String, message:Object=null):int
		{
			if (!registry) return 0;
			if (!registry[signal]) return 0;
			
			var i:int = 0;
			var listeners:Dictionary = registry[signal] as Dictionary;
			for each (var callback:* in listeners) {
				(callback as Function)(message);
				i++;
			}
			return i;
		}
		
	}
}