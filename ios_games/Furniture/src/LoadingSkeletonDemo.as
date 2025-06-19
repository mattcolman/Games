package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.greensock.TweenMax;

	/**
	 * LoadingSkeletonDemo - Demonstrates the LoadingSkeleton component usage
	 * This class shows how to integrate and use the LoadingSkeleton in different scenarios
	 */
	public class LoadingSkeletonDemo extends MovieClip {
		
		private var _skeleton1:LoadingSkeleton;
		private var _skeleton2:LoadingSkeleton;
		private var _skeleton3:LoadingSkeleton;
		private var _demoTimer:Timer;
		
		public function LoadingSkeletonDemo() {
			init();
		}
		
		private function init():void {
			// Create demo background
			graphics.beginFill(0xF0F0F0);
			graphics.drawRect(0, 0, 1024, 768);
			graphics.endFill();
			
			// Create title
			var title:MovieClip = createTextBox("Loading Skeleton Demo", 0x333333);
			title.x = 50;
			title.y = 20;
			addChild(title);
			
			// Demo 1: Sidebar Loading Skeleton
			createDemo1();
			
			// Demo 2: Card Loading Skeleton
			createDemo2();
			
			// Demo 3: List Loading Skeleton
			createDemo3();
			
			// Start demo cycle
			startDemoTimer();
		}
		
		/**
		 * Demo 1: Sidebar-style loading skeleton (tall and narrow)
		 */
		private function createDemo1():void {
			var label:MovieClip = createTextBox("Sidebar Loading:", 0x666666);
			label.x = 50;
			label.y = 80;
			addChild(label);
			
			_skeleton1 = new LoadingSkeleton(250, 400);
			_skeleton1.x = 50;
			_skeleton1.y = 110;
			addChild(_skeleton1);
		}
		
		/**
		 * Demo 2: Card-style loading skeleton (square-ish)
		 */
		private function createDemo2():void {
			var label:MovieClip = createTextBox("Card Loading:", 0x666666);
			label.x = 350;
			label.y = 80;
			addChild(label);
			
			_skeleton2 = new LoadingSkeleton(300, 250);
			_skeleton2.x = 350;
			_skeleton2.y = 110;
			addChild(_skeleton2);
		}
		
		/**
		 * Demo 3: Compact loading skeleton (wide and short)
		 */
		private function createDemo3():void {
			var label:MovieClip = createTextBox("Compact Loading:", 0x666666);
			label.x = 700;
			label.y = 80;
			addChild(label);
			
			_skeleton3 = new LoadingSkeleton(280, 180);
			_skeleton3.x = 700;
			_skeleton3.y = 110;
			addChild(_skeleton3);
		}
		
		/**
		 * Creates a simple text display (placeholder for actual text component)
		 */
		private function createTextBox(text:String, color:uint):MovieClip {
			var textBox:MovieClip = new MovieClip();
			textBox.graphics.beginFill(color);
			textBox.graphics.drawRect(0, 0, text.length * 8, 20);
			textBox.graphics.endFill();
			return textBox;
		}
		
		/**
		 * Starts a timer to demonstrate show/hide functionality
		 */
		private function startDemoTimer():void {
			_demoTimer = new Timer(5000); // 5 seconds
			_demoTimer.addEventListener(TimerEvent.TIMER, onDemoTimer);
			_demoTimer.start();
		}
		
		/**
		 * Demo timer handler - cycles through show/hide states
		 */
		private function onDemoTimer(event:TimerEvent):void {
			// Randomly show/hide skeletons to demonstrate functionality
			if (Math.random() > 0.5) {
				if (_skeleton1) _skeleton1.hide();
				TweenMax.delayedCall(1, function():void {
					_skeleton1 = new LoadingSkeleton(250, 400);
					_skeleton1.x = 50;
					_skeleton1.y = 110;
					addChild(_skeleton1);
				});
			}
			
			if (Math.random() > 0.5) {
				if (_skeleton2) _skeleton2.stopAnimation();
				TweenMax.delayedCall(0.5, function():void {
					if (_skeleton2) _skeleton2.startAnimation();
				});
			}
		}
		
		/**
		 * Cleanup method
		 */
		public function dispose():void {
			if (_demoTimer) {
				_demoTimer.stop();
				_demoTimer.removeEventListener(TimerEvent.TIMER, onDemoTimer);
				_demoTimer = null;
			}
			
			if (_skeleton1) {
				_skeleton1.dispose();
				_skeleton1 = null;
			}
			
			if (_skeleton2) {
				_skeleton2.dispose();
				_skeleton2 = null;
			}
			
			if (_skeleton3) {
				_skeleton3.dispose();
				_skeleton3 = null;
			}
		}
	}
}

