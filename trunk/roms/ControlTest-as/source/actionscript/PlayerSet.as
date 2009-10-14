
package {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	
	// from assets.swc
	import assets.Joystick;
	import assets.Button;


	public class PlayerSet extends Sprite {
		
		private var J:MovieClip;
		private var X:MovieClip;
		private var A:MovieClip;
		private var B:MovieClip;
		private var C:MovieClip;
		
		
		public function PlayerSet() {
			addComponents();
		}

		
		public function setStick(positionCode:int):void {
			switch (positionCode) {
				case  0 : J.gotoAndStop("C");  break;
				case  1 : J.gotoAndStop("U");  break;
				case  2 : J.gotoAndStop("R");  break;
				case  3 : J.gotoAndStop("UR"); break;
				case  4 : J.gotoAndStop("D");  break;
				case  6 : J.gotoAndStop("DR"); break;
				case  8 : J.gotoAndStop("L");  break;
				case  9 : J.gotoAndStop("UL"); break;
				case 12 : J.gotoAndStop("DL"); break;
			}
		}
		public function setButton(index:int, pressed:Boolean):void {
			var btn:MovieClip;
			switch (index) {
				case  0 : btn = X; break;
				case  1 : btn = A; break;
				case  2 : btn = B; break;
				case  3 : btn = C; break;
			}
			if (pressed) btn.gotoAndStop("D");
			else         btn.gotoAndStop("U");
		}

		
		private function addComponents():void {
			J = new Joystick();
			addChild(J);
			J.stop();
			J.x = 20;
			J.y = -15;
			
			X = new Button();
			alterColor(X, 255, 255, 0,  .7);
			addChild(X);
			X.stop();
			X.x = 103;
			X.y = 149;
			
			A = new Button();
			alterColor(A, 255, 0, 0,  .7);
			addChild(A);
			A.stop();
			A.x = 143;
			A.y = 83;
			
			B = new Button();
			alterColor(B, 0, 255, 0,  .7);
			addChild(B);
			B.stop();
			B.x = 200;
			B.y = 68;
			
			C = new Button();
			alterColor(C, 0, 51, 204,  .7);
			addChild(C);
			C.stop();
			C.x = 259;
			C.y = 63;
		}
		
		private static function alterColor(sprite:Sprite, r:int, g:int, b:int, m:Number):void {
			var color:ColorTransform = sprite.transform.colorTransform;
			color.redMultiplier = color.greenMultiplier = color.blueMultiplier = m;
			color.redOffset = r;
			color.greenOffset = g;
			color.blueOffset = b;
			sprite.transform.colorTransform = color;
		}

	}

}
