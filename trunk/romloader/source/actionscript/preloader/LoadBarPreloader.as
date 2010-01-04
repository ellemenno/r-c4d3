
package preloader
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import preloader.IPreloader;
	
	
	public class LoadBarPreloader extends Sprite implements IPreloader
	{
		
		protected var progressEvent:ProgressEvent;
		protected var progressBar:Shape;
		protected var progressBarOutline:Shape;
		
		
		public function LoadBarPreloader()
		{
			super();
		}
		
		
		// IDisposable interface
		public function initialize():Boolean
		{
			progressBar = Shape(addChild(new Shape()));
			progressBar.x = 0;
			progressBar.y = stage.stageHeight * .5 - 2;

			progressBarOutline = Shape(addChild(new Shape()));
			progressBarOutline.x = 0;
			progressBarOutline.y = progressBar.y;
			
			var g:Graphics = progressBarOutline.graphics;
			g.lineStyle(1, 0x222222);
			g.drawRect(0, 0, stage.stageWidth-1, 4);
		}
		
		public function shutDown():Boolean {}

		
		// IPreloader interface
		public function open():Boolean { dispatchEvent(new Event(Event.OPEN, true)); }
		
		public function set progress(value:ProgressEvent):void
		{
			progressEvent = value;
			
			var progress:Number = (value.bytesTotal > 0) ? (value.bytesLoaded / value.bytesTotal) : 0;
			var w:int = Math.round(progress * stage.stageWidth);
			var g:Graphics;

			progressBar.x = 0;
			progressBar.y = stage.stageHeight * .5 - 2;

			g = progressBar.graphics;
			g.clear();
			g.beginFill(0x444444, .6);
			g.drawRect(0, 0, w, 4);
			g.endFill();

			progressBarOutline.x = 0;
			progressBarOutline.y = progressBar.y;

			g = progressBarOutline.graphics;
			g.clear();
			g.lineStyle(1, 0x222222);
			g.drawRect(0, 0, stage.stageWidth-1, 4);
			
			if (progress == 1) dispatchEvent(new Event(Event.CLOSE, true));
		}
		public function get progress():ProgressEvent { return progressEvent; }
		
		public function onConfigData(configData:ConfigDataProxy, controlsProxy:IGameControlsProxy, scoresProxy:IGameScoresProxy):void {}

	}
	
}
