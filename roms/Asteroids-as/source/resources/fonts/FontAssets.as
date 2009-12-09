
package
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	final public class FontAssets
	{
		static public function createTextField(text:String="", format:TextFormat=null, width:Number=100, wordWrap:Boolean=true, multiline:Boolean=true, selectable:Boolean=false, embedFonts:Boolean=true):TextField
		{
			var field:TextField = new TextField();
			field.autoSize = TextFieldAutoSize.LEFT;
			field.width = width;
			field.wordWrap = wordWrap;
			field.multiline = multiline;
			field.selectable = selectable;
			field.embedFonts = embedFonts;
			
			field.defaultTextFormat = format;
			field.text = text;
			
			return field;
		}
		
		[Embed(source="Blojbytesdepa.ttf", fontName="Blojbytesdepa")]
		static private const Blojbytesdepa:Class;
		
		static public function blojbytesdepa(size:Number=24, color:uint=0xffffff, align:String=TextFormatAlign.LEFT):TextFormat
		{
			return createTextFormat("Blojbytesdepa", size, color, align);
		}
		
		[Embed(source="DeLarge.ttf", fontName="DeLarge")]
		static private const DeLarge:Class;
		
		static public function deLarge(size:Number=120, color:uint=0xffffff, align:String=TextFormatAlign.LEFT):TextFormat
		{
			return createTextFormat("DeLarge", size, color, align);
		}
		
		[Embed(source="Sportrop.ttf", fontName="Sportrop")]
		static private const Sportrop:Class;
		
		static public function sportrop(size:Number=48, color:uint=0xffffff, align:String=TextFormatAlign.LEFT):TextFormat
		{
			return createTextFormat("Sportrop", size, color, align);
		}
		
		
		static private function createTextFormat(fontName:String, size:Number=24, color:uint=0xffffff, align:String=TextFormatAlign.LEFT):TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = fontName;
			format.color = color;
			format.size = size;
			format.align = align;
			return format;
		}
	}
}