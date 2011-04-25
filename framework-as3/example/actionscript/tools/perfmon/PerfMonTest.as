
package
{
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.tools.perfmon.PerfMon;
	
	import com.pixeldroid.r_c4d3.Version;
	import com.pixeldroid.r_c4d3.tools.contextmenu.ContextMenuUtil;
	
	
	[SWF(width="600", height="400", frameRate="100", backgroundColor="#000000")]
    public class PerfMonTest extends Sprite
	{
	
		private var pm:PerfMon;
		
		
		public function PerfMonTest():void
		{
			super();
			addVersion();
			addChildren();
		}
		
		private function addVersion():void
		{
			ContextMenuUtil.addItem(this, Version.productInfo, false);
			ContextMenuUtil.addItem(this, Version.buildInfo, false);
		}
		
		private function addChildren():void
		{
			pm = addChild(new PerfMon()) as PerfMon;
			pm.x = 15;
			pm.y = 15;
		}
		
	}
}

