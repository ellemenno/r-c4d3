
package preloader.keyconfig
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
	
	import com.pixeldroid.r_c4d3.interfaces.IJoystick;
	import com.pixeldroid.r_c4d3.controls.KeyboardGameControlsProxy;
	import com.pixeldroid.r_c4d3.controls.KeyLabels;
	
	import preloader.keyconfig.Button;
	import preloader.keyconfig.FullFrameSprite;
	
	
	public class SelectKeysMenu extends FullFrameSprite
	{
		public var header : String = "Please select this character's controls.";
		public function getHeader() : String { return header; }
		
		// Types of (digital) controls.
		private const BUTTON : int = -1;
		private const HAT : int = -2;
		
		private const nPlayers : int = 4;
		private const nKeysPerPlayer : int = 8;
		
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
		
		/*private var conflicts : Array;
		*/
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
			
			if ( controlsProxy == null )
				throw "controlsProxy is null!";
			
			this.controlsProxy = controlsProxy;
			this.changeHeader = changeHeader;
			
			controlDefaults = clone(controlsProxy);
			controlsBackup = new KeyboardGameControlsProxy();
			
			var i : int;
			
			selections = new Array();
			descriptions = new Array();
			conflictMsgs = new Array();
			
			for ( i = 0; i < nKeysPerPlayer; i++ )
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
			debugTxt.y = 50;
			debugTxt.width = 500;
			debugTxt.height = 100;
			debugTxt.text = "shared object = ";
			debugTxt.setTextFormat(debugFmt);
			//addChild(debugTxt);
			
			
			// All keys must be loaded so that conflict detection will work
			//   correctly before the players have attempted to configure
			//   things.
			for ( i = 0; i < nPlayers; i++ )
				loadKeyConfigData(i);

			/*
			usedKeyCodes = new Array();

			for ( i = 0; i < nPlayers; i++ )
			{
				usedKeyCodes[i] = new Array();

				var j : int;
				for ( j = 0; j < nKeysPerPlayer; j++ )
					usedKeyCodes[i][j] = getLatestKeyCode(i,j);
			}*/

			/*
			conflicts = new Array();
			conflicts[nPlayers * nKeysPerPlayer - 1] = new Array();
			*/
			
			onResize();
		}
		
		private function clone(source:KeyboardGameControlsProxy):KeyboardGameControlsProxy
		{
			var result : KeyboardGameControlsProxy = new KeyboardGameControlsProxy();
			var i : int;
			for ( i = 0; i < nPlayers; i++ )
			{
				copyControls(source,result,i);
			}
			return result;
		}

		private function invalidateText() : void
		{
			var i : int;
			var format : TextFormat;
			
			format = new TextFormat();
			format.font = "Times New Roman";
			format.align = TextFormatAlign.RIGHT;
			format.bold = true;
			
			format.color = 0xffffff;
			format.size = 18;
			
			for ( i = 0; i < nKeysPerPlayer; i++ )
				descriptions[i].setTextFormat(format);
			
			format.align = TextFormatAlign.LEFT;
			format.size = 22;
			
			for ( i = 0; i < nKeysPerPlayer; i++ )
			{
				selections[i].setTextFormat(format);
				selections[i].defaultTextFormat = format;
			}
			
			//format = new TextFormat();
			format.font = "Courier New";
			format.align = TextFormatAlign.CENTER;
			format.bold = true;
			format.color = 0xff0000;
			format.size = 14;
			
			for ( i = 0; i < nKeysPerPlayer; i++ )
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
			for ( i = 0; i < nKeysPerPlayer; i++ )
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
			for ( i = 0; i < nKeysPerPlayer; i++ )
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
			for ( var i : int = 0; i < nKeysPerPlayer; i++ )
			{
				var tf : TextField;
				_y = fractionalY(70 + 50*i, 600);
				
				tf = descriptions[i];
				tf.x = fractionalX(10, 800);
				tf.y = _y;
				tf.width = fractionalX(360, 800);
				tf.height = fractionalY(40, 600);
				
				tf = selections[i];
				tf.x = fractionalX(400, 800);
				tf.y = _y;
				tf.width = fractionalX(380, 800);
				tf.height = fractionalY(40, 600);
				
				tf = conflictMsgs[i];
				tf.x = fractionalX(10, 800);
				tf.y = _y + fractionalY(30,800);
				tf.width = fractionalX(780, 800);
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
			copyControls(controlDefaults, controlsProxy, currentPlayer);
			invalidateKeyConfigData(currentPlayer);
		}
		
		public final function setPlayer( playerIndex : int ) : void
		{
			currentPlayer = playerIndex;
			
			header = "Please select the controls for player "+(playerIndex+1)+".";
			if ( changeHeader != null )
				changeHeader(header);

			copyControls(controlsProxy,controlsBackup,currentPlayer);
			
			invalidateKeyConfigData(currentPlayer);
		}
		
		private function invalidateKeyConfigData( playerIndex : int ) : void
		{
			loadKeyConfigData(playerIndex);
			checkConflicts();
			//invalidateText(); //handled by checkConflicts().
		}
		
		private function loadKeyConfigData( playerIndex : int ) : void
		{
			var k : int;
			for ( k = 0; k < nKeysPerPlayer; k++ )
				_assignKeyCode(getKeyCode(k, playerIndex, false), playerIndex, k);
		}
		
		// Checks all of the currently assigned keys for conflicts, updating
		//   conflict messages as necessary.
		private function checkConflicts() : void
		{
			var k : int;
			
			for ( k = 0; k < nKeysPerPlayer; k++ )
			{
				var keyCode : uint = getKeyCode(k, currentPlayer, true);
				var conflict : Conflict = checkConflict(keyCode, currentPlayer, k);
				
				// These must get cleared or the text will persist into config
				//   screens for other players.
				conflictMsgs[k].text = "";
				
				if ( conflict == null )
					continue;
				
				if ( currentPlayer == conflict.player )
				{
					conflictMsgs[k].text =
						"Conflict with "+descriptions[conflict.keyId].text;
				}
				else
				{
					conflictMsgs[k].text = 
						"Conflict with player "+(conflict.player+1)+"'s "+
						"key for "+descriptions[conflict.keyId].text;
				}
			}
			
			invalidateText();
		}

		// Returns null if there is no conflict.
		private function checkConflict( keyCode : uint, player : int, keyId : int ) : Conflict
		{
			var p : int;
			var k : int;
			
			for ( p = 0; p < nPlayers; p++ )
			{
				for ( k = 0; k < nKeysPerPlayer; k++ )
				{
					// Of course a key will conflict with itself.
					// But we don't care about that.
					if ( player == p && keyId == k )
						continue;
					
					// Now we check for the meaningful conflicts.
					var otherCode : uint = getKeyCode(k,p,true);
					if ( otherCode == keyCode )
					{
						var conflict : Conflict = new Conflict();
						conflict.player = p;
						conflict.keyId = k;
						return conflict;
					}
				}
			}
			
			return null;
		}

		/*
		private function isConflictNoted(  ) : Boolean
		{
		}
		*/
		
		// Only call this when the user is assigning a key.
		// Conflict checking is done for valid assignments.
		private function assignKeyCode( keyCode : uint, keyId : int ) : void
		{
			//trace("assignKeyCode");
			if ( !fromButtons ) // Discard tab events bringing focus to the control fields.
			{
				_assignKeyCode( keyCode, currentPlayer, keyId );
				checkConflicts();
			}
		}
		
		// This may be called by the machine to assign a key (ex: for defaults).
		// No conflict checking is done.
		private function _assignKeyCode( keyCode : uint, playerIndex: int, keyId : int ) : void
		{
			//trace("_assignKeyCode");
			if ( keyId >= nKeysPerPlayer )
				throw "keyId >= "+nKeysPerPlayer+", but there are only "+nKeysPerPlayer+" valid keys.";


			/*
			TODO:
			if (keyId < 4) controlsProxy.setHatKey(playerIndex, keyId, keyCode);
			else           controlsProxy.setButtonKey(playerIndex, keyId-4, keyCode);
			*/
			
			// This is a bit silly, but it should work.
			var args : Array = new Array();
			var i : int;
			for ( i = 0; i < nKeysPerPlayer; i++ )
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
				
			// update the text that the player sees
			selections[keyId].text = getKeyLabel(keyId, playerIndex, true);
			invalidateText();

			// update state on the user's harddrive.
			var data : Object = getLocalKeyData( keyId, playerIndex );
			if ( data != null )
				data.keyCode = keyCode;
		}
		
		/*
		private function getLatestKeyLabel( playerIndex : int, keyId : int ) : String
		{
			return humanReadable( getLatestKeyCode(playerIndex, keyId) );
		}
		
		private function getLatestKeyCode( playerIndex : int, keyId : int ) : uint
		{
			if ( selections[keyId].assigned )
				return selections[keyId].keyCode;
			
			return getKeyCode(keyId,playerIndex,true);
		}*/
		
		/*
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
		*/
		
		private function keyIdToSubId( keyId : int ) : int
		{
			var kgcp : Class = KeyboardGameControlsProxy;
			var subId : int = -1;
			
			switch ( keyId )
			{
				case 0: subId = kgcp.HAT_U; break;
				case 1: subId = kgcp.HAT_D; break;
				case 2: subId = kgcp.HAT_L; break;
				case 3: subId = kgcp.HAT_R; break;
				case 4: subId = kgcp.BTN_X; break;
				case 5: subId = kgcp.BTN_A; break;
				case 6: subId = kgcp.BTN_B; break;
				case 7: subId = kgcp.BTN_C; break;
				default: throw "Invalid keyId: "+keyId+". "+
					"It must be between 0 and "+(nKeysPerPlayer-1)+" inclusive.";
			}
			
			return subId;
		}
		
		// Returns either BUTTON or HAT.
		private function keyIdToControlType( keyId : int ) : int
		{
			var controlType : int;
			
			switch ( keyId )
			{
				case 0: controlType = HAT; break;
				case 1: controlType = HAT; break;
				case 2: controlType = HAT; break;
				case 3: controlType = HAT; break;
				case 4: controlType = BUTTON; break;
				case 5: controlType = BUTTON; break;
				case 6: controlType = BUTTON; break;
				case 7: controlType = BUTTON; break;
				default: throw "Invalid keyId: "+keyId+". "+
					"It must be between 0 and "+(nKeysPerPlayer-1)+" inclusive.";
			}
			
			return controlType;
		}

		// Don't call this.  Call getKeyCode with fromMem=true instead.
		private function getKeyCodeFromMem( keyId : int, playerIndex : int ) : uint
		{
			var kgcp : Class = KeyboardGameControlsProxy;
			var subId : int = keyIdToSubId(keyId);
			var controlType : int = keyIdToControlType(keyId);
			
			var stick : IJoystick = controlsProxy.joystickOpen(playerIndex);
			var result : uint;
			
			switch ( controlType )
			{
				case HAT:
					result = controlsProxy.joystickGetHatKey(stick,subId);
					break;
				
				case BUTTON:
					result = controlsProxy.joystickGetButtonKey(stick,subId);
					break;
			}
			
			return result;
		}
		
		// Grab the current saved key code given by dirId and playerIndex.
		// 
		// If fromMem is true, then the value will be retreived from random
		//   access memory using the controlsProxy object.
		// The upside is that this is fast.
		// The downside is that this may be out of sync if the values haven't
		//   already been loaded from the hard drive.
		// 
		// If fromMem is false, This will first try to retreive the value stored on the hard drive
		//   (or similar non-volatile storage device).
		// If there is no value on the hard drive, it will use the value loaded
		//   into random access memory (in controlsProxy) as a default.
		private function getKeyCode( keyId : int, playerIndex : int, fromMem : Boolean ) : uint
		{
			// Check this first before hitting the slow harddrive.
			if ( fromMem )
				return getKeyCodeFromMem(keyId,playerIndex);
			
			// Attempt to gather the value from the harddrive.
			var data : Object = getLocalKeyData(keyId,playerIndex);
			
			if ( data == null || data.keyCode == undefined )
			{
				return getKeyCodeFromMem(keyId,playerIndex);
			}
			else
			{
				return data.keyCode;
			}
		}
		
		/*
		private function getDirKeyCode( dirId : int, playerIndex : int, fromMem : Boolean ) : uint
		{
			var data : Object = getLocalDirKeyData(dirId,playerIndex);
			
			if ( data == null || data.keyCode == undefined )
			{
				return getDirKeyCodeFromMem(dirId,playerIndex);
			}
			else
			{
				return data.keyCode;
			}
		}
		
		private function getBtnKeyCode( buttonId : int, playerIndex : int ) : uint
		{
			var data : Object = getLocalBtnKeyData(buttonId,playerIndex);

			if ( data == null || data.keyCode == undefined )
			{
				var stick : IJoystick = controlsProxy.joystickOpen(playerIndex);
				return controlsProxy.joystickGetButtonKey(stick,buttonId);
			}
			else
			{
				return data.keyCode;
			}
		}
		*/
		
		// Same as getKeyCode, but returns a human readable description of what
		//   the key code represents instead of the key code itself.
		private function getKeyLabel( keyId : int, playerIndex : int, fromMem : Boolean = true ) : String
		{
			return humanReadable(getKeyCode(keyId,playerIndex,fromMem));
		}
		
		/*
		private function getDirKeyLabel( dirId : int, playerIndex : int ) : String
		{
			return humanReadable(getDirKeyCode(dirId, playerIndex));
		}
		
		private function getBtnKeyLabel( buttonId : int, playerIndex : int ) : String
		{
			return humanReadable(getBtnKeyCode(buttonId, playerIndex));
		}
		*/
		
		private function humanReadable( keyCode : uint ) : String
		{
			var label : String = KeyLabels.getLabel(keyCode);
			
			// TODO: Comparison against hardcoded string is a bit dubious.
			if ( label == "unknown key" )
				label = "KeyCode = " + String(keyCode);
			
			return label;
		}
		
		/*
		// Grabs the "data" from a SharedObject representing the directional
		//   control given by dirId and playerIndex.
		private function getLocalDirKeyData( dirId : int, playerIndex : int ) : Object
		{
			return getLocalKeyData("Dir", dirId, playerIndex);
		}
		
		// Grabs the "data" from a SharedObject representing the button
		//   control given by buttonId and playerIndex.
		private function getLocalBtnKeyData( buttonId : int, playerIndex : int ) : Object
		{
			return getLocalKeyData("Btn", buttonId, playerIndex);
		}
		
		// This is the guts for getLocalDirKeyData and getLocalBtnKeyData.
		// It is supposed to be called from those functions only.
		*/
		
		// Grabs the "data" from a SharedObject representing the button
		//   control given by buttonId and playerIndex.
		private function getLocalKeyData( keyId : int, playerIndex : int ) : Object
		{
			var result : Object = null;
			var BtnOrDir : String = null;
			var subId : int = keyIdToSubId(keyId);
			var controlType : int = keyIdToControlType(keyId);
			
			if ( controlType == BUTTON )
				BtnOrDir = "Btn";
			else if ( controlType == HAT )
				BtnOrDir = "Hat";
			
			try
			{
				var local : SharedObject = SharedObject.getLocal(
					"GameControls"+BtnOrDir+"Key"+subId+"x"+playerIndex);
				result = local.data;
			}
			catch (e:*) {}
			
			return result;
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
			
			for ( i = 0; i < nKeysPerPlayer; i++ )
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
			for ( i = 0; i < nKeysPerPlayer; i++ )
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

import preloader.keyconfig.ICanFocus;
	
/*private*/ class KeyField extends TextField implements ICanFocus
{
	public var hasFocus : Boolean = false;
	public var assigned : Boolean = false;
	//public var keyCode : uint;
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
		//this.keyCode = e.keyCode;
		assigned = true;
		assignKeyCode( e.keyCode, id );
	}
}


/* private */ class Conflict
{
	public var player : int;
	public var keyId : int;

	public function Conflict()
	{
	}
}