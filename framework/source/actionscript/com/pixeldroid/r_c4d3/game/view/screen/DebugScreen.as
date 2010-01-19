

package com.pixeldroid.r_c4d3.game.view.screen
{
	
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.tools.framerate.FpsMeter;
	import com.pixeldroid.r_c4d3.tools.perfmon.PerfMon;
	
	/**
	A ScreenBase implementation to provide on-screen performance statistics.
	
	<p>
	The DebugScreen screen is typically added as a layer above the game, and is 
	not part of the screen flow.
	</p>
	
	@see com.pixeldroid.r_c4d3.tools.framerate.FpsMeter
	@see com.pixeldroid.r_c4d3.tools.framerate.PerfMon
	*/
	public class DebugScreen extends ScreenBase
	{
		
		protected var numEvents:int;
		protected var graphs:Sprite;
		protected var fps:FpsMeter;
		protected var pm:PerfMon;
		
		
		public function DebugScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		override public function initialize():Boolean
		{
			numEvents = 0;
			
			return super.initialize();
		}
		
		override protected function onFirstScreen():void
		{
			graphs = addChild(new Sprite) as Sprite;
			
			fps = graphs.addChild(new FpsMeter()) as FpsMeter;
			fps.targetRate = 45;
			fps.startMonitoring();
			
			pm = graphs.addChild(new PerfMon(27)) as PerfMon;
			pm.x = 125;
			//pm.x = fps.x + fps.width + 5; // TODO: width is reporting high (212 vs 125 or so)
			
			graphs.x = stage.stageWidth - graphs.width - 12;
			graphs.y = 15;
		}
		
		override public function shutDown():Boolean
		{
			fps.stopMonitoring();
			
			return super.shutDown();
		}
		
		override public function onUpdateRequest(dt:int):void
		{
			super.onUpdateRequest(dt);
			
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
