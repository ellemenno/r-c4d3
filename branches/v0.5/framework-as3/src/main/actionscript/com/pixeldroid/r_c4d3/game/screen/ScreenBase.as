

package com.pixeldroid.r_c4d3.game.screen
{
	
	import com.pixeldroid.r_c4d3.api.IControllable;
	import com.pixeldroid.r_c4d3.api.IDisposable;
	import com.pixeldroid.r_c4d3.api.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.api.events.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.api.events.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.screen.IScreen;
	import com.pixeldroid.r_c4d3.game.screen.IUpdatable;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	
	
	/**
	Base screen implementation, suitable for use with IGameScreenFactory.
	
	@see com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory
	*/
	public class ScreenBase extends Sprite implements IScreen, IUpdatable, IControllable, IDisposable
	{
		/** Screen type. Used by the game screen factory */
		protected var _type:ScreenTypeEnumerator;
		
		/** Runtime configuration loaded from the romloader-config.xml */
		protected var gameConfigProxy:IGameConfigProxy;
		
		/** Accumulated time elapsed since screen initialization */
		protected var timeElapsed:int;
		
		/**
		Frame rate prior to custom initialization. Will be restored during shutdown, 
		freeing this screen to set its own rate temporarily.
		*/
		protected var previousFrameRate:Number;
		
		
		
		/** Constructor. */
		public function ScreenBase():void
		{
			super();
		}
		
		
		// helper functions
		
		/** 
		Clears and fills the screen (to stage dimensions) with the provided color. 
		@param value An rgb color integer
		*/
		protected function set backgroundColor(value:uint):void
		{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			graphics.clear();
			graphics.beginFill(value);
			graphics.drawRect(0,0, w,h);
			graphics.endFill();
		}
		
		/**
		Clears any drawn graphics and asks child instances of ScreenBase to shutDown.
		*/
		protected function clear():void
		{
			graphics.clear();
			var d:DisplayObject;
			while (numChildren > 0)
			{
				d = removeChildAt(0);
				if (d is ScreenBase) (d as ScreenBase).shutDown();
			}
		}
		
		
		// extension / customization api
		
		/**
		Extension point for custom decommission of the screen. 
		Designed to be overridden by subclasses. 
		
		@return true for success, false if an error has occurred
		*/
		protected function customShutDown():Boolean
		{
			// to be overridden
			C.out(this, "(base) customShutDown()");
			return true;
		}
		
		/**
		Extension point for custom initialization of the screen. 
		Designed to be overridden by subclasses. 
		
		@return true for success, false if an error has occurred
		*/
		protected function customInitialization():Boolean
		{
			// to be overridden
			C.out(this, "(base) customInitialization()");
			return true;
		}
		
		/**
		Extension point for rendering first on-screen view. 
		Designed to be overridden by subclasses. 
		
		<p>
		Further updates will be prompted via <code>onUpdateRequest</code>
		</p>
		*/
		protected function handleFirstScreen():void
		{
			// to be overridden
			C.out(this, "(base) handleFirstScreen()");
		}
		
		/**
		Extension point for handling joystick direction (hat) events. 
		Designed to be overridden by subclasses. 
		
		@param e JoyHatEvent instance
		*/
		protected function handleHatMotion(e:JoyHatEvent):void
		{
			// to be overridden
			C.out(this, "(base) handleHatMotion(): " +e);
		}
		
		/**
		Extension point for handling joystick button events. 
		Designed to be overridden by subclasses. 
		
		@param e JoyButtonEvent instance
		*/
		protected function handleButtonMotion(e:JoyButtonEvent):void
		{
			// to be overridden
			C.out(this, "(base) handleButtonMotion(): " +e);
		}
		
		/**
		Extension point for handling update requests. 
		Designed to be overridden by subclasses. 
		
		<p>
		<i>Note:</i> Total time elapsed since initialization is stored in the <code>timeElapsed</code> property
		</p>
		
		@param dt Milliseconds elapsed since last update occurred
		*/
		protected function handleUpdateRequest(dt:int):void
		{
			// to be overridden
		}
		
		/**
		Extension point for accessing game configuration. 
		Designed to be overridden by subclasses. 
		
		<p>
		<i>Note:</i> When this function is called, the <code>gameConfigProxy</code> property has been set
		</p>
		*/
		protected function handleGameConfig():void
		{
			// to be overridden
			C.out(this, "(base) handleGameConfig() - config is ready");
		}
		
		
		
		// IScreen interface
		/** @inheritDoc */
		public function set type(value:ScreenTypeEnumerator):void
		{
			C.out(this, "(base) set type() - " +value);
			_type = value;
		}
		
		/** @inheritDoc */
		public function get type():ScreenTypeEnumerator
		{
			return _type;
		}
		
		
		// IDisposable interface
		/** @inheritDoc */
		public function shutDown():Boolean
		{
			var isReady:Boolean = customShutDown();
			
			clear();
			stage.frameRate = previousFrameRate;
			
			var t:String;
			
			if (timeElapsed < 1000) t = timeElapsed +"ms";
			else
			{
				var s:int = Math.floor(timeElapsed*.001);
				var m:int = (s >= 60) ? Math.floor(s/60) : 0;
				t = (m > 0) ? m +"m " +(s - m*60) +"s" : s +"s";
			}
			
			C.out(this, "(base) shutDown() - returning to " +previousFrameRate +"fps; lifetime was " +t);
			
			return isReady;
		}
		
		/** @inheritDoc */
		public function initialize():Boolean
		{
			C.out(this, "(base) initialize()");
			
			timeElapsed = 0;
			previousFrameRate = stage.frameRate;
			Notifier.send(Signals.GET_CONFIG, onConfigReady);
			
			var isReady:Boolean = customInitialization();
			handleFirstScreen();
			
			return isReady;
		}
		
		
		// IControllable interface
		/** @inheritDoc */
		public function onHatMotion(e:JoyHatEvent):void
		{
			handleHatMotion(e);
		}
		
		/** @inheritDoc */
		public function onButtonMotion(e:JoyButtonEvent):void
		{
			handleButtonMotion(e);
		}
		
		
		// IUpdatable interface
		/** @inheritDoc */
		public function onUpdateRequest(dt:int):void
		{
			timeElapsed += dt;
			handleUpdateRequest(dt);
		}
		
		// callback to receive config proxy requested via notification in initialize
		protected function onConfigReady(value:IGameConfigProxy):void
		{
			gameConfigProxy = value;
			handleGameConfig();
		}

		
	}
}
