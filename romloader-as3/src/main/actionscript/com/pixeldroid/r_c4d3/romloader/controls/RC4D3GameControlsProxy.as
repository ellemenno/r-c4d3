
package com.pixeldroid.r_c4d3.romloader.controls
{

	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	import com.pixeldroid.r_c4d3.romloader.PathConstants;
	
	/**
	An implementation of IGameControlsProxy for the R_C4D3 system.
	
	<p>
	Maps keyboard events to JoyHat and JoyButton events.
	</p>
	
	<p>
	Keys initialize to the default R_C4D3 values, but can be customized via 
	<code>setKeys()</code> and queried via <code>joystickGetHatKey()</code> and 
	<code>joystickGetButtonKey()</code>
	</p>
	
	<p>
	Uses hard-coded path from PathConstants to return to menu
	</p>
	
	@see com.pixeldroid.r_c4d3.controls.PathConstants
	*/
	public class RC4D3GameControlsProxy extends KeyboardGameControlsProxy
	{
		private const BTN_M:int = Keyboard.F12;
		
		
		
		/**
		Constructor
		*/
		public function RC4D3GameControlsProxy()
		{
			super();
		}
		
		
		override protected function setDefaultCodes():void
		{                                         //     r u l d x a b c
			setKeys(0, 49,50,51,52,53,54,55,56);  // p1: 1 2 3 4 5 6 7 8
			setKeys(1, 81,87,69,82,84,89,85,73);  // p2: q w e r t y u i
			setKeys(2, 65,83,68,70,71,72,74,75);  // p3: a s d f g h j k
			setKeys(3, 90,88,67,86,66,78,77,188); // p4: z x c v b n m ,
		}

		
		override protected function onKeyDown(e:KeyboardEvent):void
		{
			var kc:uint = e.keyCode;
			//C.out(this, "onKeyDown - " +kc);
		
			if (kc == BTN_M)
			{
				try { navigateToURL(new URLRequest(PathConstants.RETURN_TO_MENU), "_top"); }
				catch (e:Error) { /*C.out(this, "navigation error: " +e, true);*/ }
			}
			
			else super.onKeyDown(e);
		}

	}
}
