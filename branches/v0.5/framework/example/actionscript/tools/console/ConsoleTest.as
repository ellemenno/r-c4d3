

package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.pixeldroid.r_c4d3.tools.console.Console;
	
	import com.pixeldroid.r_c4d3.Version;
	import com.pixeldroid.r_c4d3.tools.contextmenu.ContextMenuUtil;
	
	
	[SWF(width="600", height="400", frameRate="3", backgroundColor="#000000")]
    public class ConsoleTest extends Sprite
	{
	
		private var console:Console;
		
		
		public function ConsoleTest():void
		{
			super();
			addVersion();
			
			console = addChild(new Console(stage.stageWidth, stage.stageHeight)) as Console;
			C.enable(console);
			
			C.out(this, Version.productInfo);
			C.out(this, "-+-+-+-+-+-+-+-+-+-+-+-+-+");
			C.out(this, "~!@#$%^&*()_+|QWERTYUIOP{}");
			C.out(this, "`1234567890-=\\qwertyuiop[]");
			C.out(this, " _ _ ASDFGHJKL:\"ZXCVBNM<>?");
			C.out(this, "- -  asdfghjkl;'zxcvbnm,./");
			C.out(this, ".,;:|'`.,;:|'`.,;:|'`.,;:|");
			C.out(this, "..........................");
			a();
			C.out(this, "..........................");
			C.out(this, "Hello, World, random gibberish to follow..");
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function addVersion():void
		{
			ContextMenuUtil.addItem(this, Version.productInfo, false);
			ContextMenuUtil.addItem(this, Version.buildInfo, false);
		}
		
		private function onFrame(e:Event):void
		{
			C.out(this, makeMessage(r(50,15)));
		}
		
		private function makeMessage(length:int):String
		{
			var alpha:String = "rstln eiao rstln eiao bcdefghijklmnopqrstuvwxyz";
			var s:String = alpha.charAt(r(alpha.indexOf("b"), alpha.length));
			while (s.length < length) s += alpha.charAt(r(alpha.length));
			return s;
		}
		
		private function a():void { b(); }
		private function b():void { c(); }
		private function c():void { C.out(this, C.stackTrace); }
		
		private function r(hi:int, lo:int=0):int
		{
			return Math.floor(Math.random()*(hi-lo)) + lo;
		}
		
	}
}

