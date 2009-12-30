
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import SoundAssets;
	
	
	[SWF(width="200", height="100", frameRate="30", backgroundColor="#000000")]
    public class SoundTest extends Sprite
	{
	
		private var colors:Array = [
			0xff0000, 0x00ffff, 0xffff00, 
			0x444400, 0xff00ff, 0x00ff00
		];
		private var sounds:Array = [];
		private var sprites:Array = [];
		
		
		public function SoundTest():void
		{
			addChildren();
			fitToGrid();
		}
		
		private function addChildren():void
		{
			sounds.push( SoundAssets.laserFire );
			sounds.push( SoundAssets.pointsIncrease );
			sounds.push( SoundAssets.powerUp );
			sounds.push( SoundAssets.rockBreak );
			sounds.push( SoundAssets.thrust );
			sounds.push( SoundAssets.turn );
			
			var n:int = sounds.length;
			for (var i:int = 0; i < n; i++) { sprites.push( addChild( new SoundButton(sounds[i], colors[i]) )); }
		}
		
		private function fitToGrid():void
		{
			var n:int = sprites.length;
			var c:int = 0;
			var r:int = 0;
			var d:DisplayObject;
			
			for (var i:int = 0; i < n; i++)
			{
				d = sprites[i];
				d.x = c * 50;
				d.y = r * 50;
				
				c++;
				if (c * 50 > stage.stageWidth - 50)
				{
					c = 0;
					r++;
				}
			}
		}
	}
}


	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	
    class SoundButton extends Sprite
	{
		private var sound:Sound;
		private var color:uint;
		
		public function SoundButton(s:Sound, c:uint):void
		{
			sound = s;
			color = c;
			addEventListener(MouseEvent.CLICK, playSound);
			addEventListener(MouseEvent.ROLL_OVER, drawOver);
			addEventListener(MouseEvent.ROLL_OUT, drawOff);
			useHandCursor = buttonMode = true;
			drawOff();
		}
		
		public function playSound(e:MouseEvent=null):void { sound.play(); }
		
		private function drawOff(e:MouseEvent=null):void { draw(4, 8); }
		
		private function drawOver(e:MouseEvent=null):void { draw(2, 4); }
		
		private function draw(lineWeight:int, radius:int):void
		{
			graphics.clear();
			graphics.lineStyle(lineWeight, 0xffffff);
			graphics.beginFill(color);
			graphics.drawRoundRect(0,0, 40,40, radius);
			graphics.endFill();
		}
	}

