
package com.pixeldroid.r_c4d3.preloader.keyconfig
{

	public interface ICanFocus // No really, I can!  Honest!
	{
		// But do I want to focus?  Return false to receive no focus calls.
		function wantFocus() : Boolean;
		
		function onFocusIn() : void; // Called when focus shifts to this widget.
		function onFocusOut() : void; // Called when focus shifts away.
	}
}