
package com.pixeldroid.r_c4d3.romloader 
{
	import com.pixeldroid.r_c4d3.api.IGameConfigProxy;

	/**
		ConfigDataProxy is a simple data structure front end to the romloader 
		xml configuration.
		
		@example Sample <code>romloader-config.xml</code>:
		<listing version="3.0">
		&lt;configuration&gt;
			&lt;!-- trace logging on when true --&gt;
			&lt;logging enabled="true" /&gt;

			&lt;!-- performance stats on when true --&gt;
			&lt;stats enabled="true" /&gt;

			&lt;!-- rom to load, and its game id for scores storage --&gt;
			&lt;rom file="../controls/ControlTestGameRom.swf" id="com_pixeldroid_controltest" /&gt;

			&lt;!-- key mappings, player numbers start at 1 --&gt;
			&lt;keymappings&gt;
				&lt;joystick playerNumber="1"&gt;
					&lt;hatRight keyCode="39" /&gt;
					&lt;hatUp    keyCode="38" /&gt;
					&lt;hatLeft  keyCode="37" /&gt;
					&lt;hatDown  keyCode="40" /&gt;
					&lt;buttonX  keyCode="17" /&gt;
					&lt;buttonA  keyCode="46" /&gt;
					&lt;buttonB  keyCode="35" /&gt;
					&lt;buttonC  keyCode="34" /&gt;
				&lt;/joystick&gt;
			&lt;/keymappings&gt;
			
			&lt;!-- arbitrary property values --&gt;
			&lt;property name="fullScreen"&gt;true&lt;/property&gt;&lt;!-- for DesktopRomLoader --&gt;
			&lt;property name="scoreServer"&gt;http://scores.foo.com&lt;/property&gt;&lt;!-- for RC4D3RomLoader --&gt;
			&lt;property name="foo"&gt;foo value&lt;/property&gt;
			&lt;property name="bar"&gt;bar value&lt;/property&gt;
			&lt;property name="bat"&gt;bat value&lt;/property&gt;

		&lt;/configuration&gt;
		</listing>
		
		@see com.pixeldroid.r_c4d3.interfaces.IGameRom#setConfigProxy
	*/
	public class ConfigDataProxy implements IGameConfigProxy
	{

		protected var xmlData:XML;
		protected var _xmlString:String;
		protected var _loggingEnabled:Boolean;
		protected var _statsEnabled:Boolean;
		protected var _romUrl:String;
		protected var _gameId:String;



		/**
			Constructor
		*/
		public function ConfigDataProxy(sourceXml:String)
		{
			xmlString = sourceXml;
			xmlData = new XML(xmlString);
		}
		
		
		// IGameConfigProxy interface
		
		/** @inheritDoc */
		public function get loggingEnabled():Boolean
		{
			if (!_loggingEnabled) _loggingEnabled = Boolean(xmlData..logging.@enabled.toString());
			return _loggingEnabled;
		}
		
		/** @inheritDoc */
		public function get statsEnabled():Boolean
		{
			if (!_statsEnabled) _statsEnabled = Boolean(xmlData..stats.@enabled.toString());
			return _statsEnabled;
		}
		
		/** @inheritDoc */
		public function get romUrl():String
		{
			if (!_romUrl) _romUrl = xmlData..rom.@file.toString();
			return _romUrl;
		}
		
		/** @inheritDoc */
		public function get gameId():String
		{
			if (!_gameId) _gameId = xmlData..rom.@id.toString();
			return _gameId;
		}

		/** @inheritDoc */ public function get p1HasKeys():Boolean { return (playerKeyMapping(1).length() > 0); }
		/** @inheritDoc */ public function get p1U():uint { return parseInt(playerKeyMapping(1).hatUp.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p1R():uint { return parseInt(playerKeyMapping(1).hatRight.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p1D():uint { return parseInt(playerKeyMapping(1).hatDown.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p1L():uint { return parseInt(playerKeyMapping(1).hatLeft.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p1X():uint { return parseInt(playerKeyMapping(1).buttonX.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p1A():uint { return parseInt(playerKeyMapping(1).buttonA.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p1B():uint { return parseInt(playerKeyMapping(1).buttonB.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p1C():uint { return parseInt(playerKeyMapping(1).buttonC.@keyCode.toString()) as uint; }

		/** @inheritDoc */ public function get p2HasKeys():Boolean { return (playerKeyMapping(2).length() > 0); }
		/** @inheritDoc */ public function get p2U():uint { return parseInt(playerKeyMapping(2).hatUp.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p2R():uint { return parseInt(playerKeyMapping(2).hatRight.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p2D():uint { return parseInt(playerKeyMapping(2).hatDown.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p2L():uint { return parseInt(playerKeyMapping(2).hatLeft.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p2X():uint { return parseInt(playerKeyMapping(2).buttonX.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p2A():uint { return parseInt(playerKeyMapping(2).buttonA.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p2B():uint { return parseInt(playerKeyMapping(2).buttonB.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p2C():uint { return parseInt(playerKeyMapping(2).buttonC.@keyCode.toString()) as uint; }

		/** @inheritDoc */ public function get p3HasKeys():Boolean { return (playerKeyMapping(3).length() > 0); }
		/** @inheritDoc */ public function get p3U():uint { return parseInt(playerKeyMapping(3).hatUp.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p3R():uint { return parseInt(playerKeyMapping(3).hatRight.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p3D():uint { return parseInt(playerKeyMapping(3).hatDown.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p3L():uint { return parseInt(playerKeyMapping(3).hatLeft.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p3X():uint { return parseInt(playerKeyMapping(3).buttonX.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p3A():uint { return parseInt(playerKeyMapping(3).buttonA.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p3B():uint { return parseInt(playerKeyMapping(3).buttonB.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p3C():uint { return parseInt(playerKeyMapping(3).buttonC.@keyCode.toString()) as uint; }

		/** @inheritDoc */ public function get p4HasKeys():Boolean { return (playerKeyMapping(4).length() > 0); }
		/** @inheritDoc */ public function get p4U():uint { return parseInt(playerKeyMapping(4).hatUp.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p4R():uint { return parseInt(playerKeyMapping(4).hatRight.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p4D():uint { return parseInt(playerKeyMapping(4).hatDown.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p4L():uint { return parseInt(playerKeyMapping(4).hatLeft.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p4X():uint { return parseInt(playerKeyMapping(4).buttonX.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p4A():uint { return parseInt(playerKeyMapping(4).buttonA.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p4B():uint { return parseInt(playerKeyMapping(4).buttonB.@keyCode.toString()) as uint; }
		/** @inheritDoc */ public function get p4C():uint { return parseInt(playerKeyMapping(4).buttonC.@keyCode.toString()) as uint; }
		
		/** @inheritDoc */
		public function getPropertyValue(propertyName:String):String
		{
			return xmlData..properties.property.(attribute("name") == propertyName).toString();
		}

		/** @inheritDoc */
		public function set xmlString(value:String):void { _xmlString = value; }
		public function get xmlString():String { return _xmlString; }

		/**
			String print of current data
		*/
		public function toString():String
		{
			var s:String = "";
			s += "\n  loggingEnabled ? " +loggingEnabled;
			s += "\n  statsEnabled ? " +statsEnabled;
			s += "\n  romUrl: " +romUrl;
			s += "\n  gameId: " +gameId;
			s += "\n  xmlString:  - - - - - - -\n\n";
			s += xmlString;
			s += "\n- - - - - - - - - - - - - -\n\n";
			return s;
		}
		
		
		protected function playerKeyMapping(i:int):XMLList
		{
			return xmlData..keymappings.joystick.(@playerNumber==i);
		}
	}
}
