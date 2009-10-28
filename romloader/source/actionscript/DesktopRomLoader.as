
package 
{

	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.proxies.KeyboardGameControlsProxy;
	import com.pixeldroid.r_c4d3.scores.LocalHighScores;

	import ConfigDataProxy;
	import RomLoader;
	
	
	
	/**
	Loads a valid IGameRom SWF and provides it access to 
	an RC4D3 game controls proxy and a remote high scores proxy.

	@see RomLoader
	*/
	public class DesktopRomLoader extends RomLoader
	{

		/**
		Constructor.
		
		<p>
		Creates a rom loader designed for local play and storage.
		</p>
		*/
		public function DesktopRomLoader()
		{
			super();
		}
		
		
		override protected function createControlsProxy():IGameControlsProxy
		{
			return new KeyboardGameControlsProxy();
		}
		
		override protected function createScoresProxy():IGameScoresProxy
		{
			return new LocalHighScores();
		}
		
		override protected function applyControlsConfig(c:IGameControlsProxy, d:ConfigDataProxy):void
		{
			var k:KeyboardGameControlsProxy = KeyboardGameControlsProxy(c);
			
			if (d.p1HasKeys) k.setKeys(0, d.p1U, d.p1R, d.p1D, d.p1L, d.p1X, d.p1A, d.p1B, d.p1C); else C.out(this, "no keys for p1");
			if (d.p2HasKeys) k.setKeys(1, d.p2U, d.p2R, d.p2D, d.p2L, d.p2X, d.p2A, d.p2B, d.p2C); else C.out(this, "no keys for p2");
			if (d.p3HasKeys) k.setKeys(2, d.p3U, d.p3R, d.p3D, d.p3L, d.p3X, d.p3A, d.p3B, d.p3C); else C.out(this, "no keys for p3");
			if (d.p4HasKeys) k.setKeys(3, d.p4U, d.p4R, d.p4D, d.p4L, d.p4X, d.p4A, d.p4B, d.p4C); else C.out(this, "no keys for p4");
		}


	}
}