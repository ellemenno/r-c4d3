

package view.screen.game
{
	
	import flash.display.Sprite;
	
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.interfaces.IDisposable;
	import com.pixeldroid.r_c4d3.interfaces.IUpdatable;
	
	import GraphicAssets;
	import control.AsteroidsSignals;
	import model.SpriteVO;
	
	
	
	public class GameView extends Sprite implements IUpdatable, IDisposable
	{
		
		private var sprites:Array/*<Sprite>*/;
		private var spriteData:Array/*<SpriteVO>*/;
		
		
		
		public function GameView():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			
			sprites = null;
			spriteData = null;
			
			// remove listeners from messaging service
			Notifier.removeListener(AsteroidsSignals.UPDATE_PLAYER_SPRITES, onUpdateSprites);
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			stage.frameRate = 60;
			sprites = [null, null, null, null];
			
			// attach listeners to messaging service
			Notifier.addListener(AsteroidsSignals.UPDATE_PLAYER_SPRITES, onUpdateSprites);
			
			return true;
		}
		
		
		
		// IUpdatable interface
		public function onUpdateRequest(dt:int):void
		{
			var n:int = spriteData.length;
			var vo:SpriteVO;
			var s:Sprite;
			
			for (var i:int = 0; i < n; i++)
			{
				vo = spriteData[i] as SpriteVO;
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
		
		
		
		private function onUpdateSprites(spriteVOs:Array):void
		{
			spriteData = spriteVOs;
		}
		
	}
}
