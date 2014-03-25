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
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
		
	[SWF(width="2048", height="1536", backgroundColor="#ffffff", frameRate = "30")]
	
	public class DrumRudiments extends Sprite
	{	
		private static const STAGE_WIDTH:int = 2048;
		private static const STAGE_HEIGHT:int = 1536;
		private static const Rudiments:Array = [
			[0, 1], // singles			
			[0, 0, 1, 1], // doubles
			[0, 1, 0, 0, 1, 0, 1, 1] // paradiddles
		];
		private static const PatternLengths: Array = [1, 2, 4]		
		private static const RudimentNames:Array = [
			"singles",
			"doubles",
			"paradiddles"
		]
		private static const GAME_TIME:int = 60; // 1 minute game
						
		private var firstClick:Boolean = true;
		private var totalCount:int = 0;
		private var currentIndex:int;
		private var rudiment:Array;
		private var seconds:int = 0;
		private var bpm:int;
		private var bpmText:TextField;
		private var circles:Array = [];
		private var snare1:Sound;
		private var snare2:Sound;
		private var layout:Layout;
		private var rudimentIndex:int;
		private var highlight:MovieClip;
		private var _timer:Timer;		
		private var _tween:TweenMax;
		private var game_so:SharedObject;
		private var rudimentName:String;		
		private var _soundManager:SoundManager;
		private var _volume:Number;
		private var _state:String;
		private var _patternStrings:Array;
		private var _findPattern:String;
		
		public function DrumRudiments()
		{			
			super();
			
			game_so = SharedObject.getLocal("game_so");			
			
			generatePatternStrings();
			addLayout();
			addTimer();			
			addCircles();
			setRudiment(0);
			addButtonListeners();
			addTouchListener();
			
			_soundManager = new SoundManager();			
			_soundManager.play("snare1", 0);
			_soundManager.play("snare2", 0);	
			if (game_so.data.volume != undefined) {
				_setVolume(game_so.data.volume);
			} else {
				_setVolume(1);	
			}			
			
			setSearching();
		}
		
		private function generatePatternStrings():void {
			_patternStrings = [];
			for (var i:int = 0; i < Rudiments.length; i++) {
				var arr:Array = Rudiments[i];
				arr = arr.concat(arr);				
				_patternStrings.push(arr.join(""));
			}
			trace("pattern strings" + _patternStrings);
			
		}
	
		private function _setVolume(volume:Number):void {
			_soundManager.setVolume(volume);
			_volume = volume;
			layout.muteBtn.gotoAndStop(_volume*2+1);
			game_so.data.volume = volume;			
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
			layout.muteBtn.mouseChildren = false;
			layout.muteBtn.addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseDown);			
		}		
		
		private function _handleMouseDown(e:MouseEvent):void {					
			layout.muteBtn.gotoAndStop(_volume*2+2);	
			stage.addEventListener(MouseEvent.MOUSE_UP, _handleMouseUp);
		}
		
		private function _handleMouseUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, _handleMouseUp);
			if (_volume == 0) _volume = 1 else _volume = 0;
			_setVolume(_volume);
			layout.muteBtn.gotoAndStop(_volume*2+1);			
		}
		
		private function _handleButtonClick(e:MouseEvent):void {			
			if (e.target.name == "leftBtn") {				
				nextRudiment(-1);	
			} else if (e.target.name == "rightBtn") {
				nextRudiment(1);	
			} else if (e.target.name == "backBtn") {
				resetTimer();
				setRudiment(rudimentIndex);
				TweenMax.to(e.target.parent, 1, {x:2800, ease:Strong.easeIn});
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
			
			setSearching();
			
			currentIndex = -1;
			highlight = null;
			//highlightStroke();
			
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
			var target:int;
			if (e.stageX > STAGE_WIDTH/2) {
				// right
				target = 1;  			
				_soundManager.play("snare2");
			} else {	
				// left
				target = 0;	
				_soundManager.play("snare1");
			}
			
			if (firstClick) {
				firstClick = false;
				_timer.start();				
				_tween.resume();
			}
			
			if (_state == "searching") {
				_findPattern += target.toString();
				trace("searching" + _findPattern);
				if (_findPattern.length == PatternLengths[rudimentIndex]) {
					var index:int = _patternStrings[rudimentIndex].search(_findPattern);
					if (index != -1) {
						trace("found the pattern!");
						trace("index is" + index + " : find pattern : " + _findPattern);
						trace("target is" + target);
						currentIndex = index+_findPattern.length-1;
						currentIndex = currentIndex%8;
						trace("what is" + 11%8);
						setNormal();
					} else {
						trace("cannot find pattern");
						_findPattern = _findPattern.slice(1);
					}
					
				}				
			} else {
				if (++currentIndex >= 8) currentIndex = 0
			}				
				
			if (rudiment[currentIndex % rudiment.length] != target || _state == "searching") {
				circles[target].incorrect();
				if (_state != "searching") setSearching();
				// TODO - deduct time
			} else {				
				highlightStroke();
				circles[target].correct();
				totalCount++;				
			}
						
		}
		
		private function setSearching():void {
			_findPattern = "";
			_state = "searching";
			var l:int = rudiment.length;
			for (var i:int = 0; i < layout.strokesMc.numChildren; i++) {
				var child:MovieClip = MovieClip(layout.strokesMc.getChildAt(i));				
				child.gotoAndStop(rudiment[i%l]*2+1);
			}
		}
		
		private function setNormal():void {
			_findPattern = "";
			_state = "normal";
			highlight = null;
			var l:int = rudiment.length;
			for (var i:int = 0; i < layout.strokesMc.numChildren; i++) {
				var child:MovieClip = MovieClip(layout.strokesMc.getChildAt(i));				
				child.gotoAndStop(rudiment[i%l]*2+1);
			}
		}
		
		private function finn():void {
			trace("finn");		
			if (game_so.data.highscore == undefined) game_so.data.highscore = {};
			if (game_so.data.highscore[rudimentName] == undefined) game_so.data.highscore[rudimentName] = 0;
			var best:int = game_so.data.highscore[rudimentName];
			if (bpm > best) game_so.data.highscore[rudimentName] = best = bpm;			
			
			_timer.reset();			
			
			var resultsPage:MovieClip = new ResultsPage();
			TweenMax.from(resultsPage, 1, {x:2800, ease:Strong.easeOut});
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
			totalCount = 0;
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