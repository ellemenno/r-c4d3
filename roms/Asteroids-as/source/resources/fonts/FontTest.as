
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import FontAssets;
	
	
	[SWF(width="600", height="500", frameRate="1", backgroundColor="#000000")]
    public class FontTest extends Sprite
	{
	
		private var fonts:Array = [];
		
		
		public function FontTest()
		{
			addChildren();
			fitToGrid();
		}
		
		
		private function addChildren():void
		{
			fonts.push( addChild(textField(FontAssets.blojbytesdepa)) );
			fonts.push( addChild(textField(FontAssets.deLarge)) );
			fonts.push( addChild(textField(FontAssets.sportrop)) );
		}
		
		private function fitToGrid():void
		{
			var n:int = fonts.length;
			var r:int = 0;
			var d:DisplayObject;
			
			for (var i:int = 0; i < n; i++)
			{
				d = fonts[i];
				d.y = r;
				r += d.height;
			}
		}
		
		private function textField(format:TextFormat):TextField
		{
			var t:TextField = new TextField();
			t.selectable = false;
			t.embedFonts = true;
			t.multiline = true;
			t.wordWrap = true;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.width = stage.stageWidth;
			t.text = fontabet;
			t.setTextFormat(format);
			
			return t;
		}
		
		private function get fontabet():String
		{
			return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`~!@#$%^&*()-_=+\\|[{]};:'\",<.>/?";
		}
		
	}
}

