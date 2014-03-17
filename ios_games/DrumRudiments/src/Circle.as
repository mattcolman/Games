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
		public var outerCircle:Sprite;
		public var currentColor:uint;
		
		public function Circle()
		{	
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_addCircle();
			pulser = _newPulser();			
		}
		
		private function _addCircle():Sprite {			
			var circle:CircleMc = new CircleMc();											
			addChild(circle);	
			circle.cacheAsBitmap = true;
			circle.cacheAsBitmapMatrix = new Matrix();
			return circle;
		}
		
		private function _newPulser():Sprite {
			var circle:Sprite = new Sprite();					
			outerCircle = new Sprite();
			outerCircle.addChild(circle);
			outerCircle.alpha = 0;
			this.addChild(outerCircle);			
			return circle;
		}
		
		private function pulse():void {			
			TweenMax.fromTo(outerCircle, .4, {alpha:1}, {alpha:0});			
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