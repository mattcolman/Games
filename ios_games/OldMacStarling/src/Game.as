package 
{
    import com.greensock.TimelineMax;
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.greensock.easing.Elastic;
    import com.greensock.easing.Quad;
    import com.greensock.easing.Strong;
    
    import flash.media.SoundChannel;
    
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
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
        
        private static var sAssets:AssetManager;
        private var allButtons:Array;
        private var stageWidth:int;
		private var stageHeight:int;
        
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
					Starling.juggler.delayCall(function():void{
						showButtons();
					}, 10)
				}
			});  			
            
        }   
		
		private function showCow():void {
			// The AssetManager contains all the raw asset data, but has not created the textures
			// yet. This takes some time (the assets might be loaded from disk or even via the
			// network), during which we display a progress indicator.
			
			//var cow:MovieClip = new MovieClip(Assets.getAtlas().getTextures("cow_"), 4);			
			var frames:Vector.<Texture> = sAssets.getTextures("anim_cow_");
			var cow:MovieClip = new MovieClip(frames, 4);
			addChild(cow);
			cow.x = stageWidth/2;
			cow.y = stageHeight-100;			
			Starling.juggler.add(cow);
			
			cow.pivotY = 340;
			cow.pivotX = 210;
			cow.scaleY = 2;
			var tl:TimelineMax = new TimelineMax();			
			tl.append(TweenLite.from(cow, .4, {y:-320, ease:Strong.easeIn}))
			tl.append(TweenLite.to(cow, 1, {scaleY:1, ease:Elastic.easeOut}))
									
			var music:SoundChannel = sAssets.playSound("old_mac_cows");
			// add sounds			
			//var stepSound:Sound = Game.assets.getSound("wing_flap");
			//mMovie.setFrameSound(2, stepSound);
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