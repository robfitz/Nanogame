package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	public class Preloader extends MovieClip
	{
		
		private var splashScreenMovie:Class;
		
		public function Preloader()
		{
			super();
			
			this.addEventListener(Event.ENTER_FRAME, this.checkFrame);
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progress);
			this.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
		}
		
		private function ioError(e:IOError):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			trace(e.bytesLoaded / e.bytesTotal); 
		}
		
		private function checkFrame(e:Event):void {
			if(currentFrame == totalFrames) {
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void {
			trace("We're Loaded!");
			this.removeEventListener(Event.ENTER_FRAME, this.checkFrame);
			this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progress);
			this.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.ioError);
			startup();
		}
		
		private function startup():void {
			trace("Booting up");
			var mainClass:Class = getDefinitionByName("Nanogame") as Class;
			var game:Nanogame = new mainClass() as Nanogame;
			addChild(game);			
			game.startup();
		}
	}
}