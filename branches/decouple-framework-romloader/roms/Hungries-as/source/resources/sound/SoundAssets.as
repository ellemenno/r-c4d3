
package
{
	import flash.media.Sound;
	
	
	final public class SoundAssets
	{
		
		[Embed(source="pointsIncrease.swf#wav", mimeType="application/x-shockwave-flash")]
		static private const PointsIncrease:Class;
		
		static public function get pointsIncrease():Sound
		{
			return new PointsIncrease() as Sound;
		}
		
	}
}
