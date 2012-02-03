package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.MovieClipAsset;
	import mx.core.MovieClipLoaderAsset;
	
	import nano.AssetLoader;
	import nano.Assets;
	
	/**
	 * Tests assets placed into the game 
	 * @author devin
	 * 
	 */	
	
	public class AssetTester extends Sprite
	{
		public function AssetTester()
		{
			super();
			
			var asset_stream:* = new Assets.instance.stretch_scales();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderComplete);
			loader.loadBytes(asset_stream);
		}
		
		private function onLoaderComplete(event:Event):void {
			var asset:MovieClip = (event.target.content as MovieClip)['asset'];
			
			asset.x = 100;
			asset.y = 200;
			this.addChild(asset);
			asset.gotoAndStop('onclick');
		}
	}
}