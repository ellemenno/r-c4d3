package keyconfig
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import keyconfig.ICanFocus;
	
	public class FullFrameSprite extends Sprite
	{
		// These should match the -default-size <width> <height> parameters
		//   passed to the compiler.  These effectively allow those parameters
		//   to be changed without changing the coordinates everywhere in the
		//   program.
		protected const frameWidth : int = 800;
		protected const frameHeight : int = 600;
		
		private var active : Boolean = false;
		
		// The child that is the current focus.
		// This is null if there is no focus or the focus is the child of
		//   a different sprite.
		/*
		private var _focus : ICanFocus = null;
		public function get focus() : ICanFocus { return _focus; }
		
		public function set focus( val : ICanFocus ) : void
		{
			_focus = val;
			//rootStage.focus = _focus;
		}
		*/
		//private var _focus : InteractiveObject = null;
		private var focusHandle : Array; /* pointer to a InteractiveObject */
		public function get focus() : InteractiveObject { return focusHandle[0]; }
		public function set focus( val : InteractiveObject ) : void
		{
			/*
			if ( val != focus )
			{
				var canFocus : ICanFocus;
				
				canFocus = focus as ICanFocus;
				if ( canFocus != null && canFocus.wantFocus() )
					canFocus.onFocusOut();
			
				
				canFocus = val as ICanFocus;
				if ( val != null && canFocus.wantFocus() )
				{
					focusHandle[0] = val;
					canFocus.onFocusIn();
				}
				else
					focusHandle[0] = null;
			}*/
			focusHandle[0] = val;
			//rootStage.focus = _focus;
		}
		
		// Does this sprite have focus in the parent's view?
		//private var _hasFocus : Boolean = false;
		//public function get hasFocus() : Boolean { return _hasFocus; }
		
		// rootStage is readonly.
		private var _rootStage : Stage;
		public final function get rootStage() : Stage { return _rootStage; }
		
		// rootStage must be a stage that will receive input events (keyboard and mouse).
		public function FullFrameSprite(rootStage : Stage)
		{
			focusHandle = new Array();
			focusRect = false;
			_rootStage = rootStage;
			

			// Since these don't affect global operation, they don't need
			//   to be under the jurisdiction of activate/deactivate.

			addEventListener(Event.ADDED, onAdded);
			addEventListener(Event.REMOVED, onRemoved);
		}
		
		// This is the 'destructor' in a sense.
		// Call this to free up all non-memory resources that this object owns.
		public function finalize() : void
		{
			deactivate();
			
			
			removeEventListener(Event.ADDED, onAdded);
			removeEventListener(Event.REMOVED, onRemoved);
		}
		
		// Allow this to receive events from the stage.
		// Calling this repeatedly will have no additional effect.
		public final function activate() : void
		{
			if ( active )
				return;
			
			active = true;
			
			addEventListener(FocusEvent.FOCUS_IN,  onFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			addEventListener(FocusEvent.KEY_FOCUS_CHANGE, _onFocusChange);
			addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onMouseFocusChange);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			if ( rootStage )
			{
				//rootStage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				rootStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				rootStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				onActivate();
			}
			else
				trace("Failed to activate key config GUI due to null root stage.");
		}
		
		// Forbid this to receive events from the stage.
		// Calling this repeatedly will have no additional effect.
		public final function deactivate() : void
		{
			if ( !active )
				return;
			
			active = false;
			
			removeEventListener(FocusEvent.FOCUS_IN,  onFocusIn);
			removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, _onFocusChange);
			removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onMouseFocusChange);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			if ( rootStage )
			{
				//rootStage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				rootStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				rootStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				onDeactivate();
			}
			else
				trace("Failed to DEactivate key config GUI due to null root stage.");
		}
		
		// Called when activated.
		// Override this to add your event listeners.
		protected function onActivate() : void
		{
			trace("onActivate.focus = "+focus);
			if( attemptFocusOut(focus) )
				focus = null;
			//trace("FullFrameSprite.onActivate()");
		}
		
		// Called when deactived.
		// Override this to remove your event listeners.
		protected function onDeactivate() : void
		{
			//trace("FullFrameSprite.onDeactivate()");
		}
		
		private function onFocusIn( e : FocusEvent ) : void
		{
			trace("onFocusIn.focus = "+focus);
			e.preventDefault();
			
			var buttonTest : Button = e.target as Button;
			if ( e.target == this || buttonTest != null )
				getNextFocus();
			//trace("FullFrameSprite.onFocusIn("+e.toString()+"|"+e.target.toString()+")");
			//_hasFocus = true;
			//rootStage.focus = this;
			//e.stopPropagation();
		}
		
		private function onFocusOut( e : FocusEvent ) : void
		{
			e.preventDefault();
			//trace("FullFrameSprite.onFocusOut");
			//_hasFocus = false;
			//e.stopPropagation();
		}
		
		// Used to prevent duplicate calls to onFocusChange.
		private var focusLock : Boolean = false;
		
		private function _onFocusChange( e : FocusEvent ) : void
		{
			//trace("FullFrameSprite.onFocusChange");
			if ( e != null )
			{
				e.preventDefault();
				
				//if ( !containsObject(e.target) )
				//	return;
			}
			
			// Focus events from ancestors and/or children will be duplicates.
			// This filters them out.
			if ( focusLock )
				return;
			
			//trace("FullFrameSprite.onFocusChange2()");
			
			focusLock = true;
			//if ( hasFocus )
			
				//e.stopPropagation();
			//else
			//	_focus = null;
			
			onFocusChange(e);
			
			focusLock = false;
		}
		
		// overridable version.  neglect to call super at your own peril.
		protected function onFocusChange( e : FocusEvent ) : void
		{
			//trace("FullFrameSprite.onFocusChange()");
			//trace("Call FullFrameSprite.getNextFocus()");
			getNextFocus();
			//trace("/Call FullFrameSprite.getNextFocus()");
		}
		
		// Flash 9 doesn't provide a shallow version of the "contains" function,
		//   so here is one that does it.
		public final function hasChild( child : DisplayObject ) : Boolean
		{
			var i : int;
			for ( i = 0; i < numChildren; i++ )
				if ( child == getChildAt(i) )
					return true;
			return false;
		}
		
		public function getNextFocus( dir : int = 1 ) : void
		{
			_getNextFocus(dir);
		}
		
		public final function _getNextFocus( dir : int = 1 ) : void
		{
			trace("_getNextFocus.focus = "+focus);
			//trace("getNextFocus()");
			
			var i : int;
			var j : int;
			
			// The first step is to check for subsprites.  These should handle
			//   the focus mechanics instead of us.  So if one of them is 
			//   present, the proper thing to do is just give up.
			for ( i = 0; i < numChildren; i++ )
			{
				var subSprite : FullFrameSprite = getChildAt(i) as FullFrameSprite;
				if ( subSprite != null )
					return;
			}
			
			////trace("hasFocus = "+hasFocus);
			
			var success : Boolean = false;
			//var oldFocus : ICanFocus = focus;
			if ( focus == null || !hasChild(focus) )
				j = numChildren;
			else
				j = getChildIndex(focus);
			
			//trace("numChildren = "+numChildren);
			//trace("Starting at j = "+j);

			for ( i = 0; i < numChildren; i++ )
			{
				if ( dir > 0 )
				{
					j++;
					if ( j >= numChildren )
						j = 0;
				}
				else if ( dir < 0 )
				{
					j--;
					if ( j < 0 )
						j = numChildren - 1;
				}
				else
					break;
				
				//trace("j = "+j);
				var child : DisplayObject = getChildAt(j);
				
				/*
				var subSprite : FullFrameSprite = child as FullFrameSprite;
				if ( subSprite != null )
				{
					//subSprite._onFocusChange(null);
					break;
				}*/
				
				/*
				var tabbable : InteractiveObject = child as InteractiveObject;
				if ( tabbable != null && tabbable.tabEnabled )
				{
					//trace("172");
					if ( oldFocus )
						oldFocus.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT,false));
					
					//trace("175");
					focus = tabbable;
					//trace("177");
					tabbable.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN,false));
					tabbable.dispatchEvent(new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE,false));
					//trace("179");
					break;
				}*/
				
				success = attemptNewFocus(child,focus);
				if( success )
					break;
			}
			
			if ( !success )
				focus = null;
			
			//trace("/getNextFocus()");
		}
		
		public final function getPrevFocus() : void
		{
			getNextFocus(-1);
		}
		
		public final function attemptNewFocus( child : DisplayObject, oldFocus : InteractiveObject ) : Boolean
		{
			//trace("attemptNewFocus()");
			if ( child == null )
				return false;
			
			var interactive : InteractiveObject = child as InteractiveObject;
			
			var success : Boolean = false;
			var tabbable : ICanFocus = child as ICanFocus;
			if ( tabbable != null && tabbable.wantFocus() 
				&& interactive != null )
			{
				/*
				//trace("New focus is tabbable.");
				if ( oldFocus != null )
				{
					//trace("Old focus exists.");
					var old : ICanFocus = oldFocus as ICanFocus;
					if ( old != null && old.wantFocus() )
					{
						//trace("Old focus is ICanFocus");
						old.onFocusOut();
					}
				}*/
				attemptFocusOut(oldFocus);
				
				tabbable.onFocusIn();
				focus = interactive;
				success = true;
			}
			
			//trace("/attemptNewFocus()");
			return success;
		}
		
		private function attemptFocusOut( widget : Object ) : Boolean
		{
			if ( widget == null )
				return false;
			
			var canFocus : ICanFocus = widget as ICanFocus;
			if ( canFocus != null && canFocus == focus )
			{
				canFocus.onFocusOut();
				return true;
			}
			return false;
		}
		
		private function onRemoved( e : Event ) : void
		{
			////trace("onRemoved()");
			
			// Check to see if the child being removed is a FullFrameSprite
			//   that shares a focus with us.
			// Since it will no longer be with us, we should give it its own
			//   focus.
			//trace("Removing "+e.target.toString());
			var subSprite : FullFrameSprite = e.target as FullFrameSprite;
			if ( subSprite )
			{
				//trace("splitting focus.");
				subSprite.focusHandle = new Array();
			}
			
			if ( e.target == this )
			{
				//trace("e.target = this");
				var i : int;
				for ( i = 0; i < numChildren; i++ )
				{
					attemptFocusOut(getChildAt(i));
					/*
					var canFocus : ICanFocus = getChildAt(i) as ICanFocus;
					if ( canFocus != null && canFocus == focus )
						canFocus.onFocusOut();
					*/
				}
			}
			/*
			if ( focus != null && containsObject(e.target) )
			{
				//trace("    onRemoved()");
				var tabbable : ICanFocus = focus as ICanFocus;
				if ( tabbable != null && tabbable.wantFocus() )
					tabbable.onFocusOut();
			}*/
			////trace("/onRemoved()");
				
			/*
			if ( focus != null )
			{
				focus.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT,false));
				focus = null;
			}
			*/
			
			//if ( rootStage.focus != null && contains(rootStage.focus) )
			//	rootStage.focus = null;
			
			//_hasFocus = false;
		}
		
		private function onAdded( e : Event ) : void
		{
			////trace("onAdded()");
			
			// merge any focus instances in children.
			// There should only be one focus ever.
			// Having more just makes things terribly confusing O.o
			//trace("Adding "+e.target.toString());
			var subSprite : FullFrameSprite = e.target as FullFrameSprite;
			if ( subSprite )
			{
				//trace("Merge focus.");
				subSprite.focusHandle = this.focusHandle;
			}
			
			/*
			if ( focus != null && containsObject(e.target) )
			{
				//trace("    onAdded()");
				var tabbable : ICanFocus = focus as ICanFocus;
				if ( tabbable != null && tabbable.wantFocus() )
					tabbable.onFocusIn();
			}*/
			////trace("/onAdded()");
			/*
			if ( focus != null )
			{
				focus.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT,false));
				focus = null;
			}*/
			
			/*
			if ( rootStage.focus != this )
				rootStage.focus = this;

			_hasFocus = true;
			*/
		}
		
		private function containsObject( foo : Object ) : Boolean
		{
			if ( foo == null )
				return false;
			
			var result : Boolean = false;
			var displayObj : DisplayObject = foo as DisplayObject;
			if ( displayObj != null && contains(displayObj) )
				result = true;
			return result;
		}
		
		// Called when a screen resize happens.
		public function onResize() : void
		{
		}
		
		private function isConfirmationKey( keyCode : int ) : Boolean
		{
			if ( keyCode == 13 || keyCode == 32 )
				return true;
			else
				return false;
		}
		
		private function onKeyDown( e : KeyboardEvent ) : void
		{
			//trace("FullFrameSprite.onKeyDown");
			// Press buttons when enter key is hit.
			if ( isConfirmationKey(e.keyCode) && focus != null )
			{
				//trace("sup.");
				var button : SimpleButton = focus as SimpleButton;
				if ( button != null )
				{
					/*
					var mevent : MouseEvent = new MouseEvent(
						MouseEvent.MOUSE_DOWN,
						true,  // bubbles (default)
						false, // cancelable (default)
						button.width / 2,  // localX
						button.height / 2, // localY
						button, // relatedObject
						false,false,false, // ctrl, alt, shift
						true // buttonDown = true
						);
					button.hitTestState.dispatchEvent(mevent);
					*/
					button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
				}
			}
		}
		
		private function onKeyUp( e : KeyboardEvent ) : void
		{
			//trace("FullFrameSprite.onKeyUp");
			// Click buttons when enter or space keys are hit.
			if ( isConfirmationKey(e.keyCode) && focus != null )
			{
				//trace("teehee");
				var button : SimpleButton = focus as SimpleButton;
				if ( button != null )
				{
					button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
					button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
			
			if ( e.keyCode == 38 ) // UP
			{
				getPrevFocus();
			}
			
			if ( e.keyCode == 40 ) // DOWN
			{
				getNextFocus();
			}
		}
		
		private function onMouseDown( e : MouseEvent ) : void
		{
			//trace("onMouseDown("+e.toString()+"|"+e.target.toString()+")");
			if ( e.target != focus )
			{
				//trace("mouse switching focus");
				// Store this for our attempt to find a new focus.
				//var oldFocus : InteractiveObject = focus;
				////trace("oldFocus1 = "+oldFocus);
				
				// We've already concluded that the focus will be changing.
				// Thus it's OK to temporarily assign it to null.
				// If there's nothing new to go to, it will stay null.
				attemptFocusOut(focus);
				focus = null;
				
				////trace("oldFocus2 = "+oldFocus);
				
				// Try to find a new focus.  Merely best effort.
				attemptNewFocus(e.target as DisplayObject, null);
			}
		}
		
		private function onMouseFocusChange( e : FocusEvent ) : void
		{
			//trace("FullFrameSprite.onMouseFocusChage("+e.target.toString()+")");
			//var oldFocus : InteractiveObject = focus;
			attemptFocusOut(focus);
			focus = null;
			attemptNewFocus(e.target as DisplayObject, null);
		}
		
		public final function fractionalX( numerator : Number, denominator : Number ) : Number
		{
			//return numerator * rootStage.stageWidth / denominator;
			return numerator * frameWidth / denominator;
		}
		
		public final function fractionalY( numerator : Number, denominator : Number ) : Number
		{
			//return numerator * rootStage.stageHeight / denominator;
			return numerator * frameHeight / denominator;
		}
	}
}