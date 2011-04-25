
package com.pixeldroid.r_c4d3.data
{
	import flash.utils.Dictionary;
	
	
	/**
	Simple dictionary of instantiated classes.
	
	<p>
	Classes are retrieved by id; instantiated on first request, re-used on subsequent requests.
	</p>
	*/
	public class ResourcePool
	{
		
		protected var resources:Dictionary = new Dictionary();
		
		/**
		Request an instance of the specified class, stored under the provided id.
		
		@param className The fully qualified classname to retrieve an instance of (used to create the first instance)
		@param id The id to store / retrieve the class instance by
		
		@return An instance of the class stored under the provided id
		*/
		public function retrieve(className:Class, id:*):Object
		{
			if (resources[id] == null) resources[id] = new className();
			return resources[id];
		}
		
		/**
		Remove data stored under the provided id.
		
		@param id The id to remove data from
		
		@return true if data was removed, false if nothing was stored under id to begin with
		*/
		public function remove(id:*):Boolean
		{
			var didExist:Boolean = false;
			if (resources[id] != null)
			{
				didExist = true;
				resources[id] = null;
			}
			return didExist;
		}
		
	}
}