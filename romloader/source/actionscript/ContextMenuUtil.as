
package
{
	import flash.display.InteractiveObject;
	import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    
    final public class ContextMenuUtil
    {
    	static public function addItem(owner:InteractiveObject, label:String, hideBuiltIn:Boolean=true):void
    	{
			var cm:ContextMenu = owner.contextMenu || (new ContextMenu());
			var cmi:ContextMenuItem = new ContextMenuItem(label);
			
			cm.customItems.push(cmi);
			if (hideBuiltIn) cm.hideBuiltInItems();
			 
			owner.contextMenu = cm;
    	}
    }
}
