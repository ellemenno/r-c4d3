
package
{
	import flash.media.Sound;
	
	
	final public class SoundAssets
	{
		
		[Embed(source="laserFire.swf#wav", mimeType="application/x-shockwave-flash")]
		static private const LaserFire:Class;
		
		static public function get laserFire():Sound
		{
			return new LaserFire() as Sound;
		}
		
		[Embed(source="pointsIncrease.swf#wav", mimeType="application/x-shockwave-flash")]
		static private const PointsIncrease:Class;
		
		static public function get pointsIncrease():Sound
		{
			return new PointsIncrease() as Sound;
		}
		
		[Embed(source="powerUp.swf#wav", mimeType="application/x-shockwave-flash")]
		static private const PowerUp:Class;
		
		static public function get powerUp():Sound
		{
			return new PowerUp() as Sound;
		}
		
		[Embed(source="rockBreak.swf#wav", mimeType="application/x-shockwave-flash")]
		static private const RockBreak:Class;
		
		static public function get rockBreak():Sound
		{
			return new RockBreak() as Sound;
		}
		
		[Embed(source="thrust.swf#wav", mimeType="application/x-shockwave-flash")]
		static private const Thrust:Class;
		
		static public function get thrust():Sound
		{
			return new Thrust() as Sound;
		}
		
		[Embed(source="turn.swf#wav", mimeType="application/x-shockwave-flash")]
		static private const Turn:Class;
		
		static public function get turn():Sound
		{
			return new Turn() as Sound;
		}
		
	}
}
