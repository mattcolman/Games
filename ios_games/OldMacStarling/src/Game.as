package 
{
    import com.greensock.TimelineMax;
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.greensock.easing.Elastic;
    import com.greensock.easing.Strong;
    
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.media.SoundChannel;
    
    import dragonBones.Armature;
    import dragonBones.Bone;
    import dragonBones.animation.WorldClock;
    import dragonBones.events.AnimationEvent;
    import dragonBones.factorys.StarlingFactory;
    import dragonBones.objects.SkeletonData;
    import dragonBones.objects.XMLDataParser;
    import dragonBones.textures.StarlingTextureAtlas;
    
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.utils.AssetManager;
	
	
       

    public class Game extends Sprite
    {
        // Embed the Ubuntu Font. Beware: the 'embedAsCFF'-part IS REQUIRED!!!
        //[Embed(source="../../demo/assets/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]
        //private static const UbuntuRegular:Class;
        
        //private var mLoadingProgress:ProgressBar;
        //private var mMainMenu:MainMenu;
        //private var mCurrentScene:Scene;
        //private var _container:Sprite;		
		
//		[Embed(source="../media/cow_dbones/texture.xml", mimeType="application/octet-stream")]
//		public static const CowTexture:Class;
//		
//		[Embed(source="../media/cow_dbones/skeleton.xml", mimeType="application/octet-stream")]
//		public static const CowSkeleton:Class;
//		
//		[Embed(source="../media/oldmac/texture.xml", mimeType="application/octet-stream")]
//		public static const OldMacTexture:Class;
//		
//		[Embed(source="../media/oldmac/skeleton.xml", mimeType="application/octet-stream")]
//		public static const OldMacSkeleton:Class;
        
        private static var sAssets:AssetManager;
        private var allButtons:Array;
        private var stageWidth:int;
		private var stageHeight:int;
		private var factory:StarlingFactory;
		private var oldmacArmature:Armature;
		private var backgroundImage:Image;
        
        public function Game()
        {
            // nothing to do here -- Startup will call "start" immediately.
        }
        
        public function start(background:Texture, assets:AssetManager):void
        {
            sAssets = assets;
			stageWidth = Starling.current.stage.stageWidth;
			stageHeight = Starling.current.stage.stageHeight;
            
            // The background is passed into this method for two reasons:
            // 
            // 1) we need it right away, otherwise we have an empty frame
            // 2) the Startup class can decide on the right image, depending on the device.
            backgroundImage = new Image(background); 
            addChild(backgroundImage);
            
			sAssets.loadQueue(function(ratio:Number):void
			{								
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 			
				if (ratio == 1) {				
					// play a sound and receive the SoundChannel that controls it					
//					Starling.juggler.delayCall(function():void {
//						showButtons();
//					}, 1);
					makeBackground();		
					showOldMac();
					//showCow();
				}
			});  			
        }   
		
		private function makeBackground():void
		{
			removeChild(backgroundImage);
			backgroundImage = null;
			var back:Image = new Image(sAssets.getTexture("background_4_3"));
			addChild(back);
		}
		
		private function showOldMac():void {
			factory = new StarlingFactory();		
			
			//trace("hi there", sAssets.getXml("oldmac_skeleton"));			
			var xml:XML = sAssets.getXml("oldmac_skeleton");
			var skeletonData:SkeletonData = XMLDataParser.parseSkeletonData(xml);
			factory.addSkeletonData(skeletonData, "oldmac_skel");
			
			var texture:Texture = sAssets.getTexture("oldmac");			
			var textureAtlas:TextureAtlas = sAssets.getTextureAtlas("oldmac");
			
			//var textureAtlas2:StarlingTextureAtlas = new StarlingTextureAtlas(
			//	texture,
			//	XML(sAssets.getXml("oldmac"))	
			//)				
			
			factory.addTextureAtlas(textureAtlas, "oldmac_skel");
			
			oldmacArmature = factory.buildArmature("oldmac_main");						
			oldmacArmature.addEventListener(AnimationEvent.COMPLETE, onComplete);
			
			var oldmac:Sprite = oldmacArmature.display as Sprite;
			oldmac.x = 450;
			oldmac.y = 500;
			oldmac.scaleX = oldmac.scaleY = .5
			
			addChild(oldmac);			
			
			WorldClock.clock.add(oldmacArmature);			
			oldmacArmature.animation.gotoAndPlay("dance1");			
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
			
			var music:SoundChannel = sAssets.playSound("old_mac_first_line");		
		}
		
		private function onComplete(e:AnimationEvent):void {
			trace("COMPLETE");
			if (e.movementID == "dance1") {
				showButtons();
			}
		}
		
//		private function showCow():void {
//			
//			var music:SoundChannel = sAssets.playSound("old_mac_cows");
//			
//			factory = new StarlingFactory();						
//			
//			var skeletonData:SkeletonData = XMLDataParser.parseSkeletonData(XML(new CowSkeleton()));
//			factory.addSkeletonData(skeletonData);
//			
//			var texture:Texture = sAssets.getTexture("cow_bones");
//			var textureAtlas:StarlingTextureAtlas = new StarlingTextureAtlas(texture, XML(new CowTexture()));
//			factory.addTextureAtlas(textureAtlas);		
//			
//			//var eyesArmature:Armature = factory.buildArmature("eyes_blue");
//			//var eyes:Sprite = eyesArmature.display as Sprite;
//			//eyes.x = stageWidth/2;			
//			//eyes.y = 300;			
//			//addChild(eyes);
//			
//			var armature:Armature = factory.buildArmature("cow_main");			
//			var cow:Sprite = armature.display as Sprite;
//			cow.x = stageWidth/2+300;
//			cow.y = stageHeight-100;
//			cow.scaleX = cow.scaleY = .6
//						
//			cow.scaleY = 2;
//			var tl:TimelineMax = new TimelineMax();			
//			tl.append(TweenLite.from(cow, .4, {y:-320, ease:Strong.easeIn}))
//			tl.append(TweenLite.to(cow, 1, {scaleY:.6, ease:Elastic.easeOut}))
//				
//			addChild(cow);
//			
//			//var _bone:Bone = armature.getBone("eyes_new"); 
//			//_bone.display.dispose();
//			//_bone.display = eyes;
//			//eyesArmature.animation.gotoAndPlay("blink");
//			
//			WorldClock.clock.add(armature);
//			//WorldClock.clock.add(eyesArmature);
//			armature.animation.gotoAndPlay("walk");			
//			//eyesArmature.animation.gotoAndPlay("blink");
//			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
//		}
		
		private function onEnterFrameHandler(e:EnterFrameEvent):void
		{
			WorldClock.clock.advanceTime(-1);
		}	
			
		
		private function showButtons():void {
			var animals:Array = ["chicken", "cow", "pig"]
			var l:int = animals.length;
			allButtons = [];
			for (var i:int = 0; i < l; i++) {				
				var button:Button = new Button(sAssets.getTexture(animals[i]+"_button"));				
				button.pivotX = 110;
				button.pivotY = 110;
				button.x = stageWidth/2 + (i-1)*300;
				button.y = stageHeight/2-200;
				button.name = animals[i];
				addChild(button);
				TweenMax.from(button, 1, {y:stageHeight+300, delay:i*.2, ease:Elastic.easeOut});
				allButtons.push(button);
			}
			
			addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered)
		}
		
		private function onButtonTriggered(e:starling.events.Event):void {
			var button:Button = e.target as Button;
			trace(button.name);
			oldmacArmature.animation.gotoAndPlay("dance2");
			if (button.name == 'cow') {
				removeButtons();
				//showCow();
			}
		}
		
		private function removeButtons():void
		{
			for (var i:int; i < allButtons.length; i++) {
				removeChild(allButtons[i]);
			}
			
		}
		
        public static function get assets():AssetManager { return sAssets; }
    }
}