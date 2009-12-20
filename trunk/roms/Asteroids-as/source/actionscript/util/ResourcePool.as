
package util
{
	import flash.utils.Dictionary;
	
	
	public class ResourcePool
	{
		
		protected var resources:Dictionary = new Dictionary();
		
		public function retrieve(className:Class, id:String):Object
		{
			if (resources[id] == null) resources[id] = new className();
			return resources[id];
		}
		
	}
}