
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import GraphicAssets;
	
	
	[SWF(width="150", height="300", frameRate="1", backgroundColor="#000000")]
    public class GraphicsTest extends Sprite
	{
	
		private var sprites:Array = [];
		
		
		public function GraphicsTest()
		{
			addChildren();
			fitToGrid();
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
			var n:int = sprites.length;
			var c:int = 0;
			var r:int = 0;
			var d:DisplayObject;
			
			for (var i:int = 0; i < n; i++)
			{
				d = sprites[i];
				d.x = c * 50;
				d.y = r * 50;
				
				c++;
				if (c * 50 > stage.stageWidth - 50)
				{
					c = 0;
					r++;
				}
			}
		}
	}
}

