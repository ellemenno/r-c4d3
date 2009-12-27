

package model
{
	import flash.geom.Point;
	
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.game.control.Signals;
	import com.pixeldroid.r_c4d3.interfaces.IDisposable;
	
	import control.AsteroidsSignals;
	import model.PlayerModel;
	import model.SpriteVO;
	
	
	public class AsteroidsModel implements IDisposable
	{
		
		private var worldEdge:Point;
		private var numPlayers:int;
		private var players:Array;
		private var _drift:Point;
		
	
		public function AsteroidsModel(worldWidth:int, worldHeight:int, numPlayers:int)
		{
			C.out(this, "constructor");
			worldEdge = new Point(worldWidth, worldHeight);
			this.numPlayers = numPlayers;
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			
			var scores:Array = [];
			for each (var p:PlayerModel in players) scores.push(p.score);
			Notifier.send(Signals.SCORES_SUBMIT, scores);
			
			players = null;
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			_drift = new Point();
			players = [];
			
			drift = (new Point(Math.random(),Math.random()));
			var p:PlayerModel;
			for (var i:int = 0; i < numPlayers; i++)
			{
				p = new PlayerModel();
				p.worldEdge = worldEdge
				p.position = new Point(Math.random()*worldEdge.x, Math.random()*worldEdge.y);
				players.push(p);
			}
			
			return true;
		}
		
		
		
		public function turnLeft(which:int):void { (players[which] as PlayerModel).turnLeft(); }
		public function turnRight(which:int):void { (players[which] as PlayerModel).turnRight(); }
		public function accelerate(which:int):void { (players[which] as PlayerModel).accelerate(); }
		public function decelerate(which:int):void { (players[which] as PlayerModel).decelerate(); }
		public function noTurn(which:int):void { (players[which] as PlayerModel).noTurn(); }
		public function noThrust(which:int):void { (players[which] as PlayerModel).noThrust(); }
		public function coast(which:int):void { (players[which] as PlayerModel).coast(); }
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
		
		public function enablePlayer(index:int, active:Boolean):void
		{
			// TODO: join in support
			if (index < 0 || index >= players.length) (players[index] as PlayerModel).active = active;
		}
		
		
		
		public function tick(dt:int):void
		{
			var n:int = players.length;
			var i:int = 0;
			var p:PlayerModel;
			var vo:Array = [];
			while (i < n)
			{
				p = players[i];
				p.drift = drift;
				p.update(dt);
				vo.push(p.toSpriteVO());
				i++;
			}
			
			Notifier.send(AsteroidsSignals.UPDATE_PLAYER_SPRITES, vo);
		}
	}

}
