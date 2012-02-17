package nano.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
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
		public var maskRect:Rectangle;
		
		/** Frame that needs to be cued once a valid asset is loaded */
		private var toCue:String;
		
		/**
		 * Create a new cutscene 
		 * @param assetClass Defaults to the professor
		 */		
		public function Cutscene(cutsceneName:String, maskRect:Rectangle = null, scale:Number = 1, bgColor:uint = 0x333333)
		{
			super();
			
			this.cutsceneName = cutsceneName;
			
			this.maskRect = maskRect;
			if(! this.maskRect) {
				this.maskRect = new Rectangle(0, 0, 218, 218);
			}
			
			// attach the scene
			var loader:AssetLoader;
			trace(Assets.instance[this.cutsceneName]);
			loader = new AssetLoader(Assets.instance[this.cutsceneName]);
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				asset = (event.target as AssetLoader).asset;
				addChild(asset);
			});
			
			this.addEventListener(Event.ADDED, onChildAdded);

			// mask
			var masker:Sprite = new Sprite();
			masker.graphics.beginFill(0xff0000);
			masker.graphics.drawRect(0, 0, this.maskRect.width, this.maskRect.height);
			this.addChild(masker);
			this.mask = masker;
			
			// bg color
			this.graphics.beginFill(bgColor);
			this.graphics.drawRect(0, 0, this.maskRect.width, this.maskRect.height);
			this.graphics.endFill();
		}
		
		/**
		 * Cue up a specific frame 
		 * @param frameName The frame to cue up
		 */		
		public function cue(frameName:String):void {
			if(this.asset) {
				this.toCue = null;
				this.asset.cutscene.gotoAndPlay(frameName)
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