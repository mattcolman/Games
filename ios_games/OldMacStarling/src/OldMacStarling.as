package
{
	import flash.display.Sprite;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", width="1366", height="768", backgroundColor="0x333333")]
	public class OldMacStarling extends Sprite
	{
		
		private var stats:Stats;
		private var myStarling:Starling;
		
		public function OldMacStarling()
		{
			stats = new Stats();
			this.addChild(stats);
			
			myStarling = new Starling(Game, stage);
			myStarling.antiAliasing = 1;
			myStarling.start();
		}
	}
}