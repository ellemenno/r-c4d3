
package com.pixeldroid.r_c4d3
{
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	
	public class TestTest {
		
		protected var timer:Timer;
		protected static var SHORT_TIME:int = 30;
		protected static var LONG_TIME:int = 500;

		[Before]
		public function setUp():void {
			timer = new Timer(LONG_TIME, 1);
		}
		
		[After]
		public function tearDown():void {
			if (timer) timer.stop();
			timer = null;
		}
		
		
		[Test(description="Testing addition operator")]
		public function simpleAdd():void 
		{
			 var x:int = 5 + 3;
			 Assert.assertEquals(8, x);
		}
		
		[Test(async,description="Test handling of timer-created asynch event")]
	    public function testInTimePass() : void {
	    	timer.delay = SHORT_TIME;
	    	timer.addEventListener(
				TimerEvent.TIMER_COMPLETE, 
				Async.asyncHandler(this, checkIsTimerEvent, LONG_TIME, null, onTimeoutFail), 
				false, 0, true
			);
	    	timer.start();
	    }
		protected function checkIsTimerEvent(event:Event, passThroughData:Object):void {
			Assert.assertNotNull(event);
			Assert.assertTrue(event is TimerEvent);
		}
		
		[Test(async,description="Test passing of data via dispatched event")]
	    public function testEventDataCorrect() : void {
	    	var eventDispatcher:EventDispatcher = new EventDispatcher();
	    	eventDispatcher.addEventListener(
				'immediate', 
				Async.asyncHandler(this, checkEventData, SHORT_TIME, null, onTimeoutFail), 
				false, 0, true
			);
	    	eventDispatcher.dispatchEvent(new DataEvent('immediate', false, false, '0123456789')); 
	    }
		protected function checkEventData(event:DataEvent, passThroughData:Object):void {
			Assert.assertEquals(event.data, '0123456789');
		}
		
		protected function onTimeoutFail(passThroughData:Object):void {
			Assert.fail('Timeout Reached Incorrectly');
		}
	}
}


