

package
{
	import com.pixeldroid.r_c4d3.scores.ScoreEvent;
	import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.GameScoresProxy;
	import com.pixeldroid.r_c4d3.scores.LocalGameScoresProxy;
	
	
	[SWF(width="600", height="400", frameRate="1", backgroundColor="#000000")]
    public class LocalGameScoresProxyTest extends GameScoresProxyTest
	{
		
		public function LocalGameScoresProxyTest():void
		{
			super();
		}
		
		override protected function createScoresProxy():IGameScoresProxy
		{
			return new LocalGameScoresProxy("LocalGameScoresProxyTest");
		}
		
		/*
		add store / load calls
		*/
		
	}
}

