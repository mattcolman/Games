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
        private static var sAssets:AssetManager;
        private var allButtons:Array;
        private var stageWidth:int;
		private var stageHeight:int;
		private var factory:StarlingFactory;
		private var oldmacArmature:Armature;
		private var backgroundImage:Image;
		private static const AnimalData:Object = {
			cow: {x: 290, y: 470, width:160},
			chicken: {x: 835, y: 350, width:88},
			pig: {x: 750, y: 720, width:210}
		}
        
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
					firstLine();
					//showAnimal('cow');
				}
			});  			
        }   
		
		private function makeBackground():void
		{
			removeChild(backgroundImage);
			backgroundImage = null;
			var back:Image = new Image(sAssets.getTexture("background43"));
			addChild(back);
		}
		
		private function showOldMac():void {
			factory = new StarlingFactory();		
						
			var xml:XML = sAssets.getXml("oldmac_skeleton");
			var skeletonData:SkeletonData = XMLDataParser.parseSkeletonData(xml);
			factory.addSkeletonData(skeletonData, "oldmac_skel");
			
			var texture:Texture = sAssets.getTexture("oldmac");			
			var textureAtlas:TextureAtlas = sAssets.getTextureAtlas("oldmac");
			
			factory.addTextureAtlas(textureAtlas, "oldmac_skel");
			
			oldmacArmature = factory.buildArmature("oldmac_main");						
			oldmacArmature.addEventListener(AnimationEvent.COMPLETE, onComplete);
			
			var oldmac:Sprite = oldmacArmature.display as Sprite;
			oldmac.x = 450;
			oldmac.y = 500;
			oldmac.scaleX = oldmac.scaleY = .5
			
			addChild(oldmac);			
			
			WorldClock.clock.add(oldmacArmature);			
						
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function firstLine():void {
			oldmacArmature.animation.gotoAndPlay("dance1");
			var music:SoundChannel = sAssets.playSound("old_mac_first_line");
		}
		
		private function onEnterFrameHandler():void
		{
			WorldClock.clock.advanceTime(-1);			
		}
		
		private function onComplete(e:AnimationEvent):void {
			trace("COMPLETE");
			if (e.movementID == "dance1") {
				showButtons();
			}
		}
		
		private function showAnimal(type):void {
			
			var music:SoundChannel = sAssets.playSound("song_"+type);
			music.addEventListener(flash.events.Event.SOUND_COMPLETE, soundComplete);
			var d:Object = AnimalData[type];
			var animal:Image = new Image(sAssets.getTexture(type));
			animal.pivotX = animal.width/2
			animal.pivotY = animal.height			
			animal.scaleX = d.width/animal.width
			animal.x = d.x;
			animal.y = d.y;
			
			animal.scaleY = animal.scaleX*2;
			var tl:TimelineMax = new TimelineMax();			
			tl.append(TweenLite.from(animal, .4, {y:-100, ease:Strong.easeIn}))
			tl.append(TweenLite.to(animal, 1, {scaleY:animal.scaleX, ease:Elastic.easeOut}))
				
			addChild(animal);
								
		}		
		
		protected function soundComplete(event:flash.events.Event):void
		{
			event.target.removeEventListener(flash.events.Event.SOUND_COMPLETE, soundComplete);
			firstLine();
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
			removeButtons();
			showAnimal(button.name);			
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