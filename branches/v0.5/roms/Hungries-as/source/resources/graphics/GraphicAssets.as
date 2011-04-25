
package
{
	import flash.display.Sprite;
	
	
	final public class GraphicAssets
	{
		
		static public function get player():Sprite
		{
			var r:Number = 20;
			var s:Sprite = new Sprite();
			
			s.graphics.beginFill(0xffffff);
			s.graphics.drawCircle(r/2,r/2, r);
			s.graphics.endFill();
			
			return s;
		}
		
		static public function get goody():Sprite
		{
			var r:Number = 16;
			var s:Sprite = new Sprite();
			
			s.graphics.beginFill(0xaaaaaa);
			s.graphics.drawCircle(r/2,r/2, r);
			s.graphics.endFill();
			
			return s;
		}
		
	}
}