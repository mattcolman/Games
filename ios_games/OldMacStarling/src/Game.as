package 
{
    import com.greensock.TimelineMax;
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.greensock.easing.Elastic;
    import com.greensock.easing.Strong;
    
    import flash.media.SoundChannel;
    
    import dragonBones.Armature;
    import dragonBones.animation.WorldClock;
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
		
		[Embed(source="../media/cow_dbones/texture.xml", mimeType="application/octet-stream")]
		public static const CowTexture:Class;
		
		[Embed(source="../media/cow_dbones/skeleton.xml", mimeType="application/octet-stream")]
		public static const CowSkeleton:Class;
        
        private static var sAssets:AssetManager;
        private var allButtons:Array;
        private var stageWidth:int;
		private var stageHeight:int;
		private var factory:StarlingFactory;
        
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
            
            addChild(new Image(background));
            
			sAssets.loadQueue(function(ratio:Number):void
			{								
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 			
				if (ratio == 1) {				
					// play a sound and receive the SoundChannel that controls it					
					var music:SoundChannel = sAssets.playSound("old_mac_first_line");					
					Starling.juggler.delayCall(function():void {
						showButtons();
					}, 10);
				}
			});  			
            
        }   
		
		private function showCow():void {
			
			var music:SoundChannel = sAssets.playSound("old_mac_cows");
			
			factory = new StarlingFactory();						
			
			var skeletonData:SkeletonData = XMLDataParser.parseSkeletonData(XML(new CowSkeleton()));
			factory.addSkeletonData(skeletonData);
			
			var texture:Texture = sAssets.getTexture("cow_bones");
			var textureAtlas:StarlingTextureAtlas = new StarlingTextureAtlas(texture, XML(new CowTexture()));
			factory.addTextureAtlas(textureAtlas);		
			
			var armature:Armature = factory.buildArmature("cow_main");			
			var cow:Sprite = armature.display as Sprite;
			cow.x = stageWidth/2;
			cow.y = stageHeight-100;
						
			cow.scaleY = 2;
			var tl:TimelineMax = new TimelineMax();			
			tl.append(TweenLite.from(cow, .4, {y:-320, ease:Strong.easeIn}))
			tl.append(TweenLite.to(cow, 1, {scaleY:1, ease:Elastic.easeOut}))
				
			addChild(cow);			
			WorldClock.clock.add(armature);
			armature.animation.gotoAndPlay("walk");
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
		}
		
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
				button.y = stageHeight/2;
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
			
			if (button.name == 'cow') {
				removeButtons();
				showCow();
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