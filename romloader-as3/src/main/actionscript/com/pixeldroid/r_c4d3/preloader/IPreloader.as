
package com.pixeldroid.r_c4d3.preloader
{

	import flash.events.ProgressEvent;
	
	import com.pixeldroid.r_c4d3.api.IDisposable;
	import com.pixeldroid.r_c4d3.api.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.api.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.api.IGameScoresProxy;

	
	/**
	Dispatched when the preloader is ready to receive progress updates, 
	typically after it has completed some intro transition in response to <code>open()</code>.
	@eventType flash.events.Event.OPEN
	@see #open
	*/
	[Event(name="OPEN", type="flash.events.Event")]
	
	/**
	Dispatched when the preloader is done, 
	typically after it has completed some outro transition in reponse to load progress reaching 100%.
	@eventType flash.events.Event.CLOSE
	@see #progress
	*/
	[Event(name="CLOSE", type="flash.events.Event")]

	
	public interface IPreloader extends IDisposable
	{
		function open():void;
		function set progress(value:ProgressEvent):void;
		function get progress():ProgressEvent;
		function onConfigData(configData:IGameConfigProxy, controlsProxy:IGameControlsProxy, scoresProxy:IGameScoresProxy):void;
	}
}
