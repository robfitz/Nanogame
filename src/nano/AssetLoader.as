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
		
		private var _asset:MovieClipAsset;
		public function get asset():MovieClip {
			return _asset;
		}
		
		private var _content:MovieClip;
		public function get content():MovieClip {
			return _content;
		}
		
		/**
		 * Default contructor, must supply asset class to instantiate and load. 
		 * @param assetClass 
		 */		
		public function AssetLoader(assetClass:Class)
		{
			super();
			
			this._asset = new assetClass();
			var loader:Loader = this._asset.getChildAt(0) as Loader;
			var info:LoaderInfo = loader.contentLoaderInfo;
			info.addEventListener(Event.COMPLETE, this.onLoadComplete);
		}
		
		private function onLoadComplete(event:Event):void {
			var info:LoaderInfo = event.target as LoaderInfo;
			info.removeEventListener(Event.COMPLETE, this.onLoadComplete);
			this._content = info.loader.content as MovieClip;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}