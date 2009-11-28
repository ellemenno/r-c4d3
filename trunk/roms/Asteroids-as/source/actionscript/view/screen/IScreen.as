
package view.screen
{
	
	import util.IDisposable;
	
	
	public interface IScreen
	{
		function set name(value:String):void;
		function get name():String;
		function set type(value:String):void;
		function get type():String;
	}
}
