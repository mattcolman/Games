package
{
	import com.greensock.TweenMax;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Circle extends Sprite
	{	
		private static const RADIUS:int = 300;
		private static const Color:Object = {
			CORRECT: 0x009394,		
			INCORRECT: 0xff0000
		}
		
		public var pulser:Sprite;
		public var currentColor:uint;
		
		public function Circle()
		{
			_addCircle();
			pulser = _newPulser();
		}
		
		private function _addCircle():Sprite {			
			var circle:Sprite = new Sprite();
			circle.graphics.lineStyle(1, 0x454445);			
			circle.graphics.drawCircle(0, 0, RADIUS);									
			addChild(circle);	
			circle.cacheAsBitmap = true;
			circle.cacheAsBitmapMatrix = new Matrix();
			return circle;
		}
		
		private function _newPulser():Sprite {
			var circle:Sprite = new Sprite();		
			addChild(circle);
			circle.alpha = 0;
			return circle;
		}
		
		private function pulse():void {				
			TweenMax.fromTo(pulser, .4, {alpha:1}, {alpha:0});			
		}
		
		public function correct():void {
			if (currentColor != Color.CORRECT) {
				changeColor(Color.CORRECT);				
			}
			pulse();
		}
		
		public function incorrect():void {
			if (currentColor != Color.INCORRECT) {
				changeColor(Color.INCORRECT);				
			}
			pulse();
		}
		
		private function changeColor(color:uint):void {
			currentColor = color;
			pulser.graphics.clear();
			pulser.graphics.beginFill(color);			
			pulser.graphics.drawCircle(0, 0, RADIUS);
			pulser.graphics.endFill();				
			pulser.cacheAsBitmap = true;
			pulser.cacheAsBitmapMatrix = new Matrix();			
		}
	}
}