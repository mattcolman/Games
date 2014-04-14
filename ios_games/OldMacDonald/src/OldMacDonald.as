package
{
	import com.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.events.*;
	import com.greensock.loading.*;
	import com.greensock.plugins.*;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	[SWF(width="2048", height="1536", backgroundColor="#FFFFFF", frameRate = "30")]
	//[SWF(width="1024", height="768", backgroundColor="#FFFFFF", frameRate = "30")]
	
	public class OldMacDonald extends BaseActivity
	{		
		
		private var imageLoader:Loader;
		private var _curScreenMC: MovieClip;
		
		
		public function OldMacDonald()
		{
			trace('start old mac game');
			init();
		}
		
		override public function init():void {
			super.init();
			_curScreenMC = new MovieClip();
			stage.addChild(_curScreenMC);	
			
			var title:MovieClip = new TitleScreen();
			_curScreenMC.addChild(title);
			
			title.startBtn.addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function handleClick(e:MouseEvent):void {
			_curScreenMC.removeChild(e.target.parent);
			var main:MovieClip = new MainScreen();
			_curScreenMC.addChild(main);
		}
		
	}
}