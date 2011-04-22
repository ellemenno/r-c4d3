
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import GraphicAssets;
	
	
	[SWF(width="150", height="300", frameRate="60", backgroundColor="#000000")]
    public class GraphicsTest extends Sprite
	{
	
		private var sprites:Array = [];
		
		
		public function GraphicsTest()
		{
			addChildren();
			fitToGrid();
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function addChildren():void
		{
			sprites.push( addChild(GraphicAssets.ship) );
			sprites.push( addChild(GraphicAssets.zap) );
			sprites.push( addChild(GraphicAssets.rock01) );
			sprites.push( addChild(GraphicAssets.rock02) );
			sprites.push( addChild(GraphicAssets.rock03) );
		}
		
		private function fitToGrid():void
		{
			var c:int = 0;
			var r:int = 0;
			var g:int = 50;
			
			for each (var d:DisplayObject in sprites)
			{
				d.x = c*g + Math.max(g*.5, d.width*.5);
				d.y = r*g + Math.max(g*.5, d.height*.5);
				
				c++;
				if (c*g > stage.stageWidth - g)
				{
					c = 0;
					r++;
				}
			}
		}
		
		private function onFrame(e:Event):void
		{
			for each (var d:DisplayObject in sprites) d.rotation++;
		}
	}
}

