package
{
	public class Assets
	{
		[Embed(source="../media/images/background.png")]
		public static const Background:Class;
		
		[Embed(source="../media/animations/cow.png")]
		public static const cow:Class;
		
		[Embed(source="../media/animations/cow.xml", mimeType="application/octet-stream")]
		public static const cowxml:Class;
		
		// sounds
		[Embed(source="../media/audio/old_mac_first_line.mp3")]
		public static const old_mac_first_line:Class;
		
	}
}