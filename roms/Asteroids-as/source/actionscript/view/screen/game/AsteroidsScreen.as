

package view.screen.game
{
	
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.view.screen.ScreenBase;
	
	import GraphicAssets;
	import control.AsteroidsSignals;
	import model.SpriteVO;
	
	
	
	public class AsteroidsScreen extends ScreenBase
	{
		
		private var sprites:Array;
		
		public function AsteroidsScreen():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		
		// IDisposable interface
		override public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			
			sprites = null;
			
			// remove listeners from messaging service
			Notifier.removeListener(AsteroidsSignals.UPDATE_PLAYER_SPRITES, onUpdateSprites);
			
			return super.shutDown();
		}
		
		override public function initialize():Boolean
		{
			C.out(this, "initialize()");
			super.initialize();
			
			stage.frameRate = 60;
			sprites = [null, null, null, null];
			
			// attach listeners to messaging service
			Notifier.addListener(AsteroidsSignals.UPDATE_PLAYER_SPRITES, onUpdateSprites);
			
			return true;
		}
		
		
		
		private function onUpdateSprites(message:Object):void
		{
			var players:Array = message as Array;
			var n:int = players.length;
			var vo:SpriteVO;
			var s:Sprite;
			
			for (var i:int = 0; i < n; i++)
			{
				vo = players[i] as SpriteVO;
				s = sprites[i];
				if (s == null) s = sprites[i] = addChild(GraphicAssets.ship) as Sprite;
				
				s.x = vo.x;
				s.y = vo.y;
				s.rotation = vo.rotation;
				s.alpha = vo.alpha;
				s.visible = vo.visible;
				
				// TODO: update score overlay
				//scores[i] = vo.score;
			}
			
		}
		
	}
}
