
package preloader
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import preloader.IPreloader;
	
	
	public class NullPreloader extends Sprite implements IPreloader
	{
		
		protected var progressEvent:ProgressEvent;

		
		public function NullPreloader()
		{
			super();
		}
		
		
		// IDisposable interface
		public function initialize():Boolean {}
		public function shutDown():Boolean {}
		
		// IPreloader interface
		public function open():Boolean { dispatchEvent(new Event(Event.OPEN, true)); }
		public function set progress(value:ProgressEvent):void
		{
			progressEvent = value;
			if (value.bytesLoaded > 0 && value.bytesLoaded == value.bytesTotal) 
				dispatchEvent(new Event(Event.CLOSE, true));
		}
		public function get progress():ProgressEvent { return progressEvent; }
		
		public function onConfigData(configData:ConfigDataProxy, controlsProxy:IGameControlsProxy, scoresProxy:IGameScoresProxy):void {}
	}
	
}
