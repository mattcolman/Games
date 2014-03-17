package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
		
	[SWF(width="2048", height="1536", backgroundColor="#f5f3db", frameRate = "30")]
	
	public class DrumRudiments extends Sprite
	{	
		private static const STAGE_WIDTH:int = 2048;
		private static const STAGE_HEIGHT:int = 1536;
		private static const Rudiments:Array = [
			[0, 1], // singles			
			[0, 0, 1, 1], // doubles
			[0, 1, 0, 0, 1, 0, 1, 1] // paradiddles
		];
		private static const RudimentNames:Array = [
			"singles",
			"doubles",
			"paradiddles"
		]
		private static const GAME_TIME:int = 60; // 1 minute game
						
		public var firstClick:Boolean = true;
		public var totalCount:int = 0;
		public var currentIndex:int;
		public var rudiment:Array;
		public var seconds:int = 0;
		public var bpm:int;
		public var bpmText:TextField;
		public var circles:Array = [];
		public var snare1:Sound;
		public var snare2:Sound;
		public var layout:Layout;
		public var rudimentIndex:int;
		public var highlight:MovieClip;
		public var _timer:Timer;		
		public var _tween:TweenMax;
		public var score_so:SharedObject;
		public var rudimentName:String;
		
		public function DrumRudiments()
		{			
			super();
			
			score_so = SharedObject.getLocal("high_scores");			
			
			addLayout();
			addTimer();			
			addCircles();
			setRudiment(0);
			addButtonListeners();
			addTouchListener();
						
			snare1 = new Snare1();
			snare2 = new Snare2();						
		}
		
		private function addTouchListener():void {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			if (Multitouch.supportsTouchEvents) {
				layout.bg.addEventListener(TouchEvent.TOUCH_BEGIN, _handleTouch);
			} else {
				layout.bg.addEventListener(MouseEvent.MOUSE_DOWN, _handleTouch);
			}
		}
		
		private function addButtonListeners():void {
			layout.leftBtn.addEventListener(MouseEvent.CLICK, _handleButtonClick);
			layout.rightBtn.addEventListener(MouseEvent.CLICK, _handleButtonClick);
		}		
		
		private function _handleButtonClick(e:MouseEvent):void {			
			if (e.target.name == "leftBtn") {				
				nextRudiment(-1);	
			} else if (e.target.name == "rightBtn") {
				nextRudiment(1);	
			} else if (e.target.name == "backBtn") {
				resetTimer();
				setRudiment(rudimentIndex);
				TweenMax.to(e.target.parent, 1, {x:2048, ease:Strong.easeIn});
			} else {
				trace("I don't know this button :(");
			}
		}		
		
		private function nextRudiment(direction:int):void {
			rudimentIndex += direction;
			if (rudimentIndex < 0) {
				rudimentIndex = Rudiments.length-1;
			} else if (rudimentIndex >= Rudiments.length) {
				rudimentIndex = 0;
			}
			setRudiment(rudimentIndex);
		}
		
		private function setRudiment(index:int):void {
			rudimentIndex = index;
			rudimentName = RudimentNames[rudimentIndex];
			rudiment = Rudiments[index];
			
			layout.rudiments.gotoAndStop(index+1);
			
			var l:int = rudiment.length;
			for (var i:int = 0; i < layout.strokesMc.numChildren; i++) {
				var child:MovieClip = MovieClip(layout.strokesMc.getChildAt(i));				
				child.gotoAndStop(rudiment[i%l]*2+1);
			}
			
			currentIndex = -1;
			highlight = null;
			highlightStroke();
			
			resetTimer();
		}
		
		private function highlightStroke():void {
			var i:int = currentIndex+1;
			if (i >= 8) i = 0;
			if (highlight) highlight.gotoAndStop(highlight.currentFrame-1);
			var l:int = rudiment.length;
			highlight = MovieClip(layout.strokesMc.getChildAt(i));
			highlight.gotoAndStop(rudiment[(i)%l]*2+2);
		}
		
		private function addLayout():void {
			layout = new Layout();
			stage.addChild(layout);
			// reference the bpm text
			bpmText = layout.textMc.txt;
			bpmText.text = "0";
		}
				
		
		private function _handleTouch(e:*):void {	
			trace('touch' + e.stageX);
			var target:int;
			if (e.stageX > STAGE_WIDTH/2) {
				// right
				target = 1;  
				snare2.play();
			} else {	
				// left
				target = 0;	
				snare1.play();
			}
			
			if (firstClick) {
				firstClick = false;
				currentIndex = rudiment.indexOf(target);
				_timer.start();				
				_tween.resume();
			} else {
				if (++currentIndex >= 8) currentIndex = 0
			}				
				
			if (rudiment[currentIndex % rudiment.length] != target) {
				circles[target].incorrect();
				// TODO - deduct time
			} else {
				highlightStroke();
				circles[target].correct();
				totalCount++;
			}
						
		}
		
		private function finn():void {
			trace("finn");		
			var best:int = score_so.data[rudimentName];
			if (bpm > best) score_so.data[rudimentName] = best = bpm;			
			
			_timer.reset();			
			
			var resultsPage:MovieClip = new ResultsPage();
			TweenMax.from(resultsPage, 1, {x:2048, ease:Strong.easeOut});
			stage.addChild(resultsPage);
			
			resultsPage.mainTxt.text = resultsPage.mainTxt.text.replace("**", rudimentName);			
			resultsPage.bubbleMc.txt.text = bpm;		
			resultsPage.bestTxt.text = resultsPage.bestTxt.text.replace("**", best);		
			resultsPage.backBtn.addEventListener(MouseEvent.CLICK, _handleButtonClick);
		}
		
		private function addTimer():void {
			_timer = new Timer(1000, 0);
			_timer.addEventListener(TimerEvent.TIMER, _handleTick);
			layout.barMc.scaleX = 0;
			_tween = TweenMax.to(layout.barMc, GAME_TIME, {scaleX:1, ease:Linear.easeNone, onComplete: finn})
			_tween.pause();			
		}
		
		private function resetTimer():void {
			_timer.reset();
			_tween.restart();
			_tween.pause();
			layout.barMc.scaleX = 0;
			bpmText.text = "0";
			seconds = 0;
			firstClick = true;
		}
	
		
		private function _handleTick(e:TimerEvent):void {			
			seconds++;
			var percentOfAMinute:Number = seconds/GAME_TIME;
			var strokesPerBeat:int = 2;
			bpm = (totalCount/strokesPerBeat)/percentOfAMinute;
			bpmText.text = bpm.toString();			
		}		
		
		private function addCircles():void {
			var offset:Number = 400;
			circles.push(_addCircle(stage, STAGE_WIDTH/2 - offset, STAGE_HEIGHT/2 + 140));
			circles.push(_addCircle(stage, STAGE_WIDTH/2 + offset, STAGE_HEIGHT/2 + 140));
		}
		
		private function _addCircle(parent:DisplayObjectContainer, x:Number, y:Number):Circle {			
			var circle:Circle = new Circle();
			circle.x = x;
			circle.y = y;
			parent.addChild(circle);
			return circle;
		}
		
	}
}