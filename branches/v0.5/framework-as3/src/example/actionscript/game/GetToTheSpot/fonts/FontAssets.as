
package
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	final public class FontAssets
	{
		static private const TextFormatAlignLeft:String = "left";//TextFormatAlign.LEFT;
		
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

		
		[Embed(mimeType="application/x-font", source="FrucadeMedium.ttf", fontName="FrucadeMedium", embedAsCFF="false")]
		static private const FrucadeMedium:Class;
		
		static public function frucadeMedium(size:Number=120, color:uint=0xffffff, align:String=TextFormatAlignLeft):TextFormat
		{
			return createTextFormat("FrucadeMedium", size, color, align);
		}
		
		[Embed(mimeType="application/x-font", source="TelegramaRender.ttf", fontName="TelegramaRender", embedAsCFF="false")]
		static private const TelegramaRender:Class;
		
		static public function telegramaRender(size:Number=24, color:uint=0xffffff, align:String=TextFormatAlignLeft):TextFormat
		{
			return createTextFormat("TelegramaRender", size, color, align);
		}
		
		
		static private function createTextFormat(fontName:String, size:Number=24, color:uint=0xffffff, align:String=TextFormatAlignLeft):TextFormat
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