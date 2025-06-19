package {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;

	/**
	 * LoadingSkeleton - A reusable loading skeleton component for the sidebar
	 * Displays animated placeholder rectangles while content is loading
	 */
	public class LoadingSkeleton extends MovieClip {
		
		private var _skeletonItems:Array;
		private var _animationTimer:Timer;
		private var _isAnimating:Boolean = false;
		private var _width:Number;
		private var _height:Number;
		
		public function LoadingSkeleton(width:Number = 200, height:Number = 300) {
			_width = width;
			_height = height;
			_skeletonItems = [];
			init();
		}
		
		private function init():void {
			createSkeletonItems();
			startAnimation();
		}
		
		/**
		 * Creates the skeleton placeholder items
		 */
		private function createSkeletonItems():void {
			// Create background
			var background:Shape = new Shape();
			background.graphics.beginFill(0xF5F5F5, 0.8);
			background.graphics.drawRoundRect(0, 0, _width, _height, 8, 8);
			background.graphics.endFill();
			addChild(background);
			
			// Create skeleton items with different sizes to simulate content
			var itemConfigs:Array = [
				{width: _width * 0.8, height: 20, y: 20},  // Title placeholder
				{width: _width * 0.6, height: 15, y: 50},  // Subtitle placeholder
				{width: _width * 0.9, height: 60, y: 80},  // Large content block
				{width: _width * 0.7, height: 15, y: 155}, // Text line 1
				{width: _width * 0.8, height: 15, y: 180}, // Text line 2
				{width: _width * 0.5, height: 15, y: 205}, // Text line 3
				{width: _width * 0.9, height: 40, y: 240}  // Button placeholder
			];
			
			for (var i:int = 0; i < itemConfigs.length; i++) {
				var config:Object = itemConfigs[i];
				var skeletonItem:Shape = createSkeletonItem(config.width, config.height);
				skeletonItem.x = (_width - config.width) / 2; // Center horizontally
				skeletonItem.y = config.y;
				addChild(skeletonItem);
				_skeletonItems.push(skeletonItem);
			}
		}
		
		/**
		 * Creates a single skeleton item with rounded corners
		 */
		private function createSkeletonItem(width:Number, height:Number):Shape {
			var item:Shape = new Shape();
			item.graphics.beginFill(0xE0E0E0, 0.7);
			item.graphics.drawRoundRect(0, 0, width, height, 4, 4);
			item.graphics.endFill();
			return item;
		}
		
		/**
		 * Starts the pulsing animation
		 */
		public function startAnimation():void {
			if (_isAnimating) return;
			
			_isAnimating = true;
			
			// Create staggered pulsing animation for each skeleton item
			for (var i:int = 0; i < _skeletonItems.length; i++) {
				var item:Shape = _skeletonItems[i];
				var delay:Number = i * 0.1; // Stagger the animations
				
				TweenMax.to(item, 1.5, {
					alpha: 0.3,
					delay: delay,
					ease: Sine.easeInOut,
					repeat: -1,
					yoyo: true
				});
			}
		}
		
		/**
		 * Stops the animation
		 */
		public function stopAnimation():void {
			if (!_isAnimating) return;
			
			_isAnimating = false;
			
			// Stop all tweens on skeleton items
			for (var i:int = 0; i < _skeletonItems.length; i++) {
				TweenMax.killTweensOf(_skeletonItems[i]);
				_skeletonItems[i].alpha = 1;
			}
		}
		
		/**
		 * Hides the loading skeleton with a fade out animation
		 */
		public function hide():void {
			stopAnimation();
			TweenMax.to(this, 0.5, {
				alpha: 0,
				ease: Sine.easeOut,
				onComplete: function():void {
					if (parent) {
						parent.removeChild(LoadingSkeleton.this);
					}
				}
			});
		}
		
		/**
		 * Shows the loading skeleton with a fade in animation
		 */
		public function show():void {
			this.alpha = 0;
			TweenMax.to(this, 0.5, {
				alpha: 1,
				ease: Sine.easeOut,
				onComplete: startAnimation
			});
		}
		
		/**
		 * Cleanup method
		 */
		public function dispose():void {
			stopAnimation();
			
			// Clean up skeleton items
			for (var i:int = 0; i < _skeletonItems.length; i++) {
				if (_skeletonItems[i].parent) {
					_skeletonItems[i].parent.removeChild(_skeletonItems[i]);
				}
			}
			_skeletonItems = null;
			
			// Remove from parent if still attached
			if (parent) {
				parent.removeChild(this);
			}
		}
	}
}

