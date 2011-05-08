
/*

ControlTest

A quick visual check that all the hook-ups are working for fourplayercontrol.
This demo implements IGameRom and listens for events on the provided IGameControllerPRoxy

mxmlc ControlTest.as -output=ControlTest.swf -default-size=800,600 -default-background-color=0x000000 -default-frame-rate=30 -library-path+=./ -source-path=./ -source-path=../../lib

*/

package
{

	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	
	import com.pixeldroid.r_c4d3.api.events.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.api.JoyEventStateEnumerator;
	import com.pixeldroid.r_c4d3.api.events.JoyHatEvent;
	import com.pixeldroid.r_c4d3.api.IGameConfigProxy;
	import com.pixeldroid.r_c4d3.api.IGameControlsProxy;
	import com.pixeldroid.r_c4d3.api.IGameRom;
	import com.pixeldroid.r_c4d3.api.IGameScoresProxy;
	
	import PlayerSet;

	

	public class ControlTest extends Sprite implements IGameRom
	{

		[Embed(source="../resources/fonts/Bamf Gradient.ttf", fontName="FONT_BAMF")]
		private static const FONT_BAMF:Class;

		private var P1:PlayerSet;
		private var P2:PlayerSet;
		private var P3:PlayerSet;
		private var P4:PlayerSet;
		private var players:Array;
		
		private var controls:IGameControlsProxy;
		private var scores:IGameScoresProxy;



		public function ControlTest()
		{
			drawPlayerColors();
			drawPlayerNumbers();
			addComponents(); // instantiates P1..P4
			
			players = [P1, P2, P3, P4];
		}


		// IGameRom API

		public function setConfigProxy(value:IGameConfigProxy):void
		{
			C.out(this, "setConfigProxy - no-op for controls demo");
		}
		
		public function setControlsProxy(value:IGameControlsProxy):void
		{
			C.out(this, "setControlsProxy to " +value);
			controls = value;
			controls.joystickEventState(JoyEventStateEnumerator.ENABLE, stage); // enable event reporting
			
			controls.joystickOpen(0); // activate joystick for player 1
			controls.joystickOpen(1); // activate joystick for player 2
			controls.joystickOpen(2); // activate joystick for player 3
			controls.joystickOpen(3); // activate joystick for player 4
			
			controls.addEventListener(JoyHatEvent.JOY_HAT_MOTION, onHatMotion); // add a listener for joystick hat events
			controls.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onButtonMotion); // add a listener for joystick button events
		}

		public function setScoresProxy(value:IGameScoresProxy):void
		{
			C.out(this, "setScoresProxy - no-op for controls demo");
		}

		public function enterAttractLoop():void
		{
			C.out(this, "enterAttractLoop");
			// normally this would begin the game loop
		}
		
		
		// control events
		private function onHatMotion(e:JoyHatEvent):void
		{
			C.out(this, "onHatMotion: " +e);
			PlayerSet(players[e.which]).setStick(e.value);
		}
		
		private function onButtonMotion(e:JoyButtonEvent):void
		{
			C.out(this, "onButtonMotion: " +e);
			PlayerSet(players[e.which]).setButton(e.button, e.pressed);
		}
		
		
		
		// scene composition
		private function drawPlayerGradient(color:uint, shape:Shape, w:uint, h:uint):void
		{
			var M:Matrix = new Matrix();
			M.createGradientBox(w, h, Math.PI/2, 0, 0);

			shape.graphics.beginGradientFill(GradientType.LINEAR, [color,color], [1,0], [0,200], M);
			shape.graphics.drawRect(0, 0, w, h);
			shape.graphics.endFill();
		}

		private function drawPlayerColors():void
		{
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0, 0, 800, 600);
			graphics.endFill();

			var w:uint = 200;
			var h:uint = 600;

			var S3:Shape = new Shape();
			drawPlayerGradient(0xff0000, S3, w, h);
			addChild(S3);
			S3.x = 0 * w;

			var S1:Shape = new Shape();
			drawPlayerGradient(0xffff00, S1, w, h);
			addChild(S1);
			S1.x = 1 * w;

			var S2:Shape = new Shape();
			drawPlayerGradient(0x00ff00, S2, w, h);
			addChild(S2);
			S2.x = 2 * w;

			var S4:Shape = new Shape();
			drawPlayerGradient(0x0044ff, S4, w, h);
			addChild(S4);
			S4.x = 3 * w;
		}

		private function setNumberText(t:TextField, tf:TextFormat, s:String, a:Number):void
		{
			t.selectable = false;
			t.embedFonts = true;
			t.text = s;
			t.setTextFormat(tf); // will only apply formatting to existing text!
			t.alpha = a;
		}

		private function drawPlayerNumbers():void
		{
			var baseline:Number = 120;
			var offset:Number = 50;
			var alpha:Number = .3;

			var format:TextFormat = new TextFormat();
			format.font = "FONT_BAMF";
			format.color = 0xffffff;
			format.size = 80;
			format.align = TextFormatAlign.CENTER;

			var N3:TextField = new TextField();
			setNumberText(N3, format, "3", alpha);
			addChild(N3);
			N3.x = offset;
			N3.y = baseline;

			var N1:TextField = new TextField();
			setNumberText(N1, format, "1", alpha);
			addChild(N1);
			N1.x = 200 + offset;
			N1.y = baseline;

			var N2:TextField = new TextField();
			setNumberText(N2, format, "2", alpha);
			addChild(N2);
			N2.x = 400 + offset;
			N2.y = baseline;

			var N4:TextField = new TextField();
			setNumberText(N4, format, "4", alpha);
			addChild(N4);
			N4.x = 600 + offset;
			N4.y = baseline;
		}

		private function addComponents():void
		{
			var baseline:Number = 400;
			var space:Number = 27;

			P3 = new PlayerSet();
			addChild(P3);
			P3.scaleX = P3.scaleY = .5;
			P3.x = space;
			P3.y = baseline;

			P1 = new PlayerSet();
			addChild(P1);
			P1.scaleX = P1.scaleY = .5;
			P1.x = P3.x + P3.width + space + space;
			P1.y = baseline;

			P2 = new PlayerSet();
			addChild(P2);
			P2.scaleX = P2.scaleY = .5;
			P2.x = P1.x + P1.width + space + space;
			P2.y = baseline;

			P4 = new PlayerSet();
			addChild(P4);
			P4.scaleX = P4.scaleY = .5;
			P4.x = P2.x + P2.width + space + space;
			P4.y = baseline;
		}
	}

}
