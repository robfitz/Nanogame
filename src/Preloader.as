package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	public class Preloader extends MovieClip
	{
		[Embed(source="assets/loading.swf", symbol="asset")]		
		private var loadingScreenKlass:Class;
		private var loadingScreen:MovieClip;
		
		public function Preloader()
		{
			this.stop();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.addEventListener(Event.ENTER_FRAME, this.checkFrame);
			
			this.loadingScreen = new this.loadingScreenKlass();
			this.loadingScreen.gotoAndStop(1);
			this.loadingScreen.x = -120;
			this.loadingScreen.y = -130;
			this.addChild(this.loadingScreen);
		}
		
		private function checkFrame(e:Event):void {
			var progress:int = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal * 100;

			if(this.framesLoaded == this.totalFrames) {
				stop();
				nextFrame();
				loadingFinished();
			} else {
				this.loadingScreen.gotoAndStop(progress);
			}
		}
		
		private function loadingFinished():void {
			this.removeEventListener(Event.ENTER_FRAME, this.checkFrame);
			startup();
		}
		
		private function startup():void {
			trace("Booting up");
			var mainClass:Class = getDefinitionByName("Nanogame") as Class;
			var game:DisplayObject = new mainClass() as DisplayObject;
			addChild(game);
			this.removeChild(this.loadingScreen);
			this.loadingScreen = null;
			(game as Object).startup();
		}
	}
}