
package com.pixeldroid.r_c4d3.scores
{
 
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import com.adobe.serialization.json.JSON;

	import com.pixeldroid.r_c4d3.data.DataEvent;
	import com.pixeldroid.r_c4d3.data.JsonLoader;
	import com.pixeldroid.r_c4d3.scores.GameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;


	/**
	Extends the (abstract) GameScoresProxy base class to
	store high scores and initials on a remote server,
	using a web service that accepts the following parameters:
	<ul>
	<li><code>game</code> : <i>String</i> Unique game id</li>
	<li><code>format</code> : <i>String</i> "json" or "vrml"</li>
	<li><code>data</code> : <i>String</i> Score data--as json string--to store; omission or empty value for data triggers retrieval</li>
	</ul>
	
	and returns the following data:
	<ul>
	<li><code>type</code>: <i>String</i> "get" or "set"</li>
	<li><code>success</code> : <i>Boolean</i></li>
	<li><code>message</code> : <i>String</i></li>
	<li><code>data</code> : <i>String</i> Score data as json string</li>
	</ul>
	
	Notes:<ul>
	<li>Requires <code>com.adobe.serialization.json.JSON</code></li>
	</ul>
	
	@see com.pixeldroid.r_c4d3.scores.GameScoresProxy
	@see com.adobe.serialization.json.JSON
	@see http://code.google.com/p/as3corelib/
	*/
	public class RemoteGameScoresProxy extends GameScoresProxy
	{
		
		protected var _remoteUrl:String;
		
		protected var storeRequest:URLRequest;
		protected var retrieveRequest:URLRequest;
	
		protected var JL:JsonLoader;
		protected var showMessages:Boolean;
	
	
	
		/**
		Constructor.
		
		@param id A unique identifier for this set of scores and initials
		@param accessUrl The storage webservice URL
		@param maxScores The maximum number of entries to store
		@param isLogged Whether server messages should be trace logged
		*/
		public function RemoteGameScoresProxy(id:String, accessUrl:String=null, maxScores:int=10, isLogged:Boolean=false)
		{
			if (accessUrl) remoteUrl = accessUrl;
			super(id, maxScores);
			
			showMessages = isLogged;
			
			JL = new JsonLoader();
			JL.addEventListener(DataEvent.READY, onJsonResponse);
			JL.addEventListener(DataEvent.ERROR, onJsonError);
		}
	
	
		/**
		Provide the high score storage webservice URL.
		
		@param value A URL to a webservice that supports <code>game</code> (string), 
		<code>format ('json')</code> and <code>data</code> (string) query params
		*/
		public function set remoteUrl(value:String):void
		{
			_remoteUrl = value;
			storeRequest = new URLRequest(_remoteUrl);
			storeRequest.method = URLRequestMethod.GET;
			retrieveRequest = new URLRequest(_remoteUrl);
			retrieveRequest.method = URLRequestMethod.GET;
		}
		/** @private */
		public function get remoteUrl():String { return _remoteUrl; }
	
		/** @inheritdoc */
		override public function closeScoresTable():void
		{
			super.closeScoresTable();
			
			storeRequest = null;
			retrieveRequest = null;
		}
		
		/**
		Retrieve the scores from the server.
		
		<p>
		Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.LOAD</code>
		</p>
		
		@see com.pixeldroid.r_c4d3.scores.ScoreEvent
		*/
		override public function load():void
		{
			if (!gameId) throw new Error("Error: openScoresTable() must be called prior to calling load");
			if (!retrieveRequest) throw new Error("Error - remoteUrl must be set before calling load");
			
			var rVar:URLVariables = new URLVariables();
			rVar.format = "json";
			rVar.game = gameId;
			
			retrieveRequest.data = rVar;
			onDataSend(retrieveRequest);
		}
		
		/**
		Submit the scores to the server.
		
		<p>
		Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.SAVE</code>
		</p>
		
		@see com.pixeldroid.r_c4d3.scores.ScoreEvent
		*/
		override public function store():void
		{
			if (!gameId) throw new Error("Error: openScoresTable() must be called prior to calling store");
			if (!retrieveRequest) throw new Error("Error - remoteUrl must be set before calling store");
			
			var sVar:URLVariables = new URLVariables();
			sVar.format = "json";
			sVar.game = gameId;
			sVar.data = this.toJson();
			
			storeRequest.data = sVar;
			onDataSend(storeRequest);
		}
		
		
		/**
		Generates a valid JSON representation of the high scores table.
		*/
		public function toJson():String
		{
			return JSON.encode( {scores:scores, initials:initials} );
		}
		
		
		
		protected function onDataSend(value:URLRequest):void
		{
			if (showMessages) C.out(this, "onDataSend() - params: " +URLVariables(value.data).toString());
			JL.load(value);
		}			
		
		protected function onJsonResponse(e:DataEvent):void
		{
			if (showMessages)
			{
				C.out(this, "onJsonResponse() - message: " +e.message);
				C.out(this, "onJsonResponse() - data:    " +JSON.encode(e.data));
			}
			
			var serverResponse:Object = e.data;
			switch (serverResponse.type) {
				case ("set") :
					if (serverResponse.success != true) C.out(this, "communication error: " +serverResponse.message);
					
					storeEvent.success = serverResponse.success;
					storeEvent.message = serverResponse.message;
					dispatchEvent(storeEvent);
				break;
				
				case ("get") :
					if ((serverResponse.success == true))
					{
						this.scores = serverResponse.data.scores;
						this.initials = serverResponse.data.initials;
					}
					else C.out(this, "communication error: " +serverResponse.message);
					
					retrieveEvent.success = serverResponse.success;
					retrieveEvent.message = serverResponse.message;
					dispatchEvent(retrieveEvent);
				break;
				
				default:
					C.out(this, "unrecognized response type " +serverResponse.type);
				break;
			}
	
		}
		
		protected function onJsonError(e:DataEvent):void { dispatchEvent(e); }
	
	}

}
