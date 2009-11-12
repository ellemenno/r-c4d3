package keyconfig
{
	import flash.display.Stage;
	import flash.events.FocusEvent; // TODO
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import com.pixeldroid.r_c4d3.proxies.KeyboardGameControlsProxy;
	
	import keyconfig.FullFrameSprite;
	import keyconfig.Button;
	
	public class MainMenu extends FullFrameSprite
	{
		private static const header : String = "Select a player's controls to modify.";
		public function getHeader() : String { return header; }
		
		private var playerButtons : Array /* of Buttons */;
		private var playButton : Button;
		
		// This should be a function with the following signature:
		// function gotoConfig( playerIndex : int ) : void
		public var gotoConfig : Function;

		// This should be a function with the following signature:
		// function gotoDone() : void
		public var gotoDone : Function;
		
		// This callback is called whenever the header changes.
		// It's signature is as follows:
		// function changeHeader( header : String ) : void
		public var changeHeader : Function;
		
		public function MainMenu( rootStage : Stage, controlsProxy : KeyboardGameControlsProxy, changeHeader : Function )
		{
			super(rootStage);
			
			this.changeHeader = changeHeader;
			
			playerButtons = new Array();
			
			playerButtons[0] = new Button("Player 1 controls");
			playerButtons[0].addEventListener(MouseEvent.CLICK, p1config);
			
			playerButtons[1] = new Button("Player 2 controls");
			playerButtons[1].addEventListener(MouseEvent.CLICK, p2config);
			
			playerButtons[2] = new Button("Player 3 controls");
			playerButtons[2].addEventListener(MouseEvent.CLICK, p3config);
			
			playerButtons[3] = new Button("Player 4 controls");
			playerButtons[3].addEventListener(MouseEvent.CLICK, p4config);
			
			for ( var i : int = 0; i < playerButtons.length; i++ )
				addChild(playerButtons[i]);
			
			playButton = new Button("Play!");
			playButton.addEventListener(MouseEvent.CLICK, onPlay);
			addChild(playButton); // TODO
			
			onResize();
		}
		
		protected override function onActivate() : void
		{
			super.onActivate();
			//trace("MainMenu.onActivate()");
			//attemptNewFocus(null,focus);
			addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
		}
		
		protected override function onDeactivate() : void
		{
			super.onDeactivate();
			//trace("MainMenu.onDeactivate()");
			removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
		}
		
		public override function onResize() : void
		{
			for ( var i : int = 0; i < playerButtons.length; i++ )
			{
				var button : Button = playerButtons[i];
				button.x = fractionalX(300, 800);
				button.y = fractionalY(100 + i*80, 600);
				button.width = fractionalX(200, 800);
				button.height = fractionalY(40, 600);
			}

			playButton.x = fractionalX(250, 800);
			playButton.y = fractionalY(480, 600);
			playButton.width = fractionalX(300, 800);
			playButton.height = fractionalY(40, 600);
		}
		
		private function onFocusIn( e : FocusEvent ) : void
		{
			//trace("MainMenu.onFocusIn");
		}
		
		protected override function onFocusChange( e : FocusEvent ) : void
		{
			super.onFocusChange(e);
			//trace("MainMenu.onFocusChange()");
		}
		
		private function p1config( e : MouseEvent ) : void { _gotoConfig(0); }
		private function p2config( e : MouseEvent ) : void { _gotoConfig(1); }
		private function p3config( e : MouseEvent ) : void { _gotoConfig(2); }
		private function p4config( e : MouseEvent ) : void { _gotoConfig(3); }
		
		private function _gotoConfig( playerIndex : int ) : void
		{
			if ( gotoConfig != null )
				gotoConfig(playerIndex);
		}

		private function onPlay( e : MouseEvent ) : void
		{
			//trace("onPlay");
			if ( gotoDone != null )
				gotoDone();
		}
		
		public override function finalize() : void
		{
			for ( var i : int = 0; i < 4; i++ )
				playerButtons[i].finalize();
			
			super.finalize();
		}
	}
}