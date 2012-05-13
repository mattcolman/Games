package com
{
	import com.fizzy.animation.FizTween;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Matt Colman
	 */
	
	public class FurnitureBrowser extends Sprite
	{
		public var previousButton:SimpleButton;
		public var cancelButton:SimpleButton;
		public var nextButton:SimpleButton;
		
		private var view:Sprite;
		private var page:int = 0;
		private var pages:Sprite;
		private var furniture:Array;
		private var _selection:Object = null;
		private var highlightGlow:Array = [new GlowFilter(0xFFCA1A, 1, 6, 6, 8)];
		private var _scope:*;
		public var curLoader:Object = new Object;
		private var loadingQueue:LoaderMax;
		
		public function FurnitureBrowser() 
		{
			loadingQueue = new LoaderMax({name:"mainQueue"});
		}
		
		public function get selection():Object { return _selection; }
		
		public function initialize(scope:*, inventory:Array):void
		{
			trace('initialize');
			_scope = scope;
			
			var px:Number = 0;
			var py:Number = 0;
			var pageHolder:Sprite = null;
			
			this.pages = new Sprite();
			this.pages.x = - (this.width / 2);
			this.pages.y = - (this.height / 2);
			this.pages.scrollRect = new Rectangle(-25, -10, this.width, this.height);
			this.addChild(this.pages);
			this.furniture = new Array();
			
			for (var i:uint = 0; i < inventory.length; i++)
			{
				if ( inventory[i].asset )
				{
					var asset:* = inventory[i].asset;
					var container:MovieClip = new FurnitureBox();
					container.x = px;
					container.y = py;
					container.buttonMode = true;
					container.mouseChildren = false;
					container.data = inventory[i];
					//container.addChild(asset);
					container.addEventListener( MouseEvent.MOUSE_OVER, this.hoverHandler, false, 0, true );
					container.addEventListener( MouseEvent.MOUSE_OUT, this.hoverHandler, false, 0, true );
					container.addEventListener( MouseEvent.CLICK, this.clickHandler, false, 0, true );
					
					var imgLoader:ImageLoader = new ImageLoader(asset, {name:asset, container:container, estimatedBytes:20000, autoDispose: false, noCache:false, onProgress:indProgressHandler, onComplete:indCompleteHandler});
					inventory[i].asset = imgLoader;
					imgLoader.load();
					
					if ( !pageHolder )
					{
						pageHolder = new Sprite();
						if ( this.pages.numChildren )
						{
							pageHolder.x = 640;
							pageHolder.alpha = 0;
							pageHolder.visible = false;
						}
					}
					
					pageHolder.addChild(container);
					this.furniture.push(imgLoader.content);
					
					
					if ( this.furniture.length % 18 == 0 )
					{
						this.pages.addChild(pageHolder);
						px = 0;
						py = 0;
						pageHolder = null;
					}
					else if ( this.furniture.length % 6 == 0 )
					{
						px = 0;
						py += 100;
					}
					else px += 100;
				}
			}
			
			if ( pageHolder ) this.pages.addChild(pageHolder);
			
			this.previousButton.visible = false;
			this.cancelButton.addEventListener(MouseEvent.CLICK, this.clickHandler);
			
			if ( this.furniture.length <= 18 ) this.nextButton.visible = false;
			else
			{
				this.nextButton.addEventListener(MouseEvent.CLICK, this.clickHandler);
				this.previousButton.addEventListener(MouseEvent.CLICK, this.clickHandler);
			}
			
			TweenMax.from(this, 1, {y:"600", ease:Strong.easeOut});
		}
		
		private function indProgressHandler(e:LoaderEvent):void{
			curLoader = Object(e.target);
		}
		
		private function indCompleteHandler(e:LoaderEvent):void {
			curLoader = Object(e.target);
			trace("ContentLoader: Finished loading " + curLoader);
			var target:* = e.target;
			
			var asset:Bitmap = e.target.rawContent;
			var sx:Number = 80 / asset.width;
			var sy:Number = 80 / asset.height;
			asset.scaleX = asset.scaleY = sx < sy ? sx : sy;
			asset.x = (80 - asset.width) / 2;
			asset.y = (80 - asset.height) / 2;
		}
		
		private function dispose():void
		{
			if ( !this.furniture ) return;
			
			for each(var asset:Sprite in this.furniture)
			{
				asset.scaleX = asset.scaleY = 1;
				if ( asset.parent )
				{
					asset.parent.removeEventListener(MouseEvent.MOUSE_OVER, this.hoverHandler);
					asset.parent.removeEventListener(MouseEvent.MOUSE_OUT, this.hoverHandler);
					asset.parent.removeEventListener(MouseEvent.CLICK, this.clickHandler);
					asset.parent.removeChild(asset);
				}
			}
			
			this.cancelButton.removeEventListener(MouseEvent.CLICK, this.clickHandler);
			if ( this.furniture.length > 18 )
			{
				this.nextButton.removeEventListener(MouseEvent.CLICK, this.clickHandler);
				this.previousButton.removeEventListener(MouseEvent.CLICK, this.clickHandler);
			}
			
			this.furniture = null;
			
			this.parent.removeChild(this);
		}
		
		private function hoverHandler( evt:MouseEvent ):void
		{
			var mc:MovieClip = evt.currentTarget as MovieClip;
			
			switch (evt.type)
			{
				case MouseEvent.MOUSE_OVER:
					mc.filters = this.highlightGlow;
					mc.scaleX *= 1.03;
					mc.scaleY *= 1.03;
				break;
				
				case MouseEvent.MOUSE_OUT:
					mc.filters = null;
					mc.scaleX /= 1.03;
					mc.scaleY /= 1.03;
				break;
			}
			
		}
		
		private function clickHandler( evt:MouseEvent ):void
		{
			switch(evt.currentTarget.name)
			{
				case "nextButton":
					this.page++;
					new FizTween(this.pages.getChildAt(this.page), 0, 0, false, true, 3);
					new FizTween(this.pages.getChildAt(this.page - 1), -640, 0, true, true, 3);
					this.previousButton.visible = true;
					if ( this.page == (this.pages.numChildren - 1) ) this.nextButton.visible = false;
				break;
				case "previousButton":
					this.page--;
					new FizTween(this.pages.getChildAt(this.page), 0, 0, false, true, 3);
					new FizTween(this.pages.getChildAt(this.page + 1), 640, 0, true, true, 3);
					this.nextButton.visible = true;
					if ( this.page == 0 ) this.previousButton.visible = false;
				break;
				case "cancelButton":
					this.dispose();
					this.dispatchEvent(new Event(Event.CLOSE));
				break;
				default:
					_selection = evt.currentTarget.data;
					this.dispose();
					this.dispatchEvent(new Event(Event.CLOSE));
				break;
			}
		}
		
		public function distillName(n:String):String{
			var nameSplit:Array = n.split("/");
			var distilledName:String = (nameSplit[nameSplit.length-1]);
			distilledName = distilledName.split(".")[0];
			if (distilledName.search("-fp-") > -1) distilledName = distilledName.slice(0, distilledName.search("-fp-"));
			if (distilledName.search(/_[au|uk|us]+\b/) > -1) distilledName = distilledName.slice(0, distilledName.search(/_[au|uk|us]+\b/));
			return distilledName;
		}
	}

}