
package
{
	import flash.media.Sound;
	
	
	final public class SoundAssets
	{
		
		[Embed(mimeType="application/x-shockwave-flash", source="pointsIncrease.swf#wav")]
		static private const PointsIncrease:Class;
		
		static public function get pointsIncrease():Sound
		{
			return new PointsIncrease() as Sound;
		}
		
		[Embed(mimeType="application/x-shockwave-flash", source="timeUp.swf#wav")]
		static private const TimeUp:Class;
		
		static public function get timeUp():Sound
		{
			return new TimeUp() as Sound;
		}
		
	}
}
