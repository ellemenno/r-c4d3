
package 
{

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import com.pixeldroid.r_c4d3.Version;
	import com.pixeldroid.r_c4d3.interfaces.HaxeSideDoor;
	import com.pixeldroid.r_c4d3.interfaces.IDisposable;
	import com.pixeldroid.r_c4d3.interfaces.IGameRom;
	import com.pixeldroid.r_c4d3.interfaces.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.tools.contextmenu.ContextMenuUtil;
	
	import ConfigDataProxy;
	import preloader.IPreloader;
	import preloader.NullPreloader;

	
	
	/**
	Base rom loader implementation.
	
	<p>
	Loads a valid IGameRom SWF and provides access to an IGameConfigProxy, 
	IGameControlsProxy, and an IGameScoresProxy.
	</p>
	
	<p>
	Subclasses can overide the protected proxy creation methods to supply various implementations:
	@see #createConfigProxy
	@see #createControlsProxy
	@see #createScoresProxy
	</p>
	
	<p>
	Configuration values are defined in a companion xml file that must 
	live in the same folder as the 	DesktopRomLoaderForKeyboard SWF and be
	named <code>romloader-config.xml</code> (subclasses can override the 
	configFile getter to expect a different position or get the url from 
	flashVars). See ConfigDataProxy for the xml format expected.
	@see ConfigDataProxy
	</p>
	
	<p>Note: <i>
	Due to the way HaXe inserts top-level classes when compiling a SWF,
	HaXe users must use the HaxeSideDoor to declare IGameRom compliance.
	</i></p>
	
	@see com.pixeldroid.interfaces.IGameConfigProxy
	@see com.pixeldroid.interfaces.IGameControlsProxy
	@see com.pixeldroid.interfaces.IGameScoresProxy
	@see ConfigDataProxy
	@see HaxeSideDoor
	*/
	public class RomLoader extends Sprite
	{
		protected var romLoader:Loader;
		protected var xmlLoader:URLLoader;
		
		protected var configProxy:IGameConfigProxy;
		protected var controlsProxy:IGameControlsProxy;
		protected var highScoresProxy:IGameScoresProxy;
		protected var splashScreen:IPreloader;
		
		protected var swfBytesLoaded:int;
		protected var swfBytesTotal:int;
		protected var swfLoaded:Boolean;
		protected var xmlBytesLoaded:int;
		protected var xmlBytesTotal:int;
		protected var xmlLoaded:Boolean;
		protected var splashDone:Boolean;
		
		protected const semver:String = SEMVER::v; //command line: -define+=SEMVER::v,"'major.minor.patch'"

		
		/**
		Constructor.
		*/
		public function RomLoader()
		{
			super();
			addVersionInfo();
			
			romLoader = Loader(addChild(new Loader()));
			romLoader.visible = false;
			xmlLoader = new URLLoader();

			swfLoaded = false;
			xmlLoaded = false;

			addChildren();
			_addListeners();
			openPreloader();
		}
		
		/** @private */
		protected function addChildren():void
		{
			splashScreen = IPreloader( addChild(createPreloader() as Sprite) );
			splashScreen.initialize();
		}

		/** @private */
		protected function openPreloader():void
		{
			splashScreen.open(); // needs to dispatch Event.OPEN to trigger onPreloaderOpened
		}

		/** @private */
		protected function onPreloadProgress(e:ProgressEvent):void
		{
			splashScreen.progress = e;
		}

		/** @private */
		protected function closePreloader():void
		{
			splashScreen.shutDown();
		}




		/*
			Triggered as xml bytes are loaded.

			Calls updateProgress().
		*/
		/** @private */
		protected function onXmlProgress(e:ProgressEvent):void
		{
			xmlBytesLoaded = e.bytesLoaded;
			xmlBytesTotal = e.bytesTotal;
			updateProgress();
		}

		/*
			Triggered when all xml bytes are loaded.

			Initiates load of swf; calls for creation of controls and scores proxies,
			applies config data to them, and hands them to the splashScreen for possible use.
		*/
		/** @private */
		protected function onXmlComplete(e:Event):void
		{
			xmlLoaded = true;
			//C.out(this, "onXmlComplete", true);
			configProxy = createConfigProxy(xmlLoader.data);
			
			controlsProxy = createControlsProxy(configProxy);
			if (!controlsProxy) throw new Error("Couldn't load controls proxy."); // TODO: what a vague error!
					
			highScoresProxy = createScoresProxy(configProxy);
			if (!highScoresProxy) throw new Error("Couldn't load scores proxy."); // TODO: what a vague error!

			splashScreen.onConfigData(configProxy, controlsProxy, highScoresProxy);
			
			loadSwf();
		}

		/*
			Triggered as swf bytes are loaded.

			Calls updateProgress().
		*/
		/** @private */
		protected function onSwfProgress(e:ProgressEvent):void
		{
			swfBytesLoaded = e.bytesLoaded;
			swfBytesTotal = e.bytesTotal;
			updateProgress();
		}

		/*
			Triggered when all swf bytes are loaded.

			Preloader is responsible for noticing when load progress reaches 100% 
			and dispatchig the Event.CLOSE to trigger onPreloaderClosed.
		*/
		/** @private */
		protected function onSwfComplete(e:Event):void
		{
			swfLoaded = true;
			C.out(this, "onSwfComplete");
			if (splashDone) finalizeLoad(configProxy, controlsProxy, highScoresProxy);
		}

		
		
		/*
			Event handler responding to	the completion of the splashScreen opening animation.
			
			Signifies the splashScreen is ready to receive progress updates.

			Calls loadXml()
		*/
		/** @private */
		protected function onPreloaderOpened(e:Event):void
		{
			loadXml();
		}

		/*
			Event handler responding to	the completion of the splashScreen closing animation.
			
			Signifies the splashScreen is done displaying and the user may progress on to the game.

			Calls finalizeLoad()
		*/
		/** @private */
		protected function onPreloaderClosed(e:Event):void
		{
			splashDone = true;
			//C.out(this, "onPreloaderClosed", true);
			if (swfLoaded) finalizeLoad(configProxy, controlsProxy, highScoresProxy);
		}



		/*
			Triggered by onPreloaderOpened.
		*/
		/** @private */
		protected function loadXml():void
		{
			xmlLoader.load(new URLRequest(configUrl));
		}

		/*
			Triggered by onXmlComplete.
		*/
		/** @private */
		protected function loadSwf():void
		{
			try { romLoader.load(new URLRequest(configProxy.romUrl)); }
			catch(e:Error) { C.out(this, "Error - rom could not be loaded: " +e); }
		}

		/*
			Triggered by onSwfProgress and onXmlProgress.

			Creates a new ProgressEvent that totals the swf and xml bytes loaded and bytes total.
			Calls onPreloadProgress() with new ProgressEvent.

			@see ProgressEvent
		*/
		/** @private */
		protected function updateProgress():void
		{
			var e:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			e.bytesLoaded = swfBytesLoaded + xmlBytesLoaded;
			e.bytesTotal = swfBytesTotal + xmlBytesTotal;
			onPreloadProgress(e);
		}

		/*
			Casts the loaded content into a game rom instance.
			Looks for Haxe games through the side door.
		*/
		/** @private */
		protected function extractGameRom(romLoaderContent:DisplayObject):IGameRom
		{
			var gameRom:IGameRom;
			
			if (romLoaderContent is IGameRom) gameRom = IGameRom(romLoaderContent);
			else if (getQualifiedClassName(romLoaderContent) == "flash::Boot")
			{
				if (HaxeSideDoor.romInstance && HaxeSideDoor.romInstance is IGameRom) gameRom = IGameRom(HaxeSideDoor.romInstance);
			}
			else trace("extractGameRom() - Error: content is not a valid rom (" +getQualifiedClassName(extractGameRom) +")");
			
			return gameRom;
		}


		
		// candidates for override

		/**
		 * @inheritDoc
		 */
		protected function addListeners():void
		{
			// to be overridden
			// base implementation does nothing.
		}

		/**
		 * @inheritDoc
		 */
		protected function removeListeners():void
		{
			// to be overridden
			// base implementation does nothing.
		}

		/**
			Triggered when an IOError occurs.

			Writes the IOErrorEvent.toString() to the tracelog.
		*/
		protected function onIoError(e:IOErrorEvent):void
		{
			trace("IO Error: " +e);
			closePreloader();
		}

		/**
			Triggered when an SecurityError occurs.

			Writes the SecurityErrorEvent.toString() to the tracelog.
		*/
		protected function onSecurityError(e:SecurityErrorEvent):void
		{
			trace("Security Error: " +e);
			closePreloader();
		}
		
		/**
			Retrieves the url of the rom loader config file.
		*/
		protected function get configUrl():String
		{
			return "romloader-config.xml";
		}
		
		/**
			Provides the IPreloader instance to display during load.
			Broken out for easy override.
		*/
		protected function createPreloader():IPreloader
		{
			return new NullPreloader();
		}
		
		/**
			Provides the game configuration proxy instance.
			Broken out for easy override.
			
			<p>
			This base implementation provides a ConfigDataProxy instance.
			</p>
			
			@see ConfigDataProxy
		*/
		protected function createConfigProxy(configData:String):IGameConfigProxy
		{
			return new ConfigDataProxy(xmlLoader.data);
		}
		
		/**
			Provides the game controls proxy instance.
			Broken out for easy override.
		*/
		protected function createControlsProxy(configProxy:IGameConfigProxy):IGameControlsProxy
		{
			// to be overridden
			// base implementation does nothing.
			return null;
		}

		/**
			Provides the game scores proxy instance.
			Broken out for easy override.
		*/
		protected function createScoresProxy(configProxy:IGameConfigProxy):IGameScoresProxy
		{
			// to be overridden
			// base implementation does nothing.
			return null;
		}

		/**
			Adds version and copyright info to context menu
		*/
		protected function addVersionInfo():void
		{
			ContextMenuUtil.addItem(this, productVersion);
			ContextMenuUtil.addItem(this, copyLeft);
			ContextMenuUtil.addItem(this, frameworkVersion);
		}
		
		/**
			Returns the application version string
		*/
		protected function get productVersion():String
		{
			return "R-C4D3 Rom Loader v" +semver;
		}
		
		private function get copyLeft():String
		{
			return "CopyLeft "+Version.year +" Pixeldroid";
		}
		
		private function get frameworkVersion():String
		{
			return "(framework v" +Version.semver +")";
		}
		

		
		/** @private */
		protected function finalizeLoad(configProxy:IGameConfigProxy, controlsProxy:IGameControlsProxy, highScoresProxy:IGameScoresProxy):void
		{
			C.out(this, "finalizeLoad");
			_removeListeners();
			
			if (romLoader.content)
			{
				closePreloader();
				removeChild(Sprite(splashScreen));
				
				var gameRom:IGameRom = extractGameRom(romLoader.content);
				if (gameRom)
				{
					C.out(this, "finalizeLoad() - valid game rom found, sending over config proxy, controls proxy and scores proxy")
					
					gameRom.setConfigProxy(configProxy);
					gameRom.setControlsProxy(controlsProxy);
					gameRom.setScoresProxy(highScoresProxy);
					
					romLoader.visible = true; // reveal container
					
					C.out(this, "finalizeLoad() - game should be ready, calling enterAttractLoop()")
					gameRom.enterAttractLoop();
				}
			}
			else C.out(this, "finalizeLoad() - Error: content unable to be loaded");
		}
		
		/** @private */
		protected function _addListeners():void
		{
			romLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onSwfProgress);
			romLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfComplete);
			romLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, onXmlProgress);
			xmlLoader.addEventListener(Event.COMPLETE, onXmlComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			Sprite(splashScreen).addEventListener(Event.OPEN, onPreloaderOpened);
			Sprite(splashScreen).addEventListener(Event.CLOSE, onPreloaderClosed);
			
			addListeners(); // let subclasses do their own
		}

		/** @private */
		protected function _removeListeners():void
		{
			romLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onSwfProgress);
			romLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSwfComplete);
			romLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, onXmlProgress);
			xmlLoader.removeEventListener(Event.COMPLETE, onXmlComplete);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			Sprite(splashScreen).removeEventListener(Event.OPEN, onPreloaderOpened);
			Sprite(splashScreen).removeEventListener(Event.CLOSE, onPreloaderClosed);
			
			removeListeners(); // ask subclasses to clean up their listeners
		}
		
	}
}
