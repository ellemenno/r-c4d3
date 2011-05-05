
package 
{

	import com.pixeldroid.r_c4d3.api.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.api.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.api.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.preloader.IPreloader;
	import com.pixeldroid.r_c4d3.preloader.LoadBarPreloader;
	import com.pixeldroid.r_c4d3.romloader.Version;
	import com.pixeldroid.r_c4d3.romloader.controls.RC4D3GameControlsProxy;
	import com.pixeldroid.r_c4d3.romloader.scores.GameScoresProxy;
	import com.pixeldroid.r_c4d3.romloader.scores.RemoteGameScoresProxy;
	import com.pixeldroid.r_c4d3.romloader.RomLoader;
	
	
	
	/**
	Loads a valid IGameRom SWF and provides it access to 
	an RC4D3 game controls proxy and a remote high scores proxy.
	
	Notes:<ul>
	<li><code>romloader-config.xml</code> must declare the custom property <code>scoreServer</code>, defining the score server url</li>
	</ul>

	@see ConfigDataProxy
	@see RomLoader
	@see com.pixeldroid.r_c4d3.proxies.RC4D3GameControlsProxy
	@see com.pixeldroid.r_c4d3.scores.RemoteGameScoresProxy
	*/
	public class RC4D3RomLoader extends RomLoader
	{

		/**
		Constructor.
		
		<p>
		Creates a rom loader designed to interpret keyboard events as R_C4D3 game control events.
		</p>
		*/
		public function RC4D3RomLoader()
		{
			super();
		}
		
		
		/** @inheritDoc */
		override protected function createControlsProxy(configProxy:IGameConfigProxy):IGameControlsProxy
		{
			return new RC4D3GameControlsProxy();
		}
		
		/** @inheritDoc */
		override protected function createScoresProxy(configProxy:IGameConfigProxy):IGameScoresProxy
		{
			return new RemoteGameScoresProxy(
				configProxy.gameId, 
				configProxy.getPropertyValue("scoreServer"),
				GameScoresProxy.ENTRIES_MAX
			);
		}
		
		/** @inheritDoc */
		override protected function createPreloader():IPreloader
		{
			return new LoadBarPreloader();
		}
		
		override protected function get productVersion():String
		{
			return "R-C4D3 Cabinet Rom Loader v" +Version.semver;
		}


	}
}