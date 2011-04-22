
package
{
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	Mini logger.
	
	<p>
	trace replacement.
	</p>
	
	@example Usage:
<listing version="3.0">
C.enable(); // just once
C.out(this, "bar bat baz");
</listing>
	
	@example Usage (forced trace):
<listing version="3.0">
C.out(this, "foo happened!", true); // temporary override of enabled
</listing>
	*/
	final public class C
	{

		static private var _enabled:Boolean;
		static private var _logger:Object;
		static private var nameMap:Dictionary = new Dictionary();

		/**
			Sends message to current logger, with timestamp and calling class prefixed.

			@param origin Calling class, typically <code>this</code>, e.g. <code>C.out(this, "hello")</code>. 
			If calling from within a static method, pass the class directly, e.g. <code>C.out(MyStaticClass, "hello from a static method")</code>. 
			@param value Message to trace
			@param force When true, override enabledness, e.g. for critical error
			@param fullPath When true, prefix with entire classpath instead of just class name
		*/
		static public function out(origin:*, value:String, force:Boolean=false, fullPath:Boolean=false):void {
			if (_enabled || force) _logger.log(format(origin, value, force));
		}
		
		/**
			Generates readable stack trace (must be in debug player).
		*/
		static public function get stackTrace():String
		{
			var stackTrace:String = "stack trace unavailable";
			if (Capabilities.isDebugger)
			{
				try { throw new Error(""); }
				catch (e:Error)
				{ 
					var debuggerData:RegExp = /\[.*?\]/msgi;
					var errorTitle:RegExp = /^Error.*?at\s/msi;
					
					stackTrace = e.getStackTrace().replace(debuggerData,"").replace(errorTitle,"current method stack:\n\t");
				}
			}
			return stackTrace;
		}
		
		/**
		Provide custom logger to handle messages.
		
		<p>
		Logger must provide log(value:String) method.
		No interface required to maximize flexibility. Duck typing is used.
		</p>
		
		@param Custom logger. Must provide log(value:String) method.
		*/
		static public function set logger(value:Object):void
		{
			if (value == null) _logger = new TraceLogger();
			else
			{
				var f:Function;
				if (value.hasOwnProperty("log")) f = value["log"] as Function;
				if (f == null) throw new Error("logger must provide log(value:String) method");
				_logger = value;
			}
		}
		
		/** @private */
		static public function get logger():Object
		{
			return _logger;
		}
		
		/**
		Turn logging on.
		
		@param customLogger Optional handler for log messages (default is trace).
		Must provide log(value:String) method.
		*/
		static public function enable(customLogger:Object=null):void
		{
			_enabled = true;
			logger = (customLogger == null) ? _logger : customLogger;
			out(C, "---{ [Trace Log Activated] }---");
		}
		
		/**
		Turn logging off.
		*/
		static public function disable():void
		{
			_enabled = false;
			out(C, "---{ [Trace Log Deactivated] }---", true);
		}

		/**
			Is logging enabled?
			
			<p>
			<code>true</code> for enabled, <code>false</code> for disabled
			</p>
		*/
		static public function get enabled():Boolean { return (_enabled == true); }

		
		static private function format(origin:*, value:String, force:Boolean=false, fullPath:Boolean=false):String
		{
			if (!nameMap[origin]) nameMap[origin] = getQualifiedClassName(origin).split("::");
			var packages:Array = nameMap[origin] as Array;
			var originClass:String = fullPath ? packages.join(".") : String(packages[packages.length-1]);
			var f:String = force ? " *" : "  ";
			var msg:String = pad(getTimer().toString()) +f +"[" +originClass +"] " +value;
			
			return msg;
		}
		
		static private function pad(s:String, p:uint = 8):String
		{
			while(s.length < p) { s = "0" +s; }
			return s;
		}
	}
}

class TraceLogger
{
	public function TraceLogger() { }
	public function log(value:String):void { trace(value); }
}

