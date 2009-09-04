
package
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**

		Mini logger.
		
		<p>
		trace replacement.
		</p>
		
		@example Usage:
		<listing version="3.0">
		C.enabled = true; // just once
		C.out(this, "bar bat baz");
		</listing>
		
		@example Usage (forced trace):
		<listing version="3.0">
		C.out(this, "foo happened!", true); // temporary override of enabled
		</listing>

	*/
	final public class C
	{

		private static var _enabled:Boolean;

		/**
			Prints message to trace log, with timestamp and calling class prefixed.

			@param origin Calling class, typically <code>this</code>, e.g. <code>C.out(this, "hello")</code>. 
			If calling from within a static method, pass the class directly, e.g. <code>C.out(MyStaticClass, "hello from a static method")</code>. 
			@param s Message to trace
			@param force When true, override enabledness, e.g. for critical error
			@param fullPath When true, prefix with entire classpath instead of just class name 
			and in debug player, append source file and line number of calling function
		*/
		public static function out(origin:*, s:String, force:Boolean=false, fullInfo:Boolean=false):void {
			if (_enabled || force) {
				var packages:Array = getQualifiedClassName(origin).split("::");
				var originClass:String = fullInfo ? packages.join(".") : String(packages[packages.length-1]);
				var f:String = force ? " *" : "  ";
				var st:String = fullInfo ? Object(new Error("Line")).getStackTrace() : null;
				var ln:String = st ? " (" +st.split("\n")[2].split("[")[1].split("]")[0] +")" : "";
				var msg:String = pad(getTimer().toString()) +f +"[" +originClass +"] " +s +ln;
				trace(msg);
			}
		}

		/**
			Is C enabled?
			<code>true</code> for enabled, <code>false</code> for disabled

			@param b <code>true</code> when enabled, <code>false</code> when disabled
		*/
		public static function get enabled():Boolean { return (_enabled == true); }
		/** @private */
		public static function set enabled(b:Boolean):void {
			var wasEnabled:Boolean = _enabled;
			_enabled = b;

			if (wasEnabled==false && _enabled==true) {
				out(C, "---{ [ Trace Log Activated ] }---");
			}
			else if (wasEnabled==true && _enabled==false) {
				out(C, "---{ [Trace Log Deactivated] }---", true);
			}
		}

		private static function pad(s:String, p:uint = 8):String {
			while(s.length < p) { s = "0" +s; }
			return s;
		}
	}
}
