
package 
{

	import flash.utils.getQualifiedClassName;
	
	import com.pixeldroid.r_c4d3.interfaces.IGameRom;
	import com.pixeldroid.r_c4d3.interfaces.HaxeSideDoor;
	import com.pixeldroid.r_c4d3.proxies.RC4D3GameControlsProxy;
	import com.pixeldroid.r_c4d3.scores.RemoteHighScores;

	import ConfigDataProxy;
	import DesktopRomLoaderForKeyboard;
	
	
	
	/**
	Loads a valid IGameRom SWF and provides it access to 
	an IGameControlsProxy and an IGameScoresProxy. 
	
	<p>
	The IGameRom SWF url to load is defined in a companion xml file that must 
	live in the same folder as the 	WebRomLoaderForRC4D3 SWF and be
	named <code>romloader-config.xml</code>.
	</p>
	
	<p>
	Game control events are triggered by keyboard events. The particular keys 
	are defined in a companion xml file that must live in the same folder as the 
	WebRomLoaderForRC4D3 SWF and be named <code>romloader-config.xml</code>.
	</p>
	
	@example Sample <code>romloader-config.xml</code>:
	<listing version="3.0">
    &lt;configuration&gt;
        &lt;!-- trace logging on when true --&gt;
        &lt;logging enabled="true" /&gt;

        &lt;!-- rom to load --&gt;
        &lt;rom file="../controls/ControlTestGameRom.swf" /&gt;

        &lt;!-- key mappings, player numbers start at 1 --&gt;
        &lt;keymappings&gt;
            &lt;joystick playerNumber="1"&gt;
				&lt;hatUp    keyCode="38" /&gt;
				&lt;hatRight keyCode="39" /&gt;
				&lt;hatLeft  keyCode="37" /&gt;
				&lt;hatDown  keyCode="40" /&gt;
				&lt;buttonY  keyCode="17" /&gt;
				&lt;buttonR  keyCode="46" /&gt;
				&lt;buttonG  keyCode="35" /&gt;
				&lt;buttonB  keyCode="34" /&gt;
            &lt;/joystick&gt;
        &lt;/keymappings&gt;
    &lt;/configuration&gt;
	</listing>

	<p>Note: <i>
	Due to the way HaXe inserts top-level classes when compiling a SWF,
	HaXe users must use the HaxeSideDoor class to declare IGameRom compliance.
	</i></p>
	
	@see com.pixeldroid.interfaces.IGameControlsProxy
	@see com.pixeldroid.interfaces.IGameScoresProxy
	@see com.pixeldroid.interfaces.HaxeSideDoor
	*/
	public class WebRomLoaderForRC4D3 extends DesktopRomLoaderForKeyboard
	{

		/**
		Constructor.
		
		<p>
		Creates a rom loader designed to interpret keyboard events as R_C4D3 game control events.
		</p>
		*/
		public function WebRomLoaderForRC4D3()
		{
			super();
		}

		

		/*
			@inheritdoc
		*/
		override protected function finalizeLoad():void
		{
			C.out(this, "finalizeLoad");
			_removeListeners();
			removeChild(preloaderContainer);
			
			if (romLoader.content)
			{
				var gameRom:IGameRom;
				
				if (romLoader.content is IGameRom) gameRom = IGameRom(romLoader.content);
				else if (getQualifiedClassName(romLoader.content) == "flash::Boot")
				{
					if (HaxeSideDoor.romInstance && HaxeSideDoor.romInstance is IGameRom) gameRom = IGameRom(HaxeSideDoor.romInstance);
				}
				else trace("finalizeLoad() - Error: content is not a valid rom (" +getQualifiedClassName(romLoader.content) +")");
				
				if (gameRom)
				{
					C.out(this, "finalizeLoad() - valid game rom found, sending over controls proxy and scores proxy")
					
					// provide access to game controls and high scores
					controlsProxy = new RC4D3GameControlsProxy();
					var k:ConfigDataProxy = configData;
					if (k.p1HasKeys) controlsProxy.setKeys(0, k.p1U, k.p1R, k.p1D, k.p1L, k.p1X, k.p1A, k.p1B, k.p1C); else C.out(this, "no keys for p1");
					if (k.p2HasKeys) controlsProxy.setKeys(1, k.p2U, k.p2R, k.p2D, k.p2L, k.p2X, k.p2A, k.p2B, k.p2C); else C.out(this, "no keys for p2");
					if (k.p3HasKeys) controlsProxy.setKeys(2, k.p3U, k.p3R, k.p3D, k.p3L, k.p3X, k.p3A, k.p3B, k.p3C); else C.out(this, "no keys for p3");
					if (k.p4HasKeys) controlsProxy.setKeys(3, k.p4U, k.p4R, k.p4D, k.p4L, k.p4X, k.p4A, k.p4B, k.p4C); else C.out(this, "no keys for p4");
					
					highScoresProxy = new RemoteHighScores();
					
					romLoader.visible = true; // reveal container
					
					gameRom.setControlsProxy(controlsProxy);
					gameRom.setScoresProxy(highScoresProxy);
					
					C.out(this, "finalizeLoad() - game should be ready, calling enterAttractLoop()")
					gameRom.enterAttractLoop();
				}
			}
			else C.out(this, "finalizeLoad() - Error: content unable to be loaded");
		}
		
	}
}