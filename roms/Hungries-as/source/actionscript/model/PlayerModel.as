

package model
{
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	import model.SpriteVO;
	import SoundAssets;
	
	
	
	public class PlayerModel
	{
		
		private var drag:Number = .98;
		private var topSpeed:Number = 15; // pixels / sec
		private var radius:Number = 20; // pixels
		private var speedBonusMax:int = 1000;
		
		private var hed:Point; // heading
		private var acc:Point; // acceleration
		private var pos:Point; // position
		private var vel:Point; // velocity
		private var lim:Point; // limit
		
		private var sfxPickup:Sound;
		private var sfxTransform:SoundTransform;
		
		private var inPlay:Boolean;
		private var points:int;
		private var speedBonus:int;
		private var name:String;
		
		
		
		public function PlayerModel(playerName:String)
		{
			C.out(this, "constructor");
			
			name = playerName;
			
			inPlay = true;
			hed = new Point(0,0);
			acc = new Point(0,0);
			pos = new Point(0,0);
			vel = new Point(0,0);
			
			speedBonus = speedBonusMax;
			
			sfxPickup = SoundAssets.pointsIncrease;
			sfxTransform = new SoundTransform(.25);
		}
		
		
		public function set active(value:Boolean):void { inPlay = value; }
		public function get active():Boolean { return inPlay; }
		
		public function set position(value:Point):void { pos.x = value.x; pos.y = value.y; }
		public function get position():Point { return pos.clone(); }
		
		public function set worldEdge(value:Point):void { lim = value; }
		public function get worldEdge():Point { return lim.clone(); }
		
		public function get score():int { return points; }
		public function get initials():String { return name; }

		public function get x():Number { return position.x; }
		public function get y():Number { return position.y; }
		public function get r():Number { return radius; }
		
		
		
		public function pickUpGoody():void
		{
			points++;
			points += speedBonus;
			C.out(this, name +" got " +(speedBonus+1) +" points");
			
			speedBonus = speedBonusMax;
			
			sfxTransform.pan = (pos.x / lim.x) * 2 - 1; // 0,1 -> -1,1
			sfxPickup.play(0, 0, sfxTransform);
		}
		
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
		
		public function update(dt:int):void
		{
			if (!inPlay) return;
			
			// reduce speed bonus
			speedBonus = Math.max(1, speedBonus-1);
			
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
		}
		
		
		
		public function toSpriteVO():SpriteVO
		{
			var vo:SpriteVO = new SpriteVO();
			vo.x = pos.x;
			vo.y = pos.y;
			vo.visible = inPlay;
			
			return vo;
		}
		
		
		
		private function mulScalar(p:Point, n:Number):void { p.x *= n; p.y *= n; }
		private function addVector(p1:Point, p2:Point):void { p1.x += p2.x; p1.y += p2.y; }
		private function limit(val:Number, lo:Number, hi:Number):Number { return Math.max(lo, Math.min(hi, val)); }
		
	}

}
