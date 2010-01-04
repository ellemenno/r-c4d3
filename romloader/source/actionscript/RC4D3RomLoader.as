
package 
{

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

	@see RomLoader
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
		
		
		override protected function createControlsProxy(configData:ConfigDataProxy):IGameControlsProxy
		{
			return new RC4D3GameControlsProxy();
		}
		
		override protected function createScoresProxy(configData:ConfigDataProxy):IGameScoresProxy
		{
			// TODO: set score server url and game id from config
			//return new RemoteGameScoresProxy(configData.gameId, server);
			return null;
		}
		
		override protected function createPreloader():IPreloader
		{
			return new LoadBarPreloader();
		}


	}
}