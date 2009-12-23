

package model
{
	import flash.geom.Point;
	
	import model.SpriteVO;
	
	
	
	public class PlayerModel
	{
		
		private const thrustInc:Number = .1;
		private const drag:Number = .98;
		private const topSpeed:Number = 15;
		private const turnSpeed:Number = .1;
		private const bulletSpeed:Number = topSpeed * .8;
		private const kickback:Number = .03;
		private const RAD_TO_DEG:Number = 180 / Math.PI;
		
		private var thrust:Number = 0;
		private var thrustMultiplier:Number = 1;
		
		private var heading:Number; // radians
		private var pos:Point;
		private var acc:Point;
		private var vel:Point;
		private var lim:Point;
		
		private var inPlay:Boolean;
		
		
		
		public function PlayerModel()
		{
			C.out(this, "constructor");
			
			inPlay = true;
			heading = Math.random() * 2 * Math.PI;
			pos = new Point(0,0);
			vel = new Point(0,0);
		}
		
		
		
		public function set active(value:Boolean):void { inPlay = value; }
		public function get active():Boolean { return inPlay; }
		
		public function set position(value:Point):void { pos = value; }
		public function get position():Point { return pos.clone(); }
		
		public function set worldEdge(value:Point):void { lim = value; }
		public function get worldEdge():Point { return lim.clone(); }
		
		public function get direction():Point
		{ 
			var d:Point = Point.polar(1, heading);
			d.normalize(1);
			return d;
		}
		
		public function turnLeft():void 
		{
			C.out(this, "turnLeft");
			heading -= turnSpeed; 
		}
		public function turnRight():void 
		{ 
			C.out(this, "turnRight");
			heading += turnSpeed; 
		}
		
		public function accelerate():void
		{
			C.out(this, "accelerate");
			thrust = Math.min(1, thrust + thrustInc);
			thrustMultiplier = 1;
		}
		
		public function decelerate():void
		{
			C.out(this, "decelerate");
			thrust = Math.min(1, thrust + thrustInc);
			thrustMultiplier = -1;
		}
		
		public function coast():void 
		{ 
			C.out(this, "coast");
			thrust = 0; 
		}
		
		public function fire():void
		{
			C.out(this, "fire");
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
			acc = direction;
			mulScalar(acc, thrust * thrustMultiplier * topSpeed * dt * .001);
			mulScalar(vel, drag);
			addVector(vel, acc);
			addVector(pos, vel);
			
			if (pos.x > lim.x) { pos.x -= lim.x; }
			else if(pos.x < 0 ) { pos.x += lim.x; }
			if (pos.y > lim.y) { pos.y -= lim.y; }
			else if(pos.y < 0 ) { pos.y += lim.y; }
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
