
package com.pixeldroid.r_c4d3.interfaces
{
	
	/**
	Implementors support methods for initialization and shutdown.
	
	<p>
	The goal is conservation of system resources; implementors should avoid
	unnecessary initialization in the constructor and instead wait for 
	<code>initialize</code> to be called. Similarly, after <code>shutDown</code>,
	the implementor should have removed event listeners and freed memory 
	for garbage collection.
	</p>
	*/
	public interface IDisposable
	{
		/** Request class prepare for use */ function initialize():Boolean;
		/** Request class release memory and listeners and prepare for dormancy */ function shutDown():Boolean;
	}
}
