
package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	final public class GraphicAssets
	{
		
		[Embed(mimeType="image/png", source="player.png")]
		static private const PlayerSpot:Class;
		
		static public function get player():Bitmap
		{
			return new PlayerSpot();
		}
		
		static public function get spot():Sprite
		{
			var r:Number = 35;
			var s:Sprite = new Sprite();
			
			s.graphics.lineStyle(3, 0x444444);
			s.graphics.drawCircle(0,0, r);
			s.graphics.endFill();
			
			return s;
		}
		
	}
}