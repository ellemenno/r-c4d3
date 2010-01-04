
package preloader.keyconfig
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import com.pixeldroid.r_c4d3.proxies.KeyboardGameControlsProxy;
	
	import preloader.keyconfig.Button;
	import preloader.keyconfig.FullFrameSprite;
	import preloader.keyconfig.MainMenu;
	import preloader.keyconfig.SelectKeysMenu;

	
	public class KeyConfigGui extends FullFrameSprite
	{
		private var loadProgressText : TextField;
		private var informationText : TextField;
		
		// Possible modes.
		public const MAIN : int = 0;
		public const KEY_CONFIG : int = 1;
		public const DONE : int = 2;
		
		// See above for possible mode values.
		private var mode : int;
		public final function getMode() : int { return mode; }
		private final function setMode(val : int) : void
		{
			//trace("setMode("+val+")");
			// Remove the old one.
			var sprite : FullFrameSprite = getSpriteForMode(mode);
			if ( this.contains(sprite) )
			{
				removeChild(sprite);
				sprite.deactivate();
			}
			
			// Start rendering the new mode.
			sprite = getSpriteForMode(val);
			addChild(sprite);
			
			// Focus it with root.
			// Otherwise it won't respond to keys after switching screens. :/
			rootStage.focus = sprite;
			
			// Event listeners and such.  Those are important.
			sprite.activate();
			
			// Update the mode tracker.
			mode = val;
			
			if ( mode == MAIN ) informationText.text = mainMenu.getHeader();
			if ( mode == KEY_CONFIG ) informationText.text = selectMenu.getHeader();
			invalidateText();
		}

		// Supply this to get notification of when the players are done setting up.
		// function onConfigComplete() : void
		public var onConfigComplete : Function;
		
		// Private state for the modality.
		private var mainMenu   : MainMenu;
		private var selectMenu : SelectKeysMenu;
		private var doneSprite : FullFrameSprite;
		
		private function getSpriteForMode( _mode : int ) : FullFrameSprite
		{
			switch( _mode )
			{
				case MAIN: return mainMenu;
				case KEY_CONFIG: return selectMenu;
				case DONE: return doneSprite;
				default:
					//trace("getSpriteForMode("+_mode+"): Invalid mode.");
					break;
			}
			return null;
		}
		
		// rootStage must be a stage that will receive input events (keyboard and mouse).
		public function KeyConfigGui(rootStage : Stage, controlsProxy : KeyboardGameControlsProxy)
		{
			super(rootStage);
			
			if ( controlsProxy == null )
				throw "controlsProxy is null!";
			
			mainMenu = new MainMenu(rootStage, controlsProxy, onHeaderChange);
			mainMenu.gotoConfig = gotoConfig;
			mainMenu.gotoDone = gotoDone;
			
			selectMenu = new SelectKeysMenu(rootStage, controlsProxy, onHeaderChange);
			selectMenu.gotoMain = gotoMain;

			doneSprite = new FullFrameSprite(rootStage);
			
			informationText = new TextField();
			informationText.selectable = true;
			addChild(informationText);

			// TODO
			loadProgressText = new TextField();
			//loadProgressText.text = "Load Progress: ";
			//loadProgressText.selectable = true;
			//addChild(loadProgressText);
			
			gotoMain();
			
			// Size all of the widgets correctly.
			onResize();
		}
		
		public override function onResize() : void
		{
			mainMenu.onResize();
			selectMenu.onResize();
			
			informationText.x = fractionalX(5, 800);
			informationText.y = fractionalY(5, 600);
			informationText.width = frameWidth;
			informationText.height = fractionalY(55, 600);
			
			loadProgressText.x = fractionalX(5, 800);
			loadProgressText.y = fractionalY(565, 600);
			loadProgressText.width = frameWidth;
			loadProgressText.height = fractionalY(35, 600);
		}
		
		
		protected override function onActivate() : void
		{
			super.onActivate();
			//trace("KeyConfigGui.onActivate()");
			//mainMenu.activate();
			//selectMenu.activate();
		}
		
		protected override function onDeactivate() : void
		{
			super.onDeactivate();
			//trace("KeyConfigGui.onDeactivate()");
			mainMenu.deactivate();
			selectMenu.deactivate();
		}
		
		private function onHeaderChange( header : String ) : void
		{
			informationText.text = header;
			invalidateText();
		}
		
		private function invalidateText() : void
		{
			var format : TextFormat;
			
			format = new TextFormat();
			format.font = "Times New Roman";
			format.align = TextFormatAlign.CENTER;
			format.bold = true;
			format.color = 0xffffff;
			format.size = 32;
			
			informationText.setTextFormat(format);
			
			format = new TextFormat();
			format.font = "Times New Roman";
			format.align = TextFormatAlign.LEFT;
			format.bold = true;
			format.color = 0xffffff;
			format.size = 18;
			
			loadProgressText.setTextFormat(format);
		}
		
		// Call when this key config gui has met the end of its days
		//   (ex: the rom is loaded and we want this to go away and stop 
		//   clogging memory.)
		public override function finalize() : void
		{
			mainMenu.finalize();
			selectMenu.finalize();
			
			super.finalize();
		}
		
		public function gotoMain() : void
		{
			setMode(MAIN);
		}
		
		public function gotoConfig( playerIndex : int ) : void
		{
			selectMenu.setPlayer(playerIndex);
			setMode(KEY_CONFIG);
			
			
			//trace("p"+playerIndex+"config");
		}

		public function gotoDone() : void
		{
			//trace("finishing up");
			setMode(DONE);

			if ( onConfigComplete != null )
				onConfigComplete();
		}
	}
}