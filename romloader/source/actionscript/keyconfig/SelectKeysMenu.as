package keyconfig
{
	// TODO: What about setups where some players don't have controls?
	
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	import keyconfig.Button;
	import keyconfig.FullFrameSprite;
	
	import com.pixeldroid.r_c4d3.controls.KeyLabels;
	import com.pixeldroid.r_c4d3.interfaces.IJoystick;
	import com.pixeldroid.r_c4d3.proxies.KeyboardGameControlsProxy;
	
	public class SelectKeysMenu extends FullFrameSprite
	{
		public var header : String = "Please select this character's controls.";
		public function getHeader() : String { return header; }
		
		private var currentPlayer : int = -1;
		private var descriptions : Array /* of TextFields */;
		private var selections : Array /* of KeyFields */;
		private var conflictMsgs : Array /* of TextFields */;
		private var usedKeyCodes : Array;
		private var doneButton : Button;
		private var defaultsButton : Button;
		private var cancelButton : Button;
		private var controlsProxy : KeyboardGameControlsProxy;
		private var controlDefaults : KeyboardGameControlsProxy;
		
		// TODO
		private var debugFmt : TextFormat;
		private var debugTxt : TextField;

		// This is used to implement the "cancel" feature by remembering what the controls were.
		private var controlsBackup : KeyboardGameControlsProxy;
		
		// Eventually, this will give more control of what it looks like to
		//   select one of the keys.
		//private var selector : Shape = new Shape();
		
		// This should be a function with the following signature:
		// function gotoMain() : void
		public var gotoMain : Function;
		
		// This callback is called whenever the header changes.
		// It's signature is as follows:
		// function changeHeader( header : String ) : void
		public var changeHeader : Function;
		
		public function SelectKeysMenu(
			rootStage : Stage,
			controlsProxy : KeyboardGameControlsProxy,
			changeHeader : Function // See the member of same name for details.
			)
		{
			super(rootStage);
			
			this.controlsProxy = controlsProxy;
			this.changeHeader = changeHeader;
			
			controlDefaults = clone(controlsProxy);
			controlsBackup = new KeyboardGameControlsProxy();
			
			var i : int;
			
			selections = new Array();
			descriptions = new Array();
			conflictMsgs = new Array();
			
			for ( i = 0; i < 8; i++ )
			{
				var tf : TextField;
				
				tf = new TextField();
				tf.selectable = false;
				addChild(tf);
				descriptions[i] = tf;
				
				tf = new KeyField(rootStage, assignKeyCode, i);
				tf.focusRect = false;
				tf.tabEnabled = true;
				tf.borderColor = 0xffffff;
				tf.selectable = true;
				tf.text = "";
				addChild(tf);
				selections[i] = tf;
				
				tf = new TextField();
				tf.selectable = false;
				tf.text = "";
				addChild(tf);
				conflictMsgs[i] = tf;
			}
			
			// TODO: This should be configurable.
			descriptions[0].text = "Up";
			descriptions[1].text = "Down";
			descriptions[2].text = "Left";
			descriptions[3].text = "Right";
			descriptions[4].text = "Tether";
			descriptions[5].text = "Repel";
			descriptions[6].text = "Attract";
			descriptions[7].text = "GravBomb";
			
			invalidateText();
			
			doneButton     = new Button("Done");
			defaultsButton = new Button("Defaults");
			cancelButton   = new Button("Cancel");
			
			doneButton.addEventListener(MouseEvent.CLICK,onDone);
			defaultsButton.addEventListener(MouseEvent.CLICK,onDefault);
			cancelButton.addEventListener(MouseEvent.CLICK,onCancel);
			
			addChild(doneButton);
			addChild(defaultsButton);
			addChild(cancelButton);
			
			debugFmt = new TextFormat();
			debugFmt.font = "Times New Roman";
			debugFmt.align = TextFormatAlign.LEFT;
			debugFmt.bold = true;
			debugFmt.color = 0x7f7f7f;
			debugFmt.size = 20;

			debugTxt = new TextField();
			debugTxt.x = 10;
			debugTxt.y = 10;
			debugTxt.width = 500;
			debugTxt.height = 100;
			debugTxt.text = "shared object = ";
			debugTxt.setTextFormat(debugFmt);
			//addChild(debugTxt);

			/*
			usedKeyCodes = new Array();

			for ( i = 0; i < 4; i++ )
			{
				usedKeyCodes[i] = new Array();

				var j : int;
				for ( j = 0; j < 8; j++ )
					usedKeyCodes[i][j] = getGivenKeyCode(i,j);
			}*/

			//conflicts = new Array();
			
			onResize();
		}
		
		private function clone(source:KeyboardGameControlsProxy):KeyboardGameControlsProxy
		{
			var result : KeyboardGameControlsProxy = new KeyboardGameControlsProxy();
			var i : int;
			for ( i = 0; i < 4; i++ )
			{
				
				copyControls(source,result,i);
			}
			return result;
		}

		private function invalidateText() : void
		{
			var format : TextFormat = new TextFormat();
			format.font = "Times New Roman";
			format.align = TextFormatAlign.CENTER;
			format.bold = true;
			format.color = 0xffffff;
			format.size = 28;
			
			var i : int;
			
			for ( i = 0; i < 8; i++ )
				descriptions[i].setTextFormat(format);
			
			format.size = 32;
			
			for ( i = 0; i < 8; i++ )
			{
				selections[i].setTextFormat(format);
				selections[i].defaultTextFormat = format;
			}
			
			for ( i = 0; i < 8; i++ )
				conflictMsgs[i].setTextFormat(format);
		}
		
		// In the case of this menu, onActivate() gets called when it is entered.
		protected override function onActivate() : void
		{
			super.onActivate();
			
			//trace("SelectKeysMenu.onActivate()");
			
			// Start focus at the first key selection always.
			//focus = null;
			////trace("Call SelectKeysMenu.getNextFocus()");
			//getNextFocus();
			////trace("/Call SelectKeysMenu.getNextFocus()");
			
			focus = selections[0];
			selections[0].onFocusIn();
			//selections[0].onKeyUp(null);
			
			fromButtons = false;
			
			
			//addEventListener(FocusEvent.FOCUS_IN,  onFocusIn);
			//rootStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			var i : int;
			for ( i = 0; i < 8; i++ )
				selections[i].activate();
			
			rootStage.addEventListener(KeyboardEvent.KEY_UP,   onKeyUp);
		}
		
		protected override function onDeactivate() : void
		{
			super.onDeactivate();
			//trace("SelectKeysMenu.onDeactivate()");
			//removeEventListener(FocusEvent.FOCUS_IN,  onFocusIn);
			//rootStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			var i : int;
			for ( i = 0; i < 8; i++ )
				selections[i].deactivate();
			
			rootStage.removeEventListener(KeyboardEvent.KEY_UP,   onKeyUp);
		}
		
		public override function onResize() : void
		{
			// Temporaries (used for aligning things).
			var _x : Number;
			var _y : Number;
			var _w : Number;
			var _h : Number;
			
			// Key configuration grid.
			for ( var i : int = 0; i < 8; i++ )
			{
				var tf : TextField;
				_y = fractionalY(70 + 50*i, 600);
				
				tf = descriptions[i];
				tf.x = fractionalX(10, 800);
				tf.y = _y;
				tf.width = fractionalX(180, 800);
				tf.height = fractionalY(40, 600);
				
				tf = selections[i];
				tf.x = fractionalX(300, 800);
				tf.y = _y;
				tf.width = fractionalX(280, 800);
				tf.height = fractionalY(40, 600);
				
				tf = conflictMsgs[i];
				tf.x = fractionalX(600, 800);
				tf.y = _y;
				tf.width = fractionalX(180, 800);
				tf.height = fractionalY(40, 600);
			}
			
			// Center buttons at 150, 400, and 650 to evenly space them.
			doneButton.x     = fractionalX(60,800);
			defaultsButton.x = fractionalX(310,800);
			cancelButton.x   = fractionalX(560,800);
			
			// Align the buttons to a single y value.
			_y = fractionalY(500,600);
			doneButton.y     = _y;
			defaultsButton.y = _y;
			cancelButton.y   = _y;
			
			// Give the buttons a uniform width.
			_w = fractionalX(180,800);
			doneButton.width     = _w;
			defaultsButton.width = _w;
			cancelButton.width   = _w;
			
			// Give the buttons a uniform height.
			_h = fractionalY(40,600);
			doneButton.height     = _h;
			defaultsButton.height = _h;
			cancelButton.height   = _h;
			
			// Redraw the selector.
		}
		
		
		private function onDone( e : MouseEvent ) : void
		{
			if ( gotoMain != null )
				gotoMain();
		}
		
		private function onCancel( e : MouseEvent ) : void
		{
			copyControls(controlsBackup,controlsProxy,currentPlayer);
			if ( gotoMain != null )
				gotoMain();
		}
		
		private function copyControls(
			proxyFrom : KeyboardGameControlsProxy,
			proxyTo   : KeyboardGameControlsProxy,
			player : int
			) : void
		{
			//trace("copyControls");
			var kgcp : Class = KeyboardGameControlsProxy;
			var stick : IJoystick = proxyFrom.joystickOpen(player);
			proxyTo.setKeys( player,
				proxyFrom.joystickGetHatKey(stick,kgcp.HAT_U),
				proxyFrom.joystickGetHatKey(stick,kgcp.HAT_R),
				proxyFrom.joystickGetHatKey(stick,kgcp.HAT_D),
				proxyFrom.joystickGetHatKey(stick,kgcp.HAT_L),
				proxyFrom.joystickGetButtonKey(stick,kgcp.BTN_X),
				proxyFrom.joystickGetButtonKey(stick,kgcp.BTN_A),
				proxyFrom.joystickGetButtonKey(stick,kgcp.BTN_B),
				proxyFrom.joystickGetButtonKey(stick,kgcp.BTN_C)
				);
		}
		
		private function onDefault( e : MouseEvent ) : void
		{
			//var d : KeyboardGameControlsProxy = controlDefaults;
			//trace("onDefault call copyControls");
			copyControls(controlDefaults, controlsProxy, currentPlayer);
				/*
			switch ( currentPlayer )
			{
				case 0: controlsProxy.setKeys
					(0, d.p1U, d.p1R, d.p1D, d.p1L, d.p1X, d.p1A, d.p1B, d.p1C);
					break;
					
				case 1: controlsProxy.setKeys
					(1, d.p2U, d.p2R, d.p2D, d.p2L, d.p2X, d.p2A, d.p2B, d.p2C);
					break;
					
				case 2: controlsProxy.setKeys
					(2, d.p3U, d.p3R, d.p3D, d.p3L, d.p3X, d.p3A, d.p3B, d.p3C);
					break;
					
				case 3: controlsProxy.setKeys
					(3, d.p4U, d.p4R, d.p4D, d.p4L, d.p4X, d.p4A, d.p4B, d.p4C);
					break;
			}*/
			loadKeyConfigData(currentPlayer);
		}
		
		public final function setPlayer( playerIndex : int ) : void
		{
			currentPlayer = playerIndex;
			
			header = "Please select the controls for player "+(playerIndex+1)+".";
			if ( changeHeader != null )
				changeHeader(header);

			copyControls(controlsProxy,controlsBackup,currentPlayer);
			
			loadKeyConfigData(currentPlayer);
		}
		
		private function loadKeyConfigData( playerIndex : int ) : void
		{
			var i : int;
			for ( i = 0; i < 8; i++ )
				_assignKeyCode(getSavedKeyCode(playerIndex, i), playerIndex, i);
			
			// TODO: check conflicts
			
			invalidateText();
		}

		/*
		// Returns player it conflicts with.
		private function checkConflict( keyCode : uint, keyId : int ) : int
		{
			var i : int;
			var j : int;
			
			for ( i = 0; i < 4; i++ )
			{
				for ( j = 0; j < 8; j++ )
				{
					var otherCode : uint = getGivenKeyCode(i,j);
					if ( otherCode == keyCode )
					{
						var conflict : Conflict = new Conflict();
						conflict.keyCode = keyCode;
						conflict.player1 = i;
						conflict.player2 = currentPlayer;
						conflict.keyId1 = j;
						conflict.keyId2 = keyId;
						conflicts[conflicts.length] = conflict;
						
					}
				}
			}
		}

		private function isConflictNoted(  ) : Boolean
		{
		}
		*/
		
		// Only call this when the user is assigning a key.
		private function assignKeyCode( keyCode : uint, keyId : int ) : void
		{
			//trace("assignKeyCode");
			if ( !fromButtons ) // Discard tab events bringing focus to the control fields.
				_assignKeyCode( keyCode, currentPlayer, keyId );
			//getNextFocus(); // Only do this for the player.
		}
		
		// This may be called by the machine to assign a key (ex: for defaults).
		private function _assignKeyCode( keyCode : uint, playerIndex: int, keyId : int ) : void
		{
			selections[keyId].keyCode = keyCode;
			selections[keyId].text = getGivenKeyLabel(playerIndex, keyId);
			invalidateText();
			
			// This is a bit silly, but it should work.
			var args : Array = new Array();
			var i : int;
			for ( i = 0; i < 8; i++ )
			{
				if ( keyId == i )
					args[i] = keyCode;
				else
					args[i] = 0; // Zero does no keycode assignment.
			}
			
			// write out the args and swizzle them into the right order.
			controlsProxy.setKeys(playerIndex,
				args[0], args[3], args[1], args[2],
				args[4], args[5], args[6], args[7]);
		}
		
		private function getGivenKeyLabel( playerIndex : int, keyId : int ) : String
		{
			return humanReadable( getGivenKeyCode(playerIndex, keyId) );
		}
		
		private function getGivenKeyCode( playerIndex : int, keyId : int ) : uint
		{
			if ( selections[keyId].assigned )
				return selections[keyId].keyCode;
			
			return getSavedKeyCode(playerIndex,keyId);
		}
		
		private function getSavedKeyCode( playerIndex : int, keyId : int ) : uint
		{
			var kgcp : Class = KeyboardGameControlsProxy;
			
			switch ( keyId )
			{
				case 0: return getDirKeyCode(kgcp.HAT_U, playerIndex);
				case 1: return getDirKeyCode(kgcp.HAT_D, playerIndex);
				case 2: return getDirKeyCode(kgcp.HAT_L, playerIndex);
				case 3: return getDirKeyCode(kgcp.HAT_R, playerIndex);
				case 4: return getBtnKeyCode(kgcp.BTN_X, playerIndex);
				case 5: return getBtnKeyCode(kgcp.BTN_A, playerIndex);
				case 6: return getBtnKeyCode(kgcp.BTN_B, playerIndex);
				case 7: return getBtnKeyCode(kgcp.BTN_C, playerIndex);
			}
			
			return 0;
		}
		
		private function getDirKeyCode( dirId : int, playerIndex : int ) : uint
		{
			var local : SharedObject = SharedObject.getLocal(
				"GameControlsDirKey"+dirId+"x"+playerIndex);
			
			trace("local.data.keyCode = "+local.data.keyCode);
			debugTxt.text = "local.data.keyCode = "+local.data.keyCode;
			debugTxt.setTextFormat(debugFmt);
			
			var stick : IJoystick = controlsProxy.joystickOpen(playerIndex);
			return controlsProxy.joystickGetHatKey(stick,dirId);
		}
		
		private function getBtnKeyCode( buttonId : int, playerIndex : int ) : uint
		{
			var stick : IJoystick = controlsProxy.joystickOpen(playerIndex);
			return controlsProxy.joystickGetButtonKey(stick,buttonId);
		}
		
		private function getDirKeyLabel( dirId : int, playerIndex : int ) : String
		{
			return humanReadable(getDirKeyCode(dirId, playerIndex));
		}
		
		private function getBtnKeyLabel( buttonId : int, playerIndex : int ) : String
		{
			return humanReadable(getBtnKeyCode(buttonId, playerIndex));
		}
		
		private function humanReadable( keyCode : uint ) : String
		{
			var label : String = KeyLabels.getLabel(keyCode);
			
			// TODO: Comparison against hardcoded string is a bit dubious.
			if ( label == "unknown key" )
				label = "KeyCode = " + String(keyCode);
			
			return label;
		}
		
		private function onKeyDown( e : KeyboardEvent ) : void
		{
			//trace("key down");
		}
		
		// If the user tabs from a button to a control field, then we need to
		//   ignore the onKeyUp when it releases.  Otherwise the tab will count
		//   for both an onFocusChange and the onKeyUp, thus advancing twice
		//   instead of once.  Here we keep track of this kind of onKeyUp event.
		private var fromButtons : Boolean;
		
		private function onKeyUp( e : KeyboardEvent ) : void
		{
			//trace("key up");
			if ( isFocusOnFields() )
			{
				if ( fromButtons )
					fromButtons = false;
				else
					super.getNextFocus();
			}
		}
		
		/*
		private function onFocusIn( e : FocusEvent ) : void
		{
			// Start focus at the first key selection always.
			//focus = null;
			////trace("Call SelectKeysMenu.getNextFocus()");
			//getNextFocus();
			////trace("/Call SelectKeysMenu.getNextFocus()");
			//selections[0].onKeyUp(null);
			//focus = selections[0];
			//selections[0].onFocusIn();
			//selections[0].onKeyUp(null);
		}*/
		
		public override function getNextFocus( dir : int = 1 ) : void
		{
			
			// If someone wants to set tab (or up/down) as a key, let them.
			// Without this if statement, the focus will skip to the next
			//   control without configuring the one it was on.
			if ( !isFocusOnFields() )
			{
				fromButtons = true;
				//super.onFocusChange(e);
				super.getNextFocus(dir);
			}
		}
		
		// TODO: foo is DEAD CODE
		//protected override function onFocusChange( e : FocusEvent ) : void
		private function foo( e : FocusEvent ) : void
		{
			
			// If someone wants to set tab as a key, let them.
			// Without this if statement, the focus will skip to the next
			//   control without configuring the one it was on.
			if ( !isFocusOnFields() )
			{
				fromButtons = true;
				super.onFocusChange(e);
			}
			
			/*
			//trace("SelectKeysMenu.onFocusChange");
			var i : int;
			
			for ( i = 0; i < 8; i++ )
			{
				if ( selections[i] == focus )
					selections[i].border = true;
				else
					selections[i].border = false;
			}*/
		}
		
		private function isFocusOnFields() : Boolean
		{
			var i : int;
			var isConfigFocus : Boolean = false;
			for ( i = 0; i < 8; i++ )
				if ( selections[i].hasFocus )
					isConfigFocus = true;
			return isConfigFocus;
		}
		
		public override function finalize() : void
		{
			defaultsButton.finalize();
			doneButton.finalize();
			cancelButton.finalize();
			
			super.finalize();
		}
	}
}

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.text.TextField;

import keyconfig.ICanFocus;
	
/*private*/ class KeyField extends TextField implements ICanFocus
{
	public var hasFocus : Boolean = false;
	public var assigned : Boolean = false;
	public var keyCode : uint;
	private var rootStage : Stage;
	private var assignKeyCode : Function;
	private var id : int;
	//private var incoming : Boolean = false;
	
	// assignKeyCode's signature:
	// function assignKeyCode( keyCode : uint, id : int ) : void
	public function KeyField( rootStage : Stage, assignKeyCode : Function, id : int )
	{
		super();
		border = false;
		this.rootStage = rootStage;
		this.assignKeyCode = assignKeyCode;
		this.id = id;
	}
	
	public function activate() : void
	{
		//trace("Button "+id+" activating.");
		rootStage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		rootStage.addEventListener(KeyboardEvent.KEY_UP,  onKeyUp);
	}
	
	public function deactivate() : void
	{
		rootStage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		rootStage.removeEventListener(KeyboardEvent.KEY_UP,  onKeyUp);
	}
	
	public function wantFocus() : Boolean
	{
		return tabEnabled;
	}
	
	public function onFocusIn() : void
	{
		//trace("KeyField.onFocusIn()");
		hasFocus = true;
		border = true;
		//incoming = true;
	}
	
	public function onFocusOut() : void
	{
		//trace("KeyField.onFocusOut()");
		hasFocus = false;
		border = false;
		//incoming = false;
	}
	
	public function onKeyDown( e : KeyboardEvent ) : void
	{
		if ( hasFocus )
			text = "";
	}
	
	public function onKeyUp( e : KeyboardEvent ) : void
	{
		//trace("KeyField.onKeyUp");
		
		// We have no business caring unless the player is looking at us.
		if ( !hasFocus )
			return;
		
		//trace("It has focus.");
		
		// Any key presses that give us focus will also trigger this onKeyUp.
		// That's bad though, since it means this field immediately assigns
		//   the key that sent focus here and leaves.
		// So onFocusIn gives us a heads up with 'incoming'.
		// That way we can ignore keyboard-based focus shifting and the key
		//   assignment from previous fields.
		/*if ( incoming )
		{
			//trace("Whoops, incoming.");
			incoming = false;
			return;
		}*/
		
		//trace("Actual key assignment.");
		
		if ( e == null )
			return;
		
		// This bit actually does key assignment, and only gets executed when
		//   the onKeyUp is NOT fired from a focus entrance event.
		this.keyCode = e.keyCode;
		assigned = true;
		assignKeyCode( keyCode, id );
	}
}


/* private */ class Conflict
{
	public var keyCode : uint;
	
	public var player1 : int;
	public var player2 : int;

	public var keyId1 : int;
	public var keyId2 : int;

	public function Conflict()
	{
	}
}