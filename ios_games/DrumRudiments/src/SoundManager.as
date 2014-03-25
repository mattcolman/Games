package
{	
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	public class SoundManager
	{			
		public var _sounds:Dictionary;
		public var _sTranform:SoundTransform;
		
		public function SoundManager()
		{
			_sounds = new Dictionary();
			_sounds["snare1"] = new Snare1();
			_sounds["snare2"] = new Snare2();
			_sTranform = new SoundTransform();	
			setVolume(1);
		}
		
		public function play(key:String, volume:Number=-1):void {
			if (volume != -1) setVolume(volume);
			_sounds[key].play(0, 0, _sTranform);			
		}
		
		public function setVolume(volume:Number):void {
			_sTranform.volume = volume;
		}
		
	}
}