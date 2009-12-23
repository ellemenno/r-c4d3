

package model
{
	
	public class SpriteVO
	{
		
		public var x:Number;
		public var y:Number;
		
		public var alpha:Number;
		public var rotation:Number;
		public var visible:Boolean;
		
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
