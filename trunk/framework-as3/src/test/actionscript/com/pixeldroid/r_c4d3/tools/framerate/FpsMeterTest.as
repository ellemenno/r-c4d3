
/*
from test/actionscript
mxmlc com/pixeldroid/r_c4d3/tools/framerate/FpsMeterTest.as -sp=./ -sp=../../source/actionscript
*/
package com.pixeldroid.r_c4d3.tools.framerate
{
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.tools.framerate.FpsMeter;
	
	
	[SWF(width="600", height="400", frameRate="100", backgroundColor="#000000")]
    public class FpsMeterTest extends Sprite
	{
	
		private var fps:FpsMeter;
		
		
		public function FpsMeterTest():void
		{
			super();
			addChildren();
			fps.startMonitoring();
		}
		
		private function addChildren():void
		{
			fps = addChild(new FpsMeter()) as FpsMeter;
			fps.targetRate = 60;
			fps.x = 15;
			fps.y = 15;
		}
		
	}
}

