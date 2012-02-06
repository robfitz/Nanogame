package nano.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nano.AssetLoader;
	import nano.Assets;
	
	/**
	 * Displays and controls the playback of a cutscene 
	 * @author devin
	 * 
	 */	
	public class Cutscene extends Sprite
	{
		
		public var cutsceneName:String;
		public var asset:MovieClip;
		
		/** Frame that needs to be cued once a valid asset is loaded */
		private var toCue:String;
		
		/**
		 * Create a new cutscene 
		 * @param assetClass Defaults to the professor
		 */		
		public function Cutscene(cutsceneName:String = null)
		{
			super();
			
			this.cutsceneName = cutsceneName;
			
			if(! this.cutsceneName) {
				this.cutsceneName = "cutscene_professor";
			}
			
			// attach the scene
			var loader:AssetLoader;
			loader = new AssetLoader(Assets.instance[this.cutsceneName]);
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				asset = (event.target as AssetLoader).asset;
				addChild(asset);
			}, false, 0, true);
			
			this.addEventListener(Event.ADDED, onChildAdded);

			var masker:Sprite = new Sprite();
			masker.graphics.beginFill(0xff0000);
			
			// set by laruence
			masker.graphics.drawRect(0, 0, 221, 22);
			this.addChild(masker);
			this.mask = masker;
		}
		
		/**
		 * Cue up a specific frame 
		 * @param frameName The frame to cue up
		 */		
		public function cue(frameName:String):void {
			if(this.asset) {
				this.toCue = null;
				this.asset.gotoAndPlay(frameName)
			} else {
				this.toCue = frameName;
			}
		}
		
		private function onChildAdded(event:Event):void {
			if(this.toCue) {
				this.cue(this.toCue);
			}
		}
	}
}