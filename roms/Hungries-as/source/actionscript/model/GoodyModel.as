

package model
{
	import flash.geom.Point;
	
	
	
	public class GoodyModel
	{
		
		private var radius:Number = 16;
		private var pos:Point;
		
		
		
		public function GoodyModel()
		{
			C.out(this, "constructor");
			
			pos = new Point(0,0);
		}


		
		public function set position(value:Point):void { pos = value; }
		public function get position():Point { return pos.clone(); }

		public function get x():Number { return position.x; }
		public function get y():Number { return position.y; }
		public function get r():Number { return radius; }
		
		public function toSpriteVO():SpriteVO
		{
			var vo:SpriteVO = new SpriteVO();
			vo.x = pos.x;
			vo.y = pos.y;
			
			return vo;
		}
	}
}
