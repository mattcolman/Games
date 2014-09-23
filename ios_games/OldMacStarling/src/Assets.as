package
{
	public class Assets
	{
		// images
		[Embed(source="../media/images/background.png")]
		public static const Background:Class;
		
		// animations
		[Embed(source="../media/animations/anim_cow.png")]
		public static const anim_cow:Class;
		
		[Embed(source="../media/animations/anim_cow.xml", mimeType="application/octet-stream")]
		public static const anim_cowxml:Class;
		
		[Embed(source="../media/animations/buttons.png")]
		public static const buttons:Class;
		
		[Embed(source="../media/animations/buttons.xml", mimeType="application/octet-stream")]
		public static const buttonsxml:Class;
		
		
		// sounds
		[Embed(source="../media/audio/old_mac_first_line.mp3")]
		public static const old_mac_first_line:Class;
		
		[Embed(source="../media/audio/old_mac_cows.mp3")]
		public static const old_mac_cows:Class;
		
		// dragon bones
		[Embed(source="../media/cow_dbones/cow_dbones.png")]
		public static const cow_bones:Class;
		
		[Embed(source="../media/oldmac/oldmac.png")]
		public static const oldmac:Class;
				
		
	}
}