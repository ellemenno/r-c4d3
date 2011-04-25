
/*
from test/actionscript
mxmlc com/pixeldroid/r_c4d3/tools/console/ConsoleTest.as -sp=./ -sp=../../source/actionscript
*/
package com.pixeldroid.r_c4d3.tools.console
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.pixeldroid.r_c4d3.tools.console.Console;
	
	
	[SWF(width="600", height="400", frameRate="3", backgroundColor="#000000")]
    public class ConsoleTest extends Sprite
	{
	
		private var C:Console;
		
		
		public function ConsoleTest():void
		{
			super();
			addChildren();
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function addChildren():void
		{
			C = addChild(new Console(stage.stageWidth, stage.stageHeight)) as Console;
			C.out("Hello, World, random gibberish to follow..");
		}
		
		private function onFrame(e:Event):void
		{
			C.out(makeMessage(r(50,15)));
		}
		
		private function makeMessage(length:int):String
		{
			var alpha:String = "rstln eiao rstln eiao bcdefghijklmnopqrstuvwxyz";
			var s:String = alpha.charAt(r(alpha.indexOf("b"), alpha.length));
			while (s.length < length) s += alpha.charAt(r(alpha.length));
			return s;
		}
		
		private function r(hi:int, lo:int=0):int
		{
			return Math.floor(Math.random()*(hi-lo)) + lo;
		}
		
	}
}

