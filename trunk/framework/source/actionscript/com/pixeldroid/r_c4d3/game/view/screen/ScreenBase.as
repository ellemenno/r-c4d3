

package com.pixeldroid.r_c4d3.game.view.screen
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.interfaces.IControllable;
	import com.pixeldroid.r_c4d3.interfaces.IDisposable;
	import com.pixeldroid.r_c4d3.interfaces.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.interfaces.ITypable;
	import com.pixeldroid.r_c4d3.interfaces.IUpdatable;
	
	
	
	/**
	Base screen implementation, suitable for use with IGameScreenFactory.
	
	@see com.pixeldroid.r_c4d3.interfaces.IGameScreenFactory
	*/
	public class ScreenBase extends Sprite implements ITypable, IDisposable, IControllable, IUpdatable
	{
		
		protected var _type:String;
		protected var configProxy:IGameConfigProxy;
		protected var timeElapsed:int;
		protected var previousFrameRate:Number;
		
		
		
		/** Constructor. */
		public function ScreenBase():void
		{
			C.out(this, "(base) constructor");
			super();
		}
		
		
		/** 
		Fills the screen (to stage dimensions) with the provided color. 
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
		
		/**
		Prompt to provide first on-screen view. 
		Designed to be overridden by subclasses. 
		
		<p>
		Updates will be prompted via <code>onUpdateRequest</code>
		</p>
		*/
		protected function onFirstScreen():void
		{
			// to be overridden
		}
		
		
		// ITypable interface
		/** @inheritDoc */
		public function set type(value:String):void
		{
			C.out(this, "(base) set type() - " +value);
			_type = value;
		}
		
		/** @inheritDoc */
		public function get type():String
		{
			return _type;
		}
		
		
		// IDisposable interface
		/** @inheritDoc */
		public function shutDown():Boolean
		{
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
			
			C.out(this, "(base) shutDown() - lifetime was " +t);
			
			return true;
		}
		
		/** @inheritDoc */
		public function initialize():Boolean
		{
			C.out(this, "(base) initialize()");
			timeElapsed = 0;
			previousFrameRate = stage.frameRate;
			Notifier.send(Signals.GET_CONFIG, receiveConfig);
			onFirstScreen();
			
			return true;
		}
		
		
		// IControllable interface
		/** @inheritDoc */
		public function onHatMotion(e:JoyHatEvent):void
		{
			C.out(this, "(base) onHatMotion: " +e);
		}
		
		/** @inheritDoc */
		public function onButtonMotion(e:JoyButtonEvent):void
		{
			C.out(this, "base onButtonMotion: " +e);
		}
		
		
		// IUpdatable interface
		/** @inheritDoc */
		public function onUpdateRequest(dt:int):void
		{
			timeElapsed += dt;
		}

		
		// callback to receive config proxy requested via notification in initialize
		protected function receiveConfig(value:IGameConfigProxy):void { configProxy = value; }
		
	}
}
