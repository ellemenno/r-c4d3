
package com.pixeldroid.r_c4d3.tools.contextmenu
{
    import flash.display.InteractiveObject;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    
    /**
    Provides utility methods for manipulating the context menu
    */
    final public class ContextMenuUtil
    {
    	/**
    	Adds a context menu item and returns a reference to it, e.g. for adding event listeners.
    	
    	@param owner The InteractiveObject instance whose context menu should be altered
    	@param label The menu item label
    	@param hideBuiltIn Whether to hide the suppressable built-in items. Not all built-in items can be hidden.
    	*/
    	static public function addItem(owner:InteractiveObject, label:String, hideBuiltIn:Boolean=true):ContextMenuItem
    	{
			var cm:ContextMenu = owner.contextMenu || (new ContextMenu());
			var cmi:ContextMenuItem = new ContextMenuItem(label);
			
			cm.customItems.push(cmi);
			if (hideBuiltIn) cm.hideBuiltInItems();
			 
			owner.contextMenu = cm;
			return cmi;
    	}
    }
}
