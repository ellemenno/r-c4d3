
package preloader
{

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;

	import ConfigDataProxy;
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
			C.out(this, "initialize - hello", true);
			progressBar = Shape(addChild(new Shape()));
			progressBar.x = 0;
			progressBar.y = stage.stageHeight * .5 - 2;

			progressBarOutline = Shape(addChild(new Shape()));
			progressBarOutline.x = 0;
			progressBarOutline.y = progressBar.y;
			
			var g:Graphics = progressBarOutline.graphics;
			g.lineStyle(1, 0x222222);
			g.drawRect(0, 0, stage.stageWidth-1, 4);
			
			return true;
		}
		
		public function shutDown():Boolean { return true; }

		
		// IPreloader interface
		public function open():void { dispatchEvent(new Event(Event.OPEN, true)); }
		
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
