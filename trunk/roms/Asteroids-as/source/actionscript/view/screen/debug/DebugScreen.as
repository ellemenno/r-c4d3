

package view.screen.debug
{
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	
	import view.screen.ScreenBase;
	
	
	public class DebugScreen extends ScreenBase
	{
		
		private var numEvents:int;
		
		
		public function DebugScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			if (!super.initialize()) return false;
			
			// TODO: fps monitor
			// TODO: epf / spf / mem graph
			numEvents = 0;
			
			return true;
		}
		
		override public function shutDown():Boolean
		{
			while (numChildren > 0) removeChildAt(0);
			
			return super.shutDown();
		}
		
		override public function onFrameUpdate(dt:int):void
		{
			super.onFrameUpdate(dt);
			
			// update graphs
		}
		
		override public function onHatMotion(e:JoyHatEvent):void
		{
			numEvents++;
		}
		
		override public function onButtonMotion(e:JoyButtonEvent):void
		{
			numEvents++;
		}
		
		
	}
}
