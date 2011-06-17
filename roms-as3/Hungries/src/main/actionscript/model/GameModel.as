

package model
{
	import flash.geom.Point;
	
	import com.pixeldroid.r_c4d3.api.events.JoyButtonEvent;
	import com.pixeldroid.r_c4d3.api.events.JoyHatEvent;
	import com.pixeldroid.r_c4d3.api.IControllable;
	import com.pixeldroid.r_c4d3.api.IDisposable;
	import com.pixeldroid.r_c4d3.api.IScoreEntry;
	import com.pixeldroid.r_c4d3.api.IUpdatable;
	import com.pixeldroid.r_c4d3.api.ScoreEntry;
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	
	import GameSignals;
	import model.GlobalModel;
	import model.GoodyModel;
	import model.PlayerModel;
	import model.SpriteVO;
	
	
	public class GameModel implements IUpdatable, IDisposable, IControllable
	{
		
		private var worldEdge:Point;
		private var numPlayers:int;
		private var numGoodies:int;
		private var players:Array;
		private var playerVOs:Array;
		private var goodies:Array;
		private var goodyVOs:Array;
		private var removableGoodies:Array;
		
	
		public function GameModel()
		{
			C.out(this, "constructor");
			worldEdge = new Point(GlobalModel.stageWidth, GlobalModel.stageHeight);
			numPlayers = GlobalModel.activePlayers.length;
			numGoodies = numPlayers * 3;
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			var scores:Array = [];
			for each (var p:PlayerModel in players) scores.push(new ScoreEntry(p.score, p.initials));
			C.out(this, "shutDown() - sending scores to proxy: " +scores);
			Notifier.send(Signals.SCORES_SUBMIT, scores);
			// acceptance values now updated
			
			players = null;
			
			// remove listeners from messaging service
			Notifier.removeListener(GameSignals.GET_REMOVABLE_GOODIES, onGetRemovableGoodies);
			Notifier.removeListener(GameSignals.GET_PLAYER_DATA, onGetPlayerData);
			Notifier.removeListener(GameSignals.GET_GOODY_DATA, onGetGoodyData);			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			players = [];
			goodies = [];
			goodyVOs = [];

			var p:PlayerModel;
			var g:GoodyModel;
			var startPoints:Array = getStartPoints(numPlayers+numGoodies, worldEdge);
			
			for (var i:int = 0; i < numPlayers; i++)
			{
				p = new PlayerModel(GlobalModel.playerNames[i]);
				p.worldEdge = worldEdge;
				p.position = startPoints[i] as Point;
				p.active = GlobalModel.activePlayers[i];
				players.push(p);
			}
			for (var j:int = 0; j < numGoodies; j++)
			{
				g = new GoodyModel();
				g.position = startPoints[numPlayers+j] as Point;
				goodies.push(g);
				goodyVOs.push(g.toSpriteVO());
			}
			
			// attach listeners to messaging service
			Notifier.addListener(GameSignals.GET_REMOVABLE_GOODIES, onGetRemovableGoodies);
			Notifier.addListener(GameSignals.GET_PLAYER_DATA, onGetPlayerData);
			Notifier.addListener(GameSignals.GET_GOODY_DATA, onGetGoodyData);
			
			return true;
		}
		
		
		
		// IControllable interface
		public function onButtonMotion(e:JoyButtonEvent):void { /* no-op */ }
		public function onHatMotion(e:JoyHatEvent):void
		{
			var player:PlayerModel = players[e.which] as PlayerModel;
			if (e.isCentered) player.setHeading(0, 0);
			else
			{
				if      (e.isLeft)  player.adjustHeading(-1,  0);
				else if (e.isRight) player.adjustHeading(+1,  0);
				if      (e.isUp)    player.adjustHeading( 0, -1);
				else if (e.isDown)  player.adjustHeading( 0, +1);
			}
		}
		
		
		
		// IUpdatable interface
		public function onUpdateRequest(dt:int):void
		{
			if (goodies.length == 0) Notifier.send(GameSignals.GAME_OVER);
			else
			{
				integrateInput(dt);
				checkCollisions();
			}
		}
		
		
		
		// internal helpers
		private function integrateInput(dt:int):void
		{
			// integrate forces and apply to player models, extract sprite VOs
			var n:int = players.length;
			var i:int = 0;
			var p:PlayerModel;
			playerVOs = [];
			while (i < n)
			{
				p = players[i];
				p.active = GlobalModel.activePlayers[i];
				p.update(dt);
				playerVOs.push(p.toSpriteVO());
				i++;
			}
		}
		private function checkCollisions():void
		{
			// check for collisions, count points, accumulate removables
			var n:int = players.length, m:int = goodies.length;
			var i:int = 0, j:int = 0;
			var p:PlayerModel;
			var g:GoodyModel;
			removableGoodies = [];
			while (i < n)
			{
				if (GlobalModel.activePlayers[i])
				{
					p = players[i] as PlayerModel;
					j = 0;
					while (j < m)
					{
						g = goodies[j] as GoodyModel;
						if (overlapping(p.x,p.y,p.r, g.x,g.y,g.r*.8))
						{
							p.pickUpGoody();
							removableGoodies.push(j);
						}
						j++;
					}
				}
				i++;
			}
			
			// remove captured goodies from list
			m = removableGoodies.length;
			for (i = m-1; i >= 0; i--)
			{
				goodies.splice(removableGoodies[i], 1);
				goodyVOs.splice(removableGoodies[i], 1);
			}
		}
		
		private function onGetRemovableGoodies(f:Function):void { f(removableGoodies); }
		private function onGetPlayerData(f:Function):void { f(playerVOs); }
		private function onGetGoodyData(f:Function):void { f(goodyVOs); }
		
		private function getStartPoints(howMany:int, worldSize:Point):Array/*Point*/
		{
			// create grid of non-overlapping positions, randomly select some
			var n:int = numPlayers * 2;
			var xInc:Number = worldSize.x / (n+1);
			var yInc:Number = worldSize.y / (n+1);
			var choices:Array = [];
			var r:int, c:int;
			for (r = 1; r <= n; r++)
			{
				for (c = 1; c <= n; c++) choices.push(new Point(c*xInc, r*yInc));
			}
			
			var points:Array = [];
			var i:int, j:int;
			for (i = 0; i <= howMany; i++)
			{
				j = Math.floor(Math.random() * choices.length);
				points.push(choices.splice(j, 1)[0]);
			}
			
			return points;
		}
		
		private function overlapping(ax:Number,ay:Number,ar:Number, bx:Number,by:Number,br:Number):Boolean
		{
			var dx:Number = bx - ax;
			var dy:Number = by - ay;
			var dr:Number = ar + br;
			return ( (dx*dx + dy*dy) < (dr*dr) );
		}
		
	}

}
