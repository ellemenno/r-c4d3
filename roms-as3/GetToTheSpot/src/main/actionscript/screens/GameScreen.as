

package screens
{

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	import com.pixeldroid.r_c4d3.api.IScoreEntry;
	import com.pixeldroid.r_c4d3.api.ScoreEntry;
	import com.pixeldroid.r_c4d3.api.events.JoyHatEvent;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.game.screen.ScreenBase;

	import GraphicAssets;
	import SoundAssets;
	
	
	public class GameScreen extends ScreenBase
	{
		
		private var player:Sprite;
		private var spot:Sprite;
		
		private var drag:Number = .98;
		private var topSpeed:Number = 15; // pixels / sec
		private var speedBonusMax:int = 10000;
		private var bonusTimeLimit:int = 5; // sec
		private var bonusDecay:int;
		
		private var hed:Point; // heading
		private var acc:Point; // acceleration
		private var pos:Point; // position
		private var vel:Point; // velocity
		private var lim:Point; // limit
		
		private var sfxPickup:Sound;
		private var sfxTime:Sound;
		private var score:IScoreEntry;
		private var speedBonus:int;
		private var finished:Boolean;

		
		
		public function GameScreen():void
		{
			C.out(this, "constructor");
			super();
			
		}
		
		
		
		// IDisposable interface
		override public function initialize():Boolean
		{
			backgroundColor = 0x000000;
			
			var fps:Number = 60;
			stage.frameRate = fps;
			
			spot = GraphicAssets.spot;
			spot.x = stage.stageWidth * .5;
			spot.y = stage.stageHeight * .5;
			addChild(spot);
			
			player = GraphicAssets.player;
			addChild(player);
			
			hed = new Point(0,0);
			acc = new Point(0,0);
			pos = new Point(0,0);
			vel = new Point(0,0);
			lim = new Point(stage.stageWidth, stage.stageHeight);
			
			var angle:Number = Math.random() * Math.PI*2;
			var distance:Number = Math.min(spot.x, spot.y) - (player.width * .6);
			pos.x = Math.cos(angle) * distance + spot.x;
			pos.y = Math.sin(angle) * distance + spot.y;
			
			sfxPickup = SoundAssets.pointsIncrease;
			sfxTime = SoundAssets.timeUp;
			score = new ScoreEntry(0, "Player 1");
			speedBonus = speedBonusMax;
			bonusDecay = Math.floor(speedBonusMax / (bonusTimeLimit*fps)); // how much to drop each frame
			
			finished = false;
			
			C.out(this, "initialize() - frameRate: " +stage.frameRate);
			return super.initialize();
		}
		
		override public function shutDown():Boolean
		{
			var scores:Array = [score];
			C.out(this, "shutDown() - sending scores to proxy: " +scores);
			Notifier.send(Signals.SCORES_SUBMIT, scores);
			
			removeChild(spot);
			spot = null;
			
			removeChild(player);
			player = null;
			
			return super.shutDown();
		}

		
		
		// IController interface
		override public function onUpdateRequest(dt:int):void
		{
			super.onUpdateRequest(dt);
			
			speedBonus = Math.max(0, speedBonus-bonusDecay);
			//C.out(this, "time: " +timeElapsed +", bonus: " +speedBonus +", fps: " +stage.frameRate);
			
			updatePosition(dt);
			
			if (finished) gameOver();
			else
			{
				if (timeIsUp()) 
				{
					C.out(this, "onUpdateRequest() - time up!");
					sfxTime.play();
					finished = true;
				}
				else if (playerWins())
				{
					C.out(this, "onUpdateRequest() - player wins!");
					sfxPickup.play();
					score.value += 1 + speedBonus;
					finished = true;
				}
			}
			
		}

		override public function onHatMotion(e:JoyHatEvent):void
		{
			if (e.isCentered) setHeading(0, 0);
			else
			{
				if      (e.isLeft)  adjustHeading(-1,  0);
				else if (e.isRight) adjustHeading(+1,  0);
				if      (e.isUp)    adjustHeading( 0, -1);
				else if (e.isDown)  adjustHeading( 0, +1);
			}
		}
		

		
		// helpers
		public function setHeading(h:Number, v:Number):void
		{
			hed.x = h;
			hed.y = v;
		}
		
		public function adjustHeading(h:Number, v:Number):void
		{
			hed.x = limit(hed.x+h, -1, 1);
			hed.y = limit(hed.y+v, -1, 1);
		}
		
		private function gameOver():void
		{
			C.out(this, "gameOver() - sending SCREEN_GO_NEXT signal");
			Notifier.send(Signals.SCREEN_GO_NEXT);
		}
		
		private function playerWins():Boolean
		{
			var dx:Number = player.x - spot.x;
			var dy:Number = player.y - spot.y;
			var r:Number = (spot.width/2 - player.width/2) * .85;
			return Boolean( (dx*dx + dy*dy) < (r*r) );
		}
		
		private function timeIsUp():Boolean
		{
			return Boolean(timeElapsed > 50*1000);
		}
		
		private function updatePosition(dt:int):void
		{
			// set acceleration by heading and topSpeed
			acc.x = hed.x * topSpeed;
			acc.y = hed.y * topSpeed;
			
			// correct acceleration for time elapsed
			mulScalar(acc, dt*.001);
			
			// apply forces to velocity
			mulScalar(vel, drag);
			addVector(vel, acc);
			
			// apply velocity to position
			addVector(pos, vel);
			
			// check for edge wrapping
			if (pos.x > lim.x)  pos.x -= lim.x;
			else if (pos.x < 0) pos.x += lim.x;
			if (pos.y > lim.y)  pos.y -= lim.y;
			else if (pos.y < 0) pos.y += lim.y;
			
			// apply pos to player graphic
			player.x = pos.x;
			player.y = pos.y;
		}
		
		private function mulScalar(p:Point, n:Number):void { p.x *= n; p.y *= n; }
		private function addVector(p1:Point, p2:Point):void { p1.x += p2.x; p1.y += p2.y; }
		private function limit(val:Number, lo:Number, hi:Number):Number { return Math.max(lo, Math.min(hi, val)); }
		
	}
}
