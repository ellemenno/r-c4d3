
package 
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import keyconfig.KeyConfigGui;
	
	import com.pixeldroid.r_c4d3.interfaces.HaxeSideDoor;
	import com.pixeldroid.r_c4d3.interfaces.IGameRom;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
	
	import ConfigDataProxy;

	
	
	/**
	Base rom loader implementation.
	
	<p>
	Loads a valid IGameRom SWF and provides access to an IGameControlsProxy
	and an IGameScoresProxy. 
	</p>
	Configuration values are defined in a companion xml file that must 
	live in the same folder as the 	DesktopRomLoaderForKeyboard SWF and be
	named <code>romloader-config.xml</code> (subclasses can override the 
	configFile getter to e.g. get url from flashVars). See ConfigDataProxy for 
	the xml format expected.
	</p>
	
	<p>Note: <i>
	Due to the way HaXe inserts top-level classes when compiling a SWF,
	HaXe users must use the HaxeSideDoor to declare IGameRom compliance.
	</i></p>
	
	@see com.pixeldroid.interfaces.IGameControlsProxy
	@see com.pixeldroid.interfaces.IGameScoresProxy
	@see ConfigDataProxy
	@see HaxeSideDoor
	*/
	public class RomLoader extends Sprite
	{
		protected var romLoader:Loader;
		protected var xmlLoader:URLLoader;
		protected var splashScreen : KeyConfigGui;
		protected var configData:ConfigDataProxy;
		protected var controlsProxy:IGameControlsProxy;
		protected var highScoresProxy:IGameScoresProxy;
		
		protected var preloaderContainer:Sprite;
		protected var swfBytesLoaded:int;
		protected var swfBytesTotal:int;
		protected var swfLoaded:Boolean;
		protected var xmlBytesLoaded:int;
		protected var xmlBytesTotal:int;
		protected var xmlLoaded:Boolean;
		protected var splashDone:Boolean;



		/**
		Constructor.
		*/
		public function RomLoader()
		{
			super();
			
			romLoader = Loader(addChild(new Loader()));
			romLoader.visible = false;
			xmlLoader = new URLLoader();

			preloaderContainer = Sprite(addChild(new Sprite()));
			swfLoaded = false;
			xmlLoaded = false;

			addChildren(preloaderContainer);
			_addListeners();
			openPreloader();
		}

		
		protected function addChildren(container:DisplayObjectContainer):void
		{
			// to be overridden
			// base implementation creates a thin rectangle across the screen
			var progressBar:Shape = Shape(container.addChild(new Shape()));
			progressBar.x = 0;
			progressBar.y = stage.stageHeight * .5 - 2;

			var progressBarOutline:Shape = Shape(container.addChild(new Shape()));
			progressBarOutline.x = 0;
			progressBarOutline.y = progressBar.y;
			var g:Graphics = progressBarOutline.graphics;
			g.lineStyle(1, 0x222222);
			g.drawRect(0, 0, stage.stageWidth-1, 4);
		}

		protected function openPreloader():void
		{
			// to be overridden
			onPreloaderOpened(null);
		}

		protected function onPreloadProgress(e:ProgressEvent):void
		{
			// to be overridden
			// base implementation draws a thin rectangle across the screen
			
			var progressBar:Shape = Shape(preloaderContainer.getChildAt(0));
			var progressBarOutline:Shape = Shape(preloaderContainer.getChildAt(1));
			
			// When the xml is done loading, the key config gui will spawn.
			// This check will avoid trying to draw a progress bar under or
			//   over the key config gui, which is now responsible for
			//   informating the player(s) of loading progress.
			if ( xmlLoaded && !splashDone )
			{
				progressBar.graphics.clear();
				progressBarOutline.graphics.clear();
				return;
			}
			
			var progress:Number = (e.bytesTotal > 0) ? (e.bytesLoaded / e.bytesTotal) : 0;
			var w:int = Math.round(progress * stage.stageWidth);
			var g:Graphics;

			progressBar.x = 0;
			progressBar.y = stage.stageHeight * .5 - 2;

			g = progressBar.graphics;
			g.clear();
			g.beginFill(0x444444, .6);
			g.drawRect(0, 0, w, 4);
			g.endFill();

			progressBarOutline.x = 0;
			progressBarOutline.y = progressBar.y;

			g = progressBarOutline.graphics;
			g.clear();
			g.lineStyle(1, 0x222222);
			g.drawRect(0, 0, stage.stageWidth-1, 4);
		}

		protected function closePreloader(errorOccured:Boolean=false):void
		{
			// to be overridden
			if (errorOccured == false) onPreloaderClosed(null);
		}




		/*
			Triggered as swf bytes are loaded.

			Calls updateProgress().
		*/
		protected function onSwfProgress(e:ProgressEvent):void
		{
			swfBytesLoaded = e.bytesLoaded;
			swfBytesTotal = e.bytesTotal;
			updateProgress();
		}

		/*
			Triggered when all swf bytes are loaded.

			Calls closePreloader() if all xml bytes are also loaded and the
			splash screen is done.
		*/
		protected function onSwfComplete(e:Event):void
		{
			swfLoaded = true;
			
			if ( splashDone )
				closePreloader();
		}

		/*
			Triggered when the splash screen is done (ex: players are done 
			customizing the game settings).
			
			Calls closePreloader() if all xml bytes and swf bytes are also
			loaded.
		*/
		protected function onSplashComplete() : void
		{
			splashDone = true;

			removeChild(splashScreen);
			splashScreen.finalize();
			
			if ( swfLoaded )
				closePreloader();
		}

		/*
			Triggered as xml bytes are loaded.

			Calls updateProgress().
		*/
		protected function onXmlProgress(e:ProgressEvent):void
		{
			xmlBytesLoaded = e.bytesLoaded;
			xmlBytesTotal = e.bytesTotal;
			updateProgress();
		}

		/*
			Triggered when all xml bytes are loaded.

			Initiates load of swf.
		*/
		protected function onXmlComplete(e:Event):void
		{
			xmlLoaded = true;
			configData = new ConfigDataProxy(xmlLoader.data);

			loadSwf();
			
			// This must be done before the splash screen is loaded.
			controlsProxy = createControlsProxy();
			if (controlsProxy) applyControlsConfig(controlsProxy, configData);
			else throw "Couldn't load controls proxy."; // TODO: what a vague error!
			
			splashScreen = createSplashScreen();
			if ( splashScreen != null )
			{
				splashScreen.onConfigComplete = onSplashComplete;
				addChild(splashScreen);
				splashScreen.activate();
			}
			else
			{
				splashDone = true;
			}
		}

		/*
			Triggered when an IOError occurs.

			Writes the IOErrorEvent.toString() to the tracelog.
		*/
		protected function onIoError(e:IOErrorEvent):void
		{
			trace("IO Error: " +e);
			closePreloader();
		}

		/*
			Triggered when an SecurityError occurs.

			Writes the SecurityErrorEvent.toString() to the tracelog.
		*/
		protected function onSecurityError(e:SecurityErrorEvent):void
		{
			trace("Security Error: " +e);
			closePreloader();
		}

		/*
			Event hook to add as listener to an event marking
			the completion of the preloader opening animation.

			Calls initiateLoad()

			This base implementation calls onPreloaderOpened() from openPreloader()

			@see initiateLoad
		*/
		protected function onPreloaderOpened(e:Event):void
		{
			loadXml();
		}

		/*
			Event hook to add as listener to an event marking
			the completion of the preloader closing animation.

			Calls finalizeLoad()

			This base implementation calls onPreloaderClosed() from closePreloader()
		*/
		protected function onPreloaderClosed(e:Event):void
		{
			finalizeLoad();
		}

		/*
			Triggered by onPreloaderOpened.
		*/
		protected function loadXml():void
		{
			xmlLoader.load(new URLRequest(configUrl));
		}

		/*
			Triggered by onXmlComplete.
		*/
		protected function loadSwf():void
		{
			try { romLoader.load(new URLRequest(configData.romUrl)); }
			catch(e:Error) { C.out(this, "Error - rom could not be loaded: " +e); }
		}
		

		/*
			Triggered by onSwfProgress and onXmlProgress.

			Creates a new ProgressEvent that totals the swf and xml bytes loaded and bytes total.
			Calls onPreloadProgress() with new ProgressEvent.

			@see ProgressEvent
		*/
		protected function updateProgress():void
		{
			var e:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			e.bytesLoaded = swfBytesLoaded + xmlBytesLoaded;
			e.bytesTotal = swfBytesTotal + xmlBytesTotal;
			onPreloadProgress(e);
		}


		/*
			Retrieves the url of the rom loader config file.
		*/
		protected function get configUrl():String
		{
			return "romloader-config.xml";
		}

		
		/*
			Casts the loaded content into a game rom instance.
			Looks for Haxe games through the side door.
		*/
		protected function extractGameRom(romLoadeContent:DisplayObject):IGameRom
		{
			var gameRom:IGameRom;
			
			if (romLoadeContent is IGameRom) gameRom = IGameRom(romLoadeContent);
			else if (getQualifiedClassName(romLoadeContent) == "flash::Boot")
			{
				if (HaxeSideDoor.romInstance && HaxeSideDoor.romInstance is IGameRom) gameRom = IGameRom(HaxeSideDoor.romInstance);
			}
			else trace("extractGameRom() - Error: content is not a valid rom (" +getQualifiedClassName(extractGameRom) +")");
			
			return gameRom;
		}

		
		/*
			Provides the game controls proxy instance.
			Broken out for easy override.
		*/
		protected function createSplashScreen():KeyConfigGui
		{
			// to be overridden
			// base implementation does nothing.
			return null;
		}
		
		/*
			Provides the game controls proxy instance.
			Broken out for easy override.
		*/
		protected function createControlsProxy():IGameControlsProxy
		{
			// to be overridden
			// base implementation does nothing.
			return null;
		}
		
		/*
			Applies loaded configuration to controls proxy.
			Broken out for easy override.
		*/
		protected function applyControlsConfig(c:IGameControlsProxy, d:ConfigDataProxy):void
		{
			// to be overridden
			// base implementation does nothing.
		}

		
		/*
			Provides the game scores proxy instance.
			Broken out for easy override.
		*/
		protected function createScoresProxy():IGameScoresProxy
		{
			// to be overridden
			// base implementation does nothing.
			return null;
		}

		
		/*
			Applies loaded configuration to scores proxy.
			Broken out for easy override.
		*/
		protected function applyScoresConfig(s:IGameScoresProxy, d:ConfigDataProxy):void
		{
			// to be overridden
			// base implementation does nothing.
		}
		
		
		/*
			Triggered by onPreloaderClosed.
		*/
		protected function finalizeLoad():void
		{
			C.out(this, "finalizeLoad");
			_removeListeners();
			removeChild(preloaderContainer);
			
			if (romLoader.content)
			{
				var gameRom:IGameRom = extractGameRom(romLoader.content);
				if (gameRom)
				{
					C.out(this, "finalizeLoad() - valid game rom found, sending over controls proxy and scores proxy")
					
					// provide access to game controls and high scores
					highScoresProxy = createScoresProxy();
					if (highScoresProxy) applyScoresConfig(highScoresProxy, configData);
					
					romLoader.visible = true; // reveal container
					
					gameRom.setControlsProxy(controlsProxy);
					gameRom.setScoresProxy(highScoresProxy);
					
					C.out(this, "finalizeLoad() - game should be ready, calling enterAttractLoop()")
					gameRom.enterAttractLoop();
				}
			}
			else C.out(this, "finalizeLoad() - Error: content unable to be loaded");
		}

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
		
		
		
		protected function _addListeners():void
		{
			romLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onSwfProgress);
			romLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfComplete);
			romLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, onXmlProgress);
			xmlLoader.addEventListener(Event.COMPLETE, onXmlComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			addListeners(); // let subclasses do their own
		}

		protected function _removeListeners():void
		{
			romLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onSwfProgress);
			romLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSwfComplete);
			romLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, onXmlProgress);
			xmlLoader.removeEventListener(Event.COMPLETE, onXmlComplete);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			removeListeners(); // ask subclasses to clean up their listeners
		}
	}
}
