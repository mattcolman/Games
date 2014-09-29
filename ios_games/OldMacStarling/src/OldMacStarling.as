package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
	
	[SWF(frameRate="60", width="1024", height="768", backgroundColor="0x333333")]
	public class OldMacStarling extends Sprite
	{
		
		private var stats:Stats;
		private var myStarling:Starling;
		
		// Startup image for HD screens
		[Embed(source="/startup.png")]
		private static var LoadingImage:Class;
		
		private var mStarling:Starling;
		
		public function OldMacStarling()
		{			
			
			// These settings are recommended to avoid problems with touch handling			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var stageWidth:int  = 1024;
			var stageHeight:int = 768;			
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;			
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
						
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL, iOS);
			
			var scaleFactor:int = viewPort.width < 1536 ? 1 : 1; // midway between 1024 and 2048
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = new AssetManager(scaleFactor);
			
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(
				appDir.resolvePath("audio"),				
				appDir.resolvePath(formatString("fonts/{0}x", scaleFactor)),
				appDir.resolvePath(formatString("textures/{0}x", scaleFactor))
			);
			//assets.enqueue(Assets);
			
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			// This is especially useful on iOS, where "Default.png" (or a variant) is displayed
			// during Startup. You can create an absolute seamless startup that way.
			// 
			// These are the only embedded graphics in this app. We can't load them from disk,
			// because that can only be done asynchronously - i.e. flickering would return.
			// 
			// Note that we cannot embed "Default.png" (or its siblings), because any embedded
			// files will vanish from the application package, and those are picked up by the OS!
			
			
			var loadingClass:Class = scaleFactor == 1 ? LoadingImage : LoadingImage;			
			var background:Bitmap = new loadingClass();
			LoadingImage = null; // no longer needed!
			
			background.x = viewPort.x;
			background.y = viewPort.y;
			background.width  = viewPort.width;
			background.height = viewPort.height;
			background.smoothing = true;
			addChild(background);
			
			// launch Starling
						
			mStarling = new Starling(Game, stage, viewPort);
			mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
			mStarling.antiAliasing = 1;
			mStarling.simulateMultitouch  = false;
			mStarling.enableErrorChecking = false;
				
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				trace("remove the background");
				removeChild(background);
				background = null;
								
				var game:Game = mStarling.root as Game;				
				var bgTexture:Texture = Texture.fromEmbeddedAsset(loadingClass,
					false, false, scaleFactor); 
				game.start(bgTexture, assets);	
				
				// add stats
				stats = new Stats();
				addChild(stats);
				
				mStarling.start();
			});
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop(true); });

		}
	}
}