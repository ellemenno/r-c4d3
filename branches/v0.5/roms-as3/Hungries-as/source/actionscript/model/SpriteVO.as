

package model
{
	
	public class SpriteVO
	{
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var alpha:Number = 1;
		public var rotation:Number = 0;
		public var visible:Boolean = true;
		
		public var score:int = 0;
		
		public function toString():String
		{
			var s:String = "SpriteVO {";
				s += " x: "+x.toPrecision(2);
				s += " y: "+y.toPrecision(2);
				s += " alpha: "+alpha.toPrecision(2);
				s += " rotation: "+rotation.toPrecision(2);
				s += " visible: "+visible;
				s += " score: "+score;
				s += " }";
				
			return s;
		}
	}

}
