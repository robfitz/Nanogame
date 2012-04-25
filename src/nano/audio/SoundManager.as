package nano.audio
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import nano.Assets;

	/**
	 * Controls the loading, playback and switching of music and sFX in Nanogame 
	 * @author devin
	 * 
	 */	
	
	public class SoundManager
	{
		private var channel:SoundChannel;
		
		public function SoundManager()
		{
			
		}
		
		public function cueBackgroundMusic(clipName:String):void {
			if(this.channel) {
				this.channel.stop();
				this.channel = null;
			}
			var sound:Sound = new Assets.instance[clipName]() as Sound;
			// fakey loops
			this.channel = sound.play(0, int.MAX_VALUE);
		}
		
		public function stopMusic():void {
			if(this.channel) {
				this.channel.stop();
			}
		}
	}
}