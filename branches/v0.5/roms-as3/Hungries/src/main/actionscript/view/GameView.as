

package view
{
	
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import com.pixeldroid.r_c4d3.api.IDisposable;
	import com.pixeldroid.r_c4d3.api.IUpdatable;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.model.Colors;
	
	import GraphicAssets;
	
	import model.GameSignals;
	import model.SpriteVO;
	
	
	
	public class GameView extends Sprite implements IUpdatable, IDisposable
	{
		
		private var sprites:Array/*<Sprite>*/;
		private var spriteData:Array/*<SpriteVO>*/;

		private var players:Array/*<Sprite>*/;
		private var goodies:Array/*<Sprite>*/;
		private var gameColors:Array/*<uint>*/ = [
			Colors.PLAYER_1,
			Colors.PLAYER_2,
			Colors.PLAYER_3,
			Colors.PLAYER_4
		];
		
		
		
		public function GameView():void
		{
			C.out(this, "constructor");
			super();
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			
			players = null;
			goodies = null;
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			players = [];
			goodies = [];
			
			return true;
		}
		
		
		
		// IUpdatable interface
		public function onUpdateRequest(dt:int):void
		{
			Notifier.send(GameSignals.GET_REMOVABLE_GOODIES, removeCollectedGoodies);
			Notifier.send(GameSignals.GET_GOODY_DATA, updateGoodies);
			Notifier.send(GameSignals.GET_PLAYER_DATA, updatePlayers);
		}
		
		
		
		// internal helpers
		private function removeCollectedGoodies(indexList:Array/*int*/):void
		{
			var n:int = indexList.length;
			
			for (var i:int = 0; i < n; i++)
			{
				removeChild( goodies.splice(indexList[i], 1)[0] as Sprite );
			}
		}
		
		private function updateGoodies(goodyData:Array/*SpriteVO*/):void
		{
			var n:int = goodyData.length;
			var vo:SpriteVO;
			var s:Sprite;
			
			for (var i:int = 0; i < n; i++)
			{
				vo = goodyData[i] as SpriteVO;
				s = goodies[i] as Sprite;
				if (s == null) s = goodies[i] = addChild(GraphicAssets.goody) as Sprite;
				
				s.x = vo.x;
				s.y = vo.y;
			}
		}
		
		private function updatePlayers(playerData:Array/*SpriteVO*/):void
		{
			var n:int = playerData.length;
			var vo:SpriteVO;
			var s:Sprite;
			var ct:ColorTransform;
			
			for (var i:int = 0; i < n; i++)
			{
				vo = playerData[i] as SpriteVO;
				s = players[i] as Sprite;
				if (s == null) // create new player
				{
					s = players[i] = addChild(GraphicAssets.player) as Sprite;
					ct = s.transform.colorTransform;
					ct.color = gameColors[i];
					s.transform.colorTransform = ct;
				}
				
				s.x = vo.x;
				s.y = vo.y;
				s.rotation = vo.rotation;
				s.alpha = vo.alpha;
				s.visible = vo.visible;
			}
		}
		
	}
}
