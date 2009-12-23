

package model
{
	import flash.geom.Point;
	
	import com.pixeldroid.r_c4d3.game.control.Notifier;
	import com.pixeldroid.r_c4d3.interfaces.IDisposable;
	
	import control.AsteroidsSignals;
	import model.PlayerModel;
	import model.SpriteVO;
	
	
	public class AsteroidsModel implements IDisposable
	{
		
		private var players:Array;
		private var _drift:Point;
		
	
		public function AsteroidsModel()
		{
			C.out(this, "constructor");
		}
		
		
		
		// IDisposable interface
		public function shutDown():Boolean
		{
			C.out(this, "shutDown()");
			players = null;
			
			return true;
		}
		
		public function initialize():Boolean
		{
			C.out(this, "initialize()");
			
			_drift = new Point(0,0);
			players = [];
			var p:PlayerModel;
			for (var i:int = 0; i < 4; i++)
			{
				p = new PlayerModel();
				p.worldEdge = new Point(800, 600); //TODO: get this value from the stage
				p.position = new Point(Math.random()*800, Math.random()*600);
				players.push(p);
			}
			
			return true;
		}
		
		
		
		public function turnLeft(which:int):void { (players[which] as PlayerModel).turnLeft(); }
		public function turnRight(which:int):void { (players[which] as PlayerModel).turnRight(); }
		public function accelerate(which:int):void { (players[which] as PlayerModel).accelerate(); }
		public function decelerate(which:int):void { (players[which] as PlayerModel).decelerate(); }
		public function coast(which:int):void { (players[which] as PlayerModel).coast(); }
		public function fire(which:int):void { (players[which] as PlayerModel).fire(); }
		
		
		
		public function set drift(value:Point):void
		{
			//TODO: environemnt modifiers get applied to all players
			_drift.x = value.x;
			_drift.y = value.y;
		}
		
		public function enablePlayer(index:int, active:Boolean):void
		{
			//TODO: join in support
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
				p.update(dt);
				vo.push(p.toSpriteVO());
				i++;
			}
			
			Notifier.send(AsteroidsSignals.UPDATE_PLAYER_SPRITES, vo);
		}
	}

}
