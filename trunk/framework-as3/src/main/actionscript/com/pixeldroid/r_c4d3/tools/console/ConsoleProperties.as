
package com.pixeldroid.r_c4d3.tools.console
{
	public class ConsoleProperties
	{
		/**
		Max number of recent lines to retain in the buffer.
		Oldest lines get purged when this limit is reached.
		*/
		public var bufferSize:int = 64;

		/**
		Width of console (pixels)
		*/
		public var width:Number = 780;
		
		/**
		Height of console (pixels)
		*/
		public var height:Number = 200;
		
		/**
		Background color
		*/
		public var backColor:uint = 0x000000;

		/**
		Text color
		*/
		public var foreColor:uint = 0xffffff;

		/**
		Background opacity.
		1 is completely opaque; 0 is completely transparent.
		*/
		public var backAlpha:Number = .8;
		
		/**
		Line height (pixels)
		*/
		public var fontSize:Number = 16;
		
		/**
		Font leading (pixels)
		*/
		public var leading:int = 2;
	}
}
