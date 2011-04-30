
package preloader
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import com.pixeldroid.r_c4d3.interfaces.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;

	import ConfigDataProxy;
	import preloader.IPreloader;
	
	
	public class NullPreloader extends Sprite implements IPreloader
	{
		
		protected var progressEvent:ProgressEvent;

		
		public function NullPreloader()
		{
			super();
		}
		
		
		// IDisposable interface
		public function initialize():Boolean { return true; }
		public function shutDown():Boolean { return true; }
		
		// IPreloader interface
		public function open():void { dispatchEvent(new Event(Event.OPEN, true)); }
		public function set progress(value:ProgressEvent):void
		{
			progressEvent = value;
			if (value.bytesLoaded > 0 && value.bytesLoaded == value.bytesTotal) 
				dispatchEvent(new Event(Event.CLOSE, true));
		}
		public function get progress():ProgressEvent { return progressEvent; }
		
		public function onConfigData(configProxy:IGameConfigProxy, controlsProxy:IGameControlsProxy, scoresProxy:IGameScoresProxy):void {}
	}
	
}
