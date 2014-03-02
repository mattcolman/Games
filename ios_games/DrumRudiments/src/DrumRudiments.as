package
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	[SWF(width="2048", height="1536", backgroundColor="#f5f3db", frameRate = "30")]
	
	public class DrumRudiments extends Sprite
	{	
		private static const STAGE_WIDTH:int = 2048;
		private static const STAGE_HEIGHT:int = 1536;
		private static const Pattern:Object = {
			SINGLES: [0, 1],			
			DOUBLES: [0, 0, 1, 1],
			PARADIDDLES: [0, 1, 0, 0, 1, 0, 1, 1]
		};
		private static const GAME_TIME:int = 60; // 1 minute game
						
		public var firstClick:Boolean = true;
		public var totalCount:int = 0;
		public var currentIndex:int = -1;
		public var pattern:Array;
		public var seconds:int = 0;
		public var bpm:int;
		public var bpmText:TextField;
		public var circles:Array = [];
		
		public function DrumRudiments()
		{			
			pattern = Pattern.PARADIDDLES;			
			addBPMText();
			addCircles();			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _handleClick);
				
		}
		
		
		private function addBPMText():void {
			bpmText = new TextField();
			
			var fm:TextFormat = new TextFormat();
			fm.font="Arial";
			fm.size=30;
			bpmText.text = "0";
			bpmText.x = 20;
			bpmText.y = 20;
			bpmText.defaultTextFormat = fm;
			stage.addChild(bpmText);
		}
		
		private function _handleClick(e:MouseEvent):void {			
			
			var target:int;
			if (e.stageX > STAGE_WIDTH/2) {				
				target = 1;  				
			} else {				
				target = 0;								
			}
			
			if (firstClick) {
				firstClick = false;
				currentIndex = pattern.indexOf(target);
				_startTimer();
			} else {
				currentIndex++;
			}
				
				
			if (pattern[currentIndex % pattern.length] != target) {
				circles[target].incorrect();
				finn();
			} else {
				circles[target].correct();
				totalCount++;
			}
						
		}
		
		private function finn():void {
			trace("finn");
		}
		
		private function _startTimer():void {
			trace("start timer");
			var timer:Timer = new Timer(1000, 0);
			timer.addEventListener(TimerEvent.TIMER, _handleTick);
			timer.start();
		}
		
		private function _handleTick(e:TimerEvent):void {			
			seconds++;
			var percentOfAMinute:Number = seconds/60;
			var strokesPerBeat:int = 2;
			bpm = (totalCount/strokesPerBeat)/percentOfAMinute;
			bpmText.text = bpm.toString();
		}
		
		private function addCircles():void {
			var offset:Number = 400;
			circles.push(_addCircle(STAGE_WIDTH/2 - offset, STAGE_HEIGHT/2));
			circles.push(_addCircle(STAGE_WIDTH/2 + offset, STAGE_HEIGHT/2));
		}
		
		private function _addCircle(x:Number, y:Number):Circle {			
			var circle:Circle = new Circle();
			circle.x = x;
			circle.y = y;
			stage.addChild(circle);
			return circle;
		}
		
	}
}