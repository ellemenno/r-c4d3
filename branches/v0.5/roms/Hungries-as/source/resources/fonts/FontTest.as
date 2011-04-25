
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
			var s:Number = 24;
			var w:Number = stage.stageWidth;
			fonts.push( addChild(FontAssets.createTextField(fontabet("deLarge"), FontAssets.deLarge(s), w)) );
			fonts.push( addChild(FontAssets.createTextField(fontabet("telegramaRender"), FontAssets.telegramaRender(s), w)) );
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
		
		private function fontabet(fontName:String):String
		{
			var s:String = fontName +'\n';
			var A:Number = 'A'.charCodeAt(0);
			var a:Number = 'a'.charCodeAt(0);
			for (var c:int=33; c<128; c++)
			{
				if (c == A || c == a) s += '\n';
				s += String.fromCharCode(c);
			}
			return s;
		}
		
	}
}

