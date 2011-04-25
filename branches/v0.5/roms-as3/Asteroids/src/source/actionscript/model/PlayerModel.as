

package model
{
	import flash.geom.Point;
	import flash.media.Sound;
	
	import model.SpriteVO;
	import SoundAssets;
	
	
	
	public class PlayerModel
	{
		
		private const RAD_TO_DEG:Number = 180 / Math.PI;
		
		private var drag:Number = .98;
		private var thrustInc:Number = .1;
		private var topSpeed:Number = 15; // pixels / sec
		private var bulletSpeed:Number = topSpeed * .8;
		private var turnSpeed:Number = .1; // radians / sec
		private var kickback:Number = -.03; // percent of bullet speed
		private var driftEffect:Number = .008; // percent of top speed
		
		private var accelerating:Boolean = false;
		private var decelerating:Boolean = false;
		private var thrust:Number = 0;
		private var thrustMultiplier:Number = 0;
		private var turnMultiplier:Number = 0;
		
		private var heading:Number; // radians
		private var acc:Point;
		private var pos:Point;
		private var vel:Point;
		private var lim:Point;
		private var dft:Point;
		
		private var sfxFire:Sound;
		private var sfxTurn:Sound;
		private var sfxMove:Sound;
		
		private var inPlay:Boolean;
		private var points:int;
		private var name:String;
		
		
		
		public function PlayerModel(playerName:String)
		{
			C.out(this, "constructor");
			
			name = playerName;
			
			inPlay = true;
			heading = Math.random() * 2 * Math.PI;
			pos = new Point(0,0);
			vel = new Point(0,0);
			dft = new Point(0,0);
			
			sfxFire = SoundAssets.laserFire;
			sfxTurn = SoundAssets.turn;
			sfxMove = SoundAssets.thrust;
		}
		
		
		
		public function set active(value:Boolean):void { inPlay = value; }
		public function get active():Boolean { return inPlay; }
		
		public function set drift(value:Point):void { dft.x = value.x; dft.y = value.y; }
		public function get drift():Point { return dft.clone(); }
		
		public function set position(value:Point):void { pos.x = value.x; pos.y = value.y; }
		public function get position():Point { return pos.clone(); }
		
		public function set worldEdge(value:Point):void { lim = value; }
		public function get worldEdge():Point { return lim.clone(); }
		
		public function get direction():Point
		{ 
			var d:Point = Point.polar(1, heading);
			d.normalize(1);
			return d;
		}
		
		public function get score():int { return points; }
		public function get initials():String { return name; }
		
		
		
		public function turnLeft():void 
		{
			C.out(this, "turnLeft");
			sfxTurn.play();
			turnMultiplier = -1;
		}
		public function turnRight():void 
		{ 
			C.out(this, "turnRight");
			sfxTurn.play();
			turnMultiplier = +1;
		}
		public function noTurn():void 
		{ 
			C.out(this, "noTurn");
			turnMultiplier = 0;
		}
		
		public function accelerate(engaged:Boolean):void
		{
			C.out(this, "accelerate: engaged? " +engaged);
			if (!accelerating && engaged) 
			{
				thrust = 0;
				sfxMove.play();
			}
			accelerating = engaged;
			thrustMultiplier = accelerating ? +1 : 0;
		}
		
		public function decelerate(engaged:Boolean):void
		{
			C.out(this, "decelerate: engaged? " +engaged);
			if (!decelerating && engaged) 
			{
				thrust = 0;
				sfxMove.play();
			}
			decelerating = engaged;
			thrustMultiplier = decelerating ? -1 : 0;
		}
		
		public function fire():void
		{
			C.out(this, "fire");
			sfxFire.play();
			/*// TODO: launch zap
			zap.x = pos.x + (acc.x * shipRadius);
			zap.y = pos.y + (acc.y * shipRadius);
			*/
			
			acc = direction;
			mulScalar(acc, bulletSpeed);
			mulScalar(acc, kickback);
			addVector(vel, acc);
		}
		
		
		
		public function update(dt:int):void
		{
			if (!inPlay) return;
			
			// apply turn and/or thrust 
			heading += turnSpeed * turnMultiplier; 
			if (thrustMultiplier != 0) thrust = Math.min(1, thrust + thrustInc);
			
			// apply drag
			mulScalar(vel, drag);
			
			// collect forces
			acc = direction;
			var topSpeedSlice:Number = topSpeed * dt * .001;
			mulScalar(acc, thrust * thrustMultiplier * topSpeedSlice);
			mulScalar(dft, driftEffect * topSpeedSlice);
			
			// apply forces to velocity
			addVector(vel, acc);
			addVector(vel, dft);
			
			// apply velocity to position
			addVector(pos, vel);
			
			// TODO: real point system
			points += Math.round(vel.length);
			
			// check for edge wrapping
			if (pos.x > lim.x)  pos.x -= lim.x;
			else if (pos.x < 0) pos.x += lim.x;
			if (pos.y > lim.y)  pos.y -= lim.y;
			else if (pos.y < 0) pos.y += lim.y;
		}
		
		
		
		public function toSpriteVO():SpriteVO
		{
			var vo:SpriteVO = new SpriteVO();
			vo.x = pos.x;
			vo.y = pos.y;
			vo.rotation = heading * RAD_TO_DEG;
			vo.visible = inPlay;
			
			return vo;
		}
		
		
		
		private function mulScalar(p:Point, n:Number):void { p.x *= n; p.y *= n; }
		private function addVector(p1:Point, p2:Point):void { p1.x += p2.x; p1.y += p2.y; }
	}

}
