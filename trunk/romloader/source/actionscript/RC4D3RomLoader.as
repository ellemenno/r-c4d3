
package 
{

	import com.pixeldroid.r_c4d3.interfaces.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.controls.RC4D3GameControlsProxy;
	import com.pixeldroid.r_c4d3.scores.RemoteGameScoresProxy;

	import ConfigDataProxy;
	import RomLoader;
	import preloader.IPreloader;
	import preloader.LoadBarPreloader;
	
	
	
	/**
	Loads a valid IGameRom SWF and provides it access to 
	an RC4D3 game controls proxy and a remote high scores proxy.

	<p><i>
	NOTE: The configuration data is expected to contain the high score 
	server url under a property named 'scoreServer'.
	</i></p>

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
		override protected function createControlsProxy(configData:IGameConfigProxy):IGameControlsProxy
		{
			return new RC4D3GameControlsProxy();
		}
		
		/** @inheritDoc */
		override protected function createScoresProxy(configData:IGameConfigProxy):IGameScoresProxy
		{
			return new RemoteGameScoresProxy(configData.gameId, configData.getPropertyValue("scoreServer"));
		}
		
		/** @inheritDoc */
		override protected function createPreloader():IPreloader
		{
			return new LoadBarPreloader();
		}


	}
}