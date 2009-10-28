
package 
{

	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.proxies.RC4D3GameControlsProxy;
	import com.pixeldroid.r_c4d3.scores.RemoteHighScores;

	import ConfigDataProxy;
	import RomLoader;
	
	
	
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
		
		
		override protected function createControlsProxy():IGameControlsProxy
		{
			return new RC4D3GameControlsProxy();
		}
		
		override protected function createScoresProxy():IGameScoresProxy
		{
			return new RemoteHighScores();
		}


	}
}