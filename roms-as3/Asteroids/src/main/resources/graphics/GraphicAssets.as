
package
{
	import flash.display.Sprite;
	
	
	final public class GraphicAssets
	{
		
		[Embed(source="ship.svg", mimeType="image/svg")]
		static private const Ship:Class;
		
		static public function get ship():Sprite
		{
			return centeredChild(new Ship());
		}
		
		[Embed(source="zap.svg", mimeType="image/svg")]
		static private const Zap:Class;
		
		static public function get zap():Sprite
		{
			return centeredChild(new Zap());
		}
		
		[Embed(source="rock01.svg", mimeType="image/svg")]
		static private const Rock01:Class;
		
		static public function get rock01():Sprite
		{
			return centeredChild(new Rock01());
		}
		
		[Embed(source="rock02.svg", mimeType="image/svg")]
		static private const Rock02:Class;
		
		static public function get rock02():Sprite
		{
			return centeredChild(new Rock02());
		}
		
		[Embed(source="rock03.svg", mimeType="image/svg")]
		static private const Rock03:Class;
		
		static public function get rock03():Sprite
		{
			return centeredChild(new Rock03());
		}
		
		
		
		static private function centeredChild(value:Sprite):Sprite
		{
			var p:Sprite = new Sprite();
			var c:Sprite = p.addChild(value) as Sprite;
			c.x -= c.width/2;
			c.y -= c.height/2;
			return p;
		}
		
	}
}