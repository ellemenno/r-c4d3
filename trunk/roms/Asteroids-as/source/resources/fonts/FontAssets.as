
package
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	final public class FontAssets
	{
		
		static private function createTextFormat(fontName:String):TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = fontName;
			format.color = 0xffffff;
			format.size = 24;
			format.align = TextFormatAlign.LEFT;
			return format;
		}
		
		[Embed(source="Blojbytesdepa.ttf", fontName="Blojbytesdepa")]
		static private const Blojbytesdepa:Class;
		
		static public function get blojbytesdepa():TextFormat
		{
			return createTextFormat("Blojbytesdepa");
		}
		
		[Embed(source="DeLarge.ttf", fontName="DeLarge")]
		static private const DeLarge:Class;
		
		static public function get deLarge():TextFormat
		{
			return createTextFormat("DeLarge");
		}
		
		[Embed(source="Sportrop.ttf", fontName="Sportrop")]
		static private const Sportrop:Class;
		
		static public function get sportrop():TextFormat
		{
			return createTextFormat("Sportrop");
		}
		
	}
}