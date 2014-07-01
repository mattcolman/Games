package 
{
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.greensock.easing.Elastic;
    import com.greensock.easing.Quad;
    
    import flash.display.Stage;
    import flash.media.SoundChannel;
    
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.display.Stage;
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
        
        public function Game()
        {
            // nothing to do here -- Startup will call "start" immediately.
        }
        
        public function start(background:Texture, assets:AssetManager):void
        {
            sAssets = assets;
            
            // The background is passed into this method for two reasons:
            // 
            // 1) we need it right away, otherwise we have an empty frame
            // 2) the Startup class can decide on the right image, depending on the device.
            
            addChild(new Image(background));
            
			sAssets.loadQueue(function(ratio:Number):void
			{				
								
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 			
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						showButtons();
					}, 0.15);
			});            
            
        }   
		
		private function showCow():void {
			// The AssetManager contains all the raw asset data, but has not created the textures
			// yet. This takes some time (the assets might be loaded from disk or even via the
			// network), during which we display a progress indicator.
			
			//var cow:MovieClip = new MovieClip(Assets.getAtlas().getTextures("cow_"), 4);			
			var frames:Vector.<Texture> = sAssets.getTextures("cow_");
			var cow:MovieClip = new MovieClip(frames, 4);
			addChild(cow);
			cow.x = 300;
			cow.y = 300;			
			Starling.juggler.add(cow);
			
			TweenLite.from(cow, 4, {y:0, ease:Quad.easeOut});
			
			
			// play a sound and receive the SoundChannel that controls it						
			var music:SoundChannel = sAssets.playSound("old_mac_first_line");			
			
			// add sounds			
			//var stepSound:Sound = Game.assets.getSound("wing_flap");
			//mMovie.setFrameSound(2, stepSound);
		}
		
		private function showButtons():void {
			var animals:Array = ["chicken", "cow", "pig"]
			var l:int = animals.length;
			for (var i:int = 0; i < l; i++) {				
				var button:Button = new Button(sAssets.getTexture(animals[i]+"_button"));				
				button.pivotX = button.bounds.width/2;
				button.pivotY = button.bounds.height/2;
				button.x = Starling.current.stage.stageWidth/2 + (i-1)*300;
				button.y = Starling.current.stage.stageHeight/2;
				button.name = animals[i];
				addChild(button);
				TweenMax.from(button, 1, {y:Starling.current.stage.stageHeight+300, delay:i*.2, ease:Elastic.easeOut});				
			}
			
			addEventListener(Event.TRIGGERED, onButtonTriggered)
		}
		
		private function onButtonTriggered(e:Event):void {
			var button:Button = e.target as Button;
			trace(button.name);			
		}
		
        public static function get assets():AssetManager { return sAssets; }
    }
}