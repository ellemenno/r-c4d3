

package com.pixeldroid.r_c4d3.game.view.screen
{
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	
	
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
			
			numEvents = 0;
			
			return true;
		}
		
		override protected function onFirstScreen():void
		{
			// TODO: fps monitor
			// TODO: epf / spf / mem graph
		}
		
		override public function shutDown():Boolean
		{
			while (numChildren > 0) removeChildAt(0);
			
			return super.shutDown();
		}
		
		override public function onScreenUpdate(dt:int):void
		{
			super.onScreenUpdate(dt);
			
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
