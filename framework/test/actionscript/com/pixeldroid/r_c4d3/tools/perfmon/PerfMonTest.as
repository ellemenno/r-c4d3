
/*
from test/actionscript
mxmlc com/pixeldroid/r_c4d3/tools/perfmon/PerfmonTest.as -sp=./ -sp=../../source/actionscript
*/
package com.pixeldroid.r_c4d3.tools.perfmon
{
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.tools.perfmon.PerfMon;
	
	
	[SWF(width="600", height="400", frameRate="100", backgroundColor="#000000")]
    public class PerfMonTest extends Sprite
	{
	
		private var pm:PerfMon;
		
		
		public function PerfMonTest():void
		{
			addChildren();
		}
		
		private function addChildren():void
		{
			pm = addChild(new PerfMon()) as PerfMon;
			pm.x = 15;
			pm.y = 15;
		}
		
	}
}

