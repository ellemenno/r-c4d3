
package com.pixeldroid.r_c4d3.api
{

	/**
	Provides information about the build that includes this code
		
	<p>
	Requires a compile-time definitions in the 
	<code>VERSION</code> namespace; see example for details.
	</p>
	
	@see http://blogs.adobe.com/flexdoc/files/flexdoc/conditionalcompilation.pdf
	
	@example The following code shows a sample compile-time definition for 
	specifiying the semver string (note the double quoting required for strings):
<listing version="3.0" >
-define+=VERSION::semver,"'0.0.0'"
</listing>
	*/
	final public class Version
	{
		/**
		Semantic version.
	
		@see http://semver.org/
		*/
		static public const semver:String = VERSION::semver;
		
		/** Compilation year */
		static public const year:String = VERSION::year;
		
		/** Compilation month */
		static public const month:String = VERSION::month;
		
		/** Compilation day */
		static public const day:String = VERSION::day;
		
		/** Compilation hour */
		static public const hour:String = VERSION::hour;
		
		/** Compilation minute */
		static public const minute:String = VERSION::minute;
		
		/** Compilation second */
		static public const second:String = VERSION::second;
		
		/** Product version string */
		static public const productInfo:String = "R-C4D3 GameRom API v" +semver;
		
		/** Compilation time stamp */
		static public const buildInfo:String = "compiled " +year +"/" +month +"/" +day +" " +hour +":" +minute +"." +second;
	}
}
