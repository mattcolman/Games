package
{
	import com.*;
	import com.FurnitureBrowser;
	import com.PickerView;
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
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	
	[SWF(width="1024", height="768", backgroundColor="#FFFFFF", frameRate = "30")]
	
	public class Furniture extends BaseActivity
	{
		TweenPlugin.activate([ShortRotationPlugin, TransformAroundCenterPlugin, TransformAroundPointPlugin, ThrowPropsPlugin]);
		
		private var deviceCameraApp:CameraUI = new CameraUI();
		private var imageLoader:Loader;
		private var _pictureMC:MovieClip;
		private var _curScreenMC:MovieClip;
		private var _jsonData:Object;
		private var _mouseLoc:Point;
		private var _regions:Array;
		private var _scalingFactor:Number;
		private var _selectedRegion:Object;
		

		public function Furniture()
		{
			// small change again again again again
			trace('start furniture game');
		}
		
		override public function init():void {
			super.init();
			_curScreenMC = new MovieClip();
			stage.addChild(_curScreenMC);
			_mouseLoc = new Point();
			_regions = [];
			intro();
		}
		
		private function intro():void {
			var background:MovieClip = new Background();
			_curScreenMC.addChild(background);
			var photo_btn:MovieClip = new Photo_btn();
			photo_btn.x = 500;
			photo_btn.y = 300;
			_curScreenMC.addChild(photo_btn);
			photo_btn.addEventListener(MouseEvent.CLICK, startCamera);
			photo_btn.buttonMode = true;
		}
		
		private function startCamera(e:MouseEvent):void {
			trace("start camera");
			if (CameraUI.isSupported)
			{
				trace("Initializing camera...");
				deviceCameraApp.launch(MediaType.IMAGE);
				deviceCameraApp.addEventListener( MediaEvent.COMPLETE, imageCaptured );
			}
			else
			{
				trace("Camera interface is not supported.");
				var url:String = "lounge_room.png";
				var urlRequest:URLRequest = new URLRequest(url);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_complete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(urlRequest);
				
				function loader_complete(evt:Event):void {
					var target_mc:Loader = evt.currentTarget.loader as Loader;
					showMedia(target_mc);
				}
			}
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function imageCaptured( event:MediaEvent ):void
		{
			trace("Media captured...");
			var imagePromise:MediaPromise = event.data;
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, asyncImageLoaded );
			imageLoader.loadFilePromise( imagePromise );
		}
		
		private function asyncImageLoaded( event:Event ):void
		{
			trace("Media loaded in memory.");
			showMedia(imageLoader);
		}
		
		private function showMedia( loader:Loader ):void
		{
			trace("show media");
			while (_curScreenMC.numChildren > 0) _curScreenMC.removeChildAt(0);
			
			_pictureMC = new MovieClip();
			_pictureMC.graphics.beginFill(0x000000);
			_pictureMC.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_pictureMC.graphics.endFill();
			_curScreenMC.addChild(_pictureMC);
			
			loader.width = stage.stageWidth;
			loader.scaleY = loader.scaleX;
			if (loader.height > stage.stageHeight) {
				loader.height = stage.stageHeight;
				loader.scaleX = loader.scaleY;
				loader.x = (stage.stageWidth - loader.width) / 2;
			} else {
				loader.y = (stage.stageHeight - loader.height) / 2;
			}
			// Detect the orientation of the device and rotate accordingly.
			if (stage.orientation == 'rotatedLeft') {
				TweenMax.to(_pictureMC, 0, {transformAroundCenter:{rotation:180}});
			}
			_pictureMC.addChild(loader);
			
			showControls();
		}
		
		private function showControls():void {
			var controls:MovieClip = new BottomUI();
			controls.y = stage.stageHeight - controls.height;
			controls.addButton.addEventListener(MouseEvent.CLICK, clickHandler);
			controls.regionButton.addEventListener(MouseEvent.CLICK, clickHandler);
			_curScreenMC.addChild(controls);
			TweenMax.from(controls, 1, {delay: 1, y:'200', ease:Strong.easeOut});
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.target.name) {
				case 'addButton':
					showFurnitureBrowser();
					break;
				case 'regionButton':
					addRegion();
					break;
			}
			
		}
		
		private function addRegion():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		}
		
		private function handleMouseDown(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			_mouseLoc.x = stage.mouseX;
			_mouseLoc.y = stage.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
			var regionMC:MovieClip = new MovieClip();
			var s:Sprite = new Sprite();
			s.name = 'regionBox';
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawRect(0, 0, 0, 0);
			s.graphics.endFill();
			regionMC.x = _mouseLoc.x;
			regionMC.y = _mouseLoc.y;
			regionMC.addChild(s);
			stage.addChild(regionMC);
			
			function handleMouseMove(e:MouseEvent):void {
				var px:Number = stage.mouseX - _mouseLoc.x;
				var py:Number = stage.mouseY - _mouseLoc.y;
				s.graphics.clear();
				s.graphics.beginFill(0xFF0000, .3);
				s.graphics.drawRect(0, 0, px, py);
				s.graphics.endFill();
				regionMC.x = _mouseLoc.x;
				regionMC.y = _mouseLoc.y;
			}
			
			function handleMouseUp(e:MouseEvent):void {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);		
				var region:Object = {name:'some region',
									 container:regionMC,
									 dimensions:{x:0, y:0, z:0}
									}
									 
				_regions.push(region);
				_selectedRegion = region;
				createPickerView();
			}
		}
		
	
		private function showFurnitureBrowser():void
		{
			trace("show furniture");
			var browser:FurnitureBrowser = new Browser();
			browser.x = stage.stageWidth/2;
			browser.y = stage.stageHeight/2;
			stage.addChild(browser);
			
			var items:Array = new Array();
			for each(var item:Object in _jsonData.variables.items) {
				item.asset = item.name;
				items.push(item);
			}
			//TO DO: use Furniture browser class
			browser.initialize(items);
			browser.addEventListener('close', handleClose);
		}
		
		private function handleClose(e:Event):void {
			trace('close');
			if (e.target.selection) {
				var s:* = e.target.selection;
				trace(e.target.selection);
				var couch:Bitmap = s.asset.rawContent;
				couch.width = cmToPixels(s.dimensions.x);
				couch.scaleY = couch.scaleX;
				couch.y = _selectedRegion.container.getChildByName('regionBox').height - couch.height;
				_selectedRegion.container.addChild(couch);
			}
		}
		
		private function createPickerView():void {
			var dPickerCnt:MovieClip = new MovieClip();
			dPickerCnt.x = stage.stageWidth/2 - 100;
			dPickerCnt.y = stage.stageHeight/2 - 100;
			stage.addChild(dPickerCnt);
			TweenMax.from(dPickerCnt, 1, {y:stage.stageHeight, ease:Strong.easeOut});
			var dPicker:DimensionPicker = new DimensionPicker(dPickerCnt, 200, 200);
			//dPicker.addEventListener('ok_clicked', handleOKClicked);
			dPicker.addEventListener('ok_clicked', handleOKClicked);
			dPicker.addEventListener('cancel_clicked', handleCancelClicked);
		}
		
		private function handleCancelClicked(e:Event):void {
			// TO DO - remove region - removeRegion(_selectedRegion);
			e.target.removeEventListener('cancel_clicked', handleCancelClicked);
			e.target.removeMe();
			TweenMax.to(e.target.parent, 1, {y:stage.stageHeight, ease:Strong.easeOut});
		}
		
		private function pixelsToCM(valueInPixels:Number):Number {
			return valueInPixels * _scalingFactor;
		}
		
		private function cmToPixels(valueInCM:Number):Number {
			var scalingFactor:Number = _selectedRegion.container.width / _selectedRegion.dimensions.x;
			trace("scaling factor is " + scalingFactor);
			return valueInCM * scalingFactor;
		}
		
		private function handleOKClicked(e:Event):void {
			trace("OK CLICKED");
			e.target.removeEventListener('ok_clicked', handleCancelClicked);
			var regionCnt:MovieClip = _selectedRegion.container;
			_selectedRegion.dimensions.x = e.target._value;
			
			var textBox:MovieClip = new TextBox();
			textBox.t_txt.text = _selectedRegion.dimensions.x + "cm";
			textBox.x = regionCnt.width/2;
			textBox.y = regionCnt.height + 10;
			regionCnt.addChild(textBox);
			e.target.removeMe();
			TweenMax.to(e.target.parent, 1, {y:stage.stageHeight, ease:Strong.easeOut, onComplete:showFurnitureBrowser});
		}
		
	}
}