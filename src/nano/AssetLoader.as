package nano
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.core.MovieClipAsset;
	
	/**
	 * Loads embeded MovieClip (swf based) assets that allow access to their content. 
	 * @author devin
	 * 
	 */	
	
	public class AssetLoader extends EventDispatcher
	{
		
		private var _asset:MovieClip;
		public function get asset():MovieClip {
			return _asset;
		}
		
		/**
		 * Default contructor, must supply asset class to instantiate and load. 
		 * @param assetClass 
		 */		
		public function AssetLoader(assetClass:Class)
		{
			super();
			var stream:* = new assetClass();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onAssetInit);
			loader.loadBytes(stream);
		}
		
		private function onAssetInit(event:Event):void {
			this._asset = (event.target.content as MovieClip)['asset'];
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}