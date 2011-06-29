
package
{
	import com.pixeldroid.r_c4d3.api.IGameRom;
	import com.pixeldroid.r_c4d3.api.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.api.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.api.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.api.Version;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	This is a null pattern implementation of IGameRom.
	*/
	public class NullRom extends Sprite implements IGameRom
	{
		protected var textField:TextField;
		
		public function NullRom():void
		{
			super();
			addChildren();
			textField.htmlText  = '<p><b><font size="+10">NullRom</font></b><br><br>this is the null rom.</p>';
			textField.htmlText += '<p>waiting for romloader to call <font face="Courier">enterAttractLoop()</font></p>';
			textField.htmlText += '<br><br><p>' +apiInfo +'</p>';
		}
		
		/** @private */
		protected function addChildren():void
		{
			var format:TextFormat = new TextFormat();
			format.color = 0xffffff;
			format.font = "Arial";
			format.size = 20;
			format.align = TextFormatAlign.LEFT;
			
			textField = new TextField();
			textField.defaultTextFormat = format;
			textField.multiline = true;
			textField.selectable = true;
			textField.wordWrap = true;
			addChild(textField);
			
			textField.width = 800;
			textField.height = 600;
		}
		
		/** @private */
		protected function get apiInfo():String
		{
			return '<font size="-8"><i>' +Version.productInfo +'<br>' +Version.buildInfo +'</i></font>';
		}
		
		// IGameRom api
		/** @inheritDoc */
		public function enterAttractLoop():void
		{
			textField.htmlText  = '<br><br><br><br>';
			textField.htmlText += '<p align="center"><b><font size="+10">NullRom</font></b><br><br>load has completed successfully.</p>';
			textField.htmlText += '<br><br><p>' +apiInfo +'</p>';
		}
		
		/** @inheritDoc */
		public function setConfigProxy(value:IGameConfigProxy):void { }
		
		/** @inheritDoc */
		public function setControlsProxy(value:IGameControlsProxy):void { }
		
		/** @inheritDoc */
		public function setScoresProxy(value:IGameScoresProxy):void { }
	}
}