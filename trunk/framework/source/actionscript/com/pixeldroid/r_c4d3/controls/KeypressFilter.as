
package com.pixeldroid.r_c4d3.controls
{

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	
	/**
	Provides ability to filter key events before game controls proxy sees them.
	
	<p>
	On some versions of linux flash player, there is a bug that causes
	press-and-hold to be interpreted as many clicks.
	</p>
	
	<p>
	The pattern is release-press pairs being issued on the same frame; a sequence 
	unlikely to be performed by any mere mortal. So here we accumulate events 
	that occur in between frames, filter out duplicates, and pass on the uniques.
	</p>
	
	@see https://bugs.adobe.com/jira/browse/FP-2369
	*/
	public class KeypressFilter
	{
		/*
		Define an event queue that is populated with events as onKeyUp
		and onKeyDown are called.  When onEnterFrame is called, these
		will be acted upon and the queue cleared.
		This is well-ordered FIFO.
		*/
		protected var eventQueue:Array /* of KeyboardEvent */;
		
		/*
		The capacity of the queue may be larger than it's actual size.
		This gives it's actual size, not its capacity.
		*/
		protected var nEvents:int; 
		
		/*
		A list of keycodes that have been associated with a key release event
		during the latest frame.  
		*/
		protected var keysReleased:Array /* of int (key codes) */;
		
		/*
		As with the event queue, keysReleased may stay over-allocated.
		This gives it's actual size, not its capacity.
		*/
		protected var nKeysReleased:int;
		
		// callback references to send the filtered events to
		protected var keyDown:Function;
		protected var keyUp:Function;

		
		/**
		Constructor.
		
		*/
		public function KeypressFilter(keyDownCallback:Function, keyUpCallback:Function):void
		{
			keyDown = keyDownCallback;
			keyUp = keyUpCallback;
			
			keysReleased = [0]; // preallocate one element.
			nKeysReleased = 0;
			
			eventQueue = [null, null, null, null]; // preallocate a bit.
			nEvents = 0;
		}
		
		
		
		public function get onKeyDown():Function { return _onKeyDown; }
		public function get onKeyUp():Function { return _onKeyUp; }
		public function get onFrame():Function { return _onFrame; }
		
		
		
		protected function isBogusKeyEvent(keyCode:uint):Boolean
		{
			// Returns true if this event shouldn't be possible.
			for (var i:int = 0; i < nKeysReleased; i++) if (keyCode == keysReleased[i]) return true;
			return false;
		}
		
		protected function _onKeyDown(e:KeyboardEvent):void
		{
			if (isBogusKeyEvent(e.keyCode))
			{
				// Filter the release-press pairs typical of flash player's bug.
				var event:KeyboardEvent;
				for (var i:int = 0; i < nEvents; i++)
				{
					event = eventQueue[i] as KeyboardEvent;
					if (event != null && event.keyCode == e.keyCode)
					{
						// My tactic here is to simply set bogus events to null,
						//   and just ignore the nulls when in onEnterFrame.
						// This is very intentional.
						// What you don't want to do is remove them.
						// That has two problems:
						// -If you use the fast O(1) method for removal, then
						//   it will change the ordering of the queues elements.
						//   That's bad.
						// -The O(n) method involves sliding the queue 
						//   remainder towards the 0th element by 1.
						//   This violates any indices pointing into the queue.
						//   The current scheme doesn't have such indices, but
						//   if that changes it would be an ugly thing to 
						//   violate.
						eventQueue[i] = null;
					}
				}
			}
			else
			{
				eventQueue[nEvents] = e;
				nEvents++;
			}
		}
		
		protected function _onKeyUp(e:KeyboardEvent):void
		{
			eventQueue[nEvents++] = e;
			keysReleased[nKeysReleased++] = e.keyCode;
		}
		
		protected function _onFrame(e:Event):void
		{
			for (var i:int = 0; i < nEvents; i++)
			{
				var event:KeyboardEvent = eventQueue[i] as KeyboardEvent;
				if (event != null) // Some events were filtered out.
				{
					if (event.type == KeyboardEvent.KEY_DOWN) keyDown(event);
					else keyUp(event);
				}
			}
			
			// Flush the queues.
			nKeysReleased = 0;
			nEvents = 0;
		}
	}
}

