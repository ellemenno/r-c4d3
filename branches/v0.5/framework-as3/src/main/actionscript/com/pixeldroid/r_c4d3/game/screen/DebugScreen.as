

package com.pixeldroid.r_c4d3.game.screen
{
	
	import com.pixeldroid.r_c4d3.Version;
	import com.pixeldroid.r_c4d3.api.events.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.api.events.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;
	import com.pixeldroid.r_c4d3.tools.console.Console;
	import com.pixeldroid.r_c4d3.tools.console.ConsoleProperties;
	import com.pixeldroid.r_c4d3.tools.framerate.FpsMeter;
	import com.pixeldroid.r_c4d3.tools.perfmon.PerfMon;
	
	import flash.display.Sprite;
	
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
		protected var console:Console;
		
		
		public function DebugScreen():void
		{
			super();
		}
		
		
		override protected function customInitialization():Boolean
		{
			var cProps:ConsoleProperties = new ConsoleProperties();
			cProps.width = stage.stageWidth;
			cProps.height = stage.stageHeight;
			cProps.bufferSize = 256;
			console = addChild(new Console(cProps)) as Console;
			C.enable(console, true); // prepend prelog
			C.out(this, Version.productInfo);
			
			numEvents = 0;
			
			return true;
		}
		
		override protected function customShutDown():Boolean
		{
			fps.stopMonitoring();
			console.clear();
			
			return true;
		}
		
		override protected function handleFirstScreen():void
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
		
		override protected function handleHatMotion(e:JoyHatEvent):void
		{
			numEvents++;
		}
		
		override protected function handleButtonMotion(e:JoyButtonEvent):void
		{
			numEvents++;
		}
		
		override protected function handleUpdateRequest(dt:int):void
		{
			// update graphs
		}
		
		
	}
}
