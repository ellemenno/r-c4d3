
package
{
	import flash.display.Sprite;
	
	
	final public class GraphicAssets
	{
		
		[Embed(source="ship.svg", mimeType="image/svg")]
		static private const Ship:Class;
		
		static public function get ship():Sprite
		{
			return new Ship() as Sprite;
		}
		
		[Embed(source="zap.svg", mimeType="image/svg")]
		static private const Zap:Class;
		
		static public function get zap():Sprite
		{
			return new Zap() as Sprite;
		}
		
		[Embed(source="rock01.svg", mimeType="image/svg")]
		static private const Rock01:Class;
		
		static public function get rock01():Sprite
		{
			return new Rock01() as Sprite;
		}
		
		[Embed(source="rock02.svg", mimeType="image/svg")]
		static private const Rock02:Class;
		
		static public function get rock02():Sprite
		{
			return new Rock02() as Sprite;
		}
		
		[Embed(source="rock03.svg", mimeType="image/svg")]
		static private const Rock03:Class;
		
		static public function get rock03():Sprite
		{
			return new Rock03() as Sprite;
		}
	}
}