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
			
			var masker:Sprite = new Sprite();
			masker.graphics.beginFill(0xff0000);
			masker.graphics.drawRect(0, 0, 220, 220);
			this.addChild(masker);
			this.mask = masker;
		}
		
		/**
		 * Cue up a specific frame 
		 * @param frameName The frame to cue up
		 */		
		public function cue(frameName:String):void {
			
		}
	}
}