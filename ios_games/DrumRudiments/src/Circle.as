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
		private var _correctCircle:Sprite;
		private var _incorrectCircle:Sprite;
		private var _currentCircle:Sprite;
		
		public function Circle()
		{	
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_addCircle();			
			_correctCircle = makeCircle(Color.CORRECT);
			this.addChild(_correctCircle);
			_incorrectCircle = makeCircle(Color.INCORRECT);
			this.addChild(_incorrectCircle);
		}
		
		private function _addCircle():Sprite {			
			var circle:CircleMc = new CircleMc();
			circle.cacheAsBitmap = true;
			circle.cacheAsBitmapMatrix = new Matrix();
			this.addChild(circle);				
			return circle;
		}		
		
		private function pulse():void {			
			TweenMax.fromTo(_currentCircle, .4, {alpha:1}, {alpha:0});			
		}
		
		public function correct():void {
			_correctCircle.visible = true;
			_incorrectCircle.visible = false;
			_currentCircle = _correctCircle;
			pulse();
		}
		
		public function incorrect():void {
			_correctCircle.visible = false;
			_incorrectCircle.visible = true;
			_currentCircle = _incorrectCircle;
			pulse();
		}
		
		private function makeCircle(color:uint):Sprite {
			var sprite:Sprite = new Sprite()						
			sprite.graphics.beginFill(color);			
			sprite.graphics.drawCircle(0, 0, RADIUS);
			sprite.graphics.endFill();				
			sprite.cacheAsBitmap = true;
			sprite.cacheAsBitmapMatrix = new Matrix();
			sprite.visible = false;
			return sprite;
		}
	}
}