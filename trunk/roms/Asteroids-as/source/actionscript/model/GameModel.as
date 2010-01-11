

package model
{
	import flash.geom.Point;
	
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.interfaces.IDisposable;
	import com.pixeldroid.r_c4d3.interfaces.IUpdatable;
	import com.pixeldroid.r_c4d3.scores.ScoreEntry;
	
	import control.AsteroidsSignals;
	import model.GlobalModel;
	import model.PlayerModel;
	import model.SpriteVO;
	
	
	public class GameModel implements IUpdatable, IDisposable
	{
		
		private var worldEdge:Point;
		private var numPlayers:int;
		private var players:Array;
		private var _drift:Point;
		
	
		public function GameModel(worldWidth:int, worldHeight:int, numPlayers:int)
		{
			C.out(this, "constructor");
			worldEdge = new Point(worldWidth, worldHeight);
			this.numPlayers = numPlayers;
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
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			_drift = new Point();
			players = [];
			
			drift = (new Point(Math.random()*2-1,Math.random()*2-1));
			var p:PlayerModel;
			var startPoints:Array = getStartPoints(numPlayers, worldEdge);
			
			for (var i:int = 0; i < numPlayers; i++)
			{
				p = new PlayerModel(GlobalModel.playerNames[i]);
				p.worldEdge = worldEdge;
				p.position = startPoints[i] as Point;
				p.active = GlobalModel.activePlayers[i];
				players.push(p);
			}
			
			return true;
		}
		
		
		
		// IUpdatable interface
		public function onUpdateRequest(dt:int):void
		{
			var n:int = players.length;
			var i:int = 0;
			var p:PlayerModel;
			var vo:Array = [];
			while (i < n)
			{
				p = players[i];
				p.active = GlobalModel.activePlayers[i];
				p.drift = drift;
				p.update(dt);
				vo.push(p.toSpriteVO());
				i++;
			}
			
			Notifier.send(AsteroidsSignals.UPDATE_PLAYER_SPRITES, vo);
		}
		
		
		
		public function turnLeft(which:int):void { (players[which] as PlayerModel).turnLeft(); }
		public function turnRight(which:int):void { (players[which] as PlayerModel).turnRight(); }
		public function accelerate(which:int, engaged:Boolean):void { (players[which] as PlayerModel).accelerate(engaged); }
		public function decelerate(which:int, engaged:Boolean):void { (players[which] as PlayerModel).decelerate(engaged); }
		public function noTurn(which:int):void { (players[which] as PlayerModel).noTurn(); }
		public function fire(which:int):void { (players[which] as PlayerModel).fire(); }
		
		
		
		public function set drift(value:Point):void
		{
			_drift.x = value.x;
			_drift.y = value.y;
			_drift.normalize(1);
		}
		
		public function get drift():Point
		{
			return _drift.clone();
		}
		

		
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
			C.out(this, "getStartPoints - " +points);
			return points;
		}
		
	}

}
