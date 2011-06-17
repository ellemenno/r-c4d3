
package com.pixeldroid.r_c4d3
{
	import com.pixeldroid.r_c4d3.scores.GameIdValidation;
	import com.pixeldroid.r_c4d3.scores.LocalScores;
	import com.pixeldroid.r_c4d3.scores.RemoteScores;
	import com.pixeldroid.r_c4d3.scores.ScoreInsertion;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class FrameworkSuite
	{
		public var gameIdValidation:GameIdValidation;
		public var scoreInsertion:ScoreInsertion;
		public var localScores:LocalScores;
		public var remoteScores:RemoteScores;
	}
}
