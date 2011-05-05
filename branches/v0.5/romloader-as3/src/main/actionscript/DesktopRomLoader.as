
package 
{

	import com.pixeldroid.r_c4d3.api.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.api.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.api.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.preloader.IPreloader;
	import com.pixeldroid.r_c4d3.preloader.LoadBarPreloader;
	import com.pixeldroid.r_c4d3.romloader.Version;
	import com.pixeldroid.r_c4d3.romloader.controls.KeyboardGameControlsProxy;
	import com.pixeldroid.r_c4d3.romloader.scores.LocalGameScoresProxy;
	
	import flash.display.StageDisplayState;
	import com.pixeldroid.r_c4d3.romloader.RomLoader;
	
	
	
	/**
	Loads a valid IGameRom SWF and provides it access to 
	a keyboard game controls proxy and a local high scores proxy.
	
	Notes:<ul>
	<li><code>romloader-config.xml</code> can declare the custom property <code>fullScreen</code> with boolean value <code>true</code> to launch game in fullscreen mode</li>
	<li>Requires <code>com.adobe.serialization.json.JSON</code></li>
	</ul>

	@see ConfigDataProxy
	@see RomLoader
	@see com.pixeldroid.r_c4d3.proxies.KeyboardGameControlsProxy
	@see com.pixeldroid.r_c4d3.scores.LocalGameScoresProxy
	*/
	public class DesktopRomLoader extends RomLoader
	{

		/**
		Constructor.
		
		<p>
		Creates a rom loader designed for local play and scores storage.
		</p>
		*/
		public function DesktopRomLoader()
		{
			super();
		}

		override protected function createControlsProxy(configProxy:IGameConfigProxy):IGameControlsProxy
		{
			var k:KeyboardGameControlsProxy = new KeyboardGameControlsProxy();
			var d:IGameConfigProxy = configProxy; // shorthand for next few lines
			
			if (d.p1HasKeys) k.setKeys(0, d.p1U, d.p1R, d.p1D, d.p1L, d.p1X, d.p1A, d.p1B, d.p1C);
			if (d.p2HasKeys) k.setKeys(1, d.p2U, d.p2R, d.p2D, d.p2L, d.p2X, d.p2A, d.p2B, d.p2C);
			if (d.p3HasKeys) k.setKeys(2, d.p3U, d.p3R, d.p3D, d.p3L, d.p3X, d.p3A, d.p3B, d.p3C);
			if (d.p4HasKeys) k.setKeys(3, d.p4U, d.p4R, d.p4D, d.p4L, d.p4X, d.p4A, d.p4B, d.p4C);
			
			return k;
		}
		
		override protected function createScoresProxy(configProxy:IGameConfigProxy):IGameScoresProxy
		{
			return new LocalGameScoresProxy(configProxy.gameId);
		}
		
		override protected function createPreloader():IPreloader
		{
			return new LoadBarPreloader();
		}
		
		override protected function finalizeLoad(configProxy:IGameConfigProxy, controlsProxy:IGameControlsProxy, highScoresProxy:IGameScoresProxy):void
		{
			super.finalizeLoad(configProxy, controlsProxy, highScoresProxy);
			
			if (configProxy.getPropertyValue("fullScreen").toLowerCase() == "true")
			{
				stage.fullScreenSourceRect = romLoader.getBounds(this);
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		
		override protected function get productVersion():String
		{
			return "R-C4D3 Desktop Rom Loader v" +Version.semver;
		}


	}
}