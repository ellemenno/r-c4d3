
package com.pixeldroid.r_c4d3.scores {
 
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import com.adobe.serialization.json.JSON;

	import com.pixeldroid.r_c4d3.data.DataEvent;
	import com.pixeldroid.r_c4d3.data.JsonLoader;
	import com.pixeldroid.r_c4d3.scores.GameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;


	/**
	* Extends the (abstract) GameScoresProxy base class to
	* store high scores and initials on a remote server,
	* using a web service that accepts the following parameters:<ul>
	* <li><code>game</code> : <i>String</i> Unique game id</li>
	* <li><code>format</code> : <i>String</i> "json" or "vrml"</li>
	* <li><code>data</code> : <i>String</i> Score data--as json string--to store; omission or empty value for data triggers retrieval</li>
	* </ul>
	* and returns the following data:<ul>
	* <li><code>type</code>: <i>String</i> "get" or "set"</li>
	* <li><code>success</code> : <i>Boolean</i></li>
	* <li><code>message</code> : <i>String</i></li>
	* <li><code>data</code> : <i>String</i> Score data as json string</li>
	* </ul>
	*
	* Notes:<ul>
	* <li>Requires <code>com.adobe.serialization.json.JSON</code></li>
	* 
	* @see com.pixeldroid.r_c4d3.scores.GameScoresProxy
	* @see com.adobe.serialization.json.JSON
	* @see http://code.google.com/p/as3corelib/
	*/
	public class RemoteGameScoresProxy extends GameScoresProxy {
		
		private var _remoteUrl:String;
		
		private var storeRequest:URLRequest;
		private var retrieveRequest:URLRequest;
	
		private var JL:JsonLoader;
	
	
	
		/**
		* Constructor.
		*
		* @param id A unique identifier for this set of scores and initials
		* @param maxScores The maximum number of entries to store
		* @param accessUrl The storage webservice URL
		*/
		public function RemoteGameScoresProxy(id:String, accessUrl:String=null, maxScores:int=10) {
			super(id, maxScores);
			if (accessUrl) remoteUrl = accessUrl;
		}
	
	
		/**
		* Provide the high score storage webservice URL.
		*
		* @param value A URL to a webservice that supports 
		* game (string), format ('json' | 'vrml') and data (string) query params
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
		* Retrieve the scores from the server.
		*
		* <p>Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.LOAD</code></p>
		* @see com.pixeldroid.r_c4d3.scores.ScoreEvent
		*/
		override public function load():void {
			if (!gameId) throw new Error("Error: openScoresTable() must be called prior to calling load");
			if (!retrieveRequest) throw new Error("Error - remoteUrl must be set before calling load");
			
			var rVar:URLVariables = new URLVariables();
			rVar.format = "json";
			rVar.game = gameId;
			
			retrieveRequest.data = rVar;
			JL.load(retrieveRequest);
		}
		
		/**
		* Submit the scores to the server.
		*
		* <p>Dispatches <code>com.pixeldroid.r_c4d3.scores.ScoreEvent.SAVE</code></p>
		* @see com.pixeldroid.r_c4d3.scores.ScoreEvent
		*/
		override public function store():void {
			if (!gameId) throw new Error("Error: openScoresTable() must be called prior to calling store");
			if (!retrieveRequest) throw new Error("Error - remoteUrl must be set before calling store");
			
			var sVar:URLVariables = new URLVariables();
			sVar.format = "json";
			sVar.game = gameId;
			sVar.data = this.toJson();
			
			storeRequest.data = sVar;
			JL.load(storeRequest);
		}
		
		
		/**
		* Generates a valid JSON representation of the high scores table.
		*/
		public function toJson():String {
			return JSON.encode( {scores:scores, initials:initials} );
		}
		
		
		
		override protected function initialize():void {
			JL = new JsonLoader();
			JL.addEventListener(DataEvent.READY, onJsonData);
			JL.addEventListener(DataEvent.ERROR, onJsonError);
			
			super.initialize();
		}
		
		
		
		private function onJsonError(e:DataEvent):void {
			dispatchEvent(e);
		}
		
		private function onJsonData(e:DataEvent):void {
			//C.out(this, "onJsonData - " +e.message);
			var serverResponse:Object = e.data;
			switch (serverResponse.type) {
				case ("set") :
					if (serverResponse.success == true) /*no-op*/;
					else C.out(this, "communication error: " +serverResponse.message, true);
					
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
					else trace(this, "communication error: " +serverResponse.message, true);
					
					retrieveEvent.success = serverResponse.success;
					retrieveEvent.message = serverResponse.message;
					dispatchEvent(retrieveEvent);
				break;
				
				default:
					trace(this, "unrecognized response type " +serverResponse.type, true);
				break;
			}
	
		}
	
	}

}
