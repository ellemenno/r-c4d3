
package com.pixeldroid.r_c4d3.romloader.data
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	import com.adobe.serialization.json.JSON;
	
	import com.pixeldroid.r_c4d3.api.events.DataEvent;
	import com.pixeldroid.r_c4d3.api.events.DataEvent;

	/**
	Dispatched when the data retreival process has completed.
	
	@eventType com.pixeldroid.r_c4d3.data.DataEvent.READY
	*/
	[Event(name="ready", type="com.pixeldroid.r_c4d3.api.events.DataEvent")]
	
	/**
	Dispatched when the data retreival process has failed.
	
	@eventType com.pixeldroid.r_c4d3.data.DataEvent.ERROR
	*/
	[Event(name="error", type="com.pixeldroid.r_c4d3.api.events.DataEvent")]

	

	/**
	Creates JSON formatted http requests, monitors the load progress of the response, 
	and dispatches events for response success and failure.
	
	Notes:
	<ul>
	<li>Requires <code>com.adobe.serialization.json.JSON</code></li>
	</ul>
	
	@see DataEvent
	@see http://code.google.com/p/as3corelib/
	*/
	public class JsonLoader extends EventDispatcher
	{
	
		protected var UL:URLLoader;
		
		protected var dataReady:DataEvent;
		protected var dataError:DataEvent;
		
		protected var _bytesLoaded:uint;
		protected var _bytesTotal:uint;
	
	
	
		/**
		Constructor.
		
		@param request An optional URLRequest to make immediately
		*/
		public function JsonLoader(request:URLRequest=null, eventsBubble:Boolean=false, eventsCancel:Boolean=false)
		{
			dataReady = new DataEvent(DataEvent.READY, eventsBubble, eventsCancel);
			dataError = new DataEvent(DataEvent.ERROR, eventsBubble, eventsCancel);
			
			UL = new URLLoader();
			UL.dataFormat = URLLoaderDataFormat.TEXT;
			configureListeners(UL);

			if (request != null) { load(request); }
		}
		
		/**
		Attempt to load the provided URLRequest
		
		@param request URLRequest to make
		*/
		public function load(request:URLRequest):void
		{
			try
			{
				_bytesLoaded = 0;
				_bytesTotal = 0;
				UL.load(request);
			}
			catch (error:Error)
			{
				dataError.message = "unable to load requested document";
				trace(dataError.message);
				dispatchEvent(dataError);
			}
		}
		
		/**
		Request the load progress percent.
		Results are (0 - 100).
		*/
		public function get percent():uint
		{
			var p:uint = (_bytesTotal > 0) ? Math.round(_bytesLoaded / _bytesTotal * 100) : 0;
			return p;
		}
		
		/**
		Request the number of bytes loaded.
		*/
		public function get bytesLoaded():uint { return _bytesLoaded; }
		
		/**
		Request the total number of bytes to load.
		*/
		public function get bytesTotal():uint { return _bytesTotal; }


		
		protected function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.OPEN, onOpen);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onProgress);
			dispatcher.addEventListener(Event.COMPLETE, onComplete);
			
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		}
		
		protected function onOpen(e:Event):void {}
		
		protected function onProgress(e:ProgressEvent):void
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
		}

		protected function onComplete(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			dataReady.data = com.adobe.serialization.json.JSON.decode(loader.data);
			dataReady.message = "json data load completed (" +_bytesTotal +")";
			dispatchEvent(dataReady);
		}
		
		protected function onHttpStatus(e:HTTPStatusEvent):void {}
		
		protected function onSecurityError(e:SecurityErrorEvent):void
		{
			dataError.message = e.text;
			dispatchEvent(dataError);
		}
		
		protected function onIoError(e:IOErrorEvent):void
		{
			dataError.message = e.text;
			dispatchEvent(dataError);
		}
		
    }
}
