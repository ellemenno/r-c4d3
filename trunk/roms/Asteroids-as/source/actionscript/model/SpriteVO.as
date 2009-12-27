

package model
{
	
	public class SpriteVO
	{
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var alpha:Number = 1;
		public var rotation:Number = 0;
		public var visible:Boolean = true;
		
		public function toString():String
		{
			var s:String = "SpriteVO {";
				s += " x: "+x;
				s += " y: "+y;
				s += " alpha: "+alpha;
				s += " rotation: "+rotation;
				s += " visible: "+visible;
				s += " }";
				
			return s;
		}
	}

}
