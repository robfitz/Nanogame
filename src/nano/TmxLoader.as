package nano
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.pixelpracht.tmx.TmxMap;
	import net.pixelpracht.tmx.TmxTileSet;

	/**
	 * Parses and loads a tile map into TmxMaps and then builds IsoScenes from that data 
	 * @author devin
	 */	
	public class TmxLoader
	{
		
		public static const MAP_PATH:String = "./assets/";
		
		private var _isLoaded:Boolean = false;
		public function get isLoaded():Boolean {
			return _isLoaded;
		}
		
		private var _mapXml:XML;
		private var _map:TmxMap;
		private var _imageCache:Object;
		
		/**
		 * Default contructor 
		 */		
		public function TmxLoader()
		{
		}
		
		/**
		 * Load and build a TmxMap from a asset URI
		 * @param xmlUrl Location of the tiled tmx xml. 
		 */		
		public function load(xmlUrl:String):void {
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, this.onXmlLoaded);
			xmlLoader.load(new URLRequest(xmlUrl));
		}
		
		private function onXmlLoaded(event:Event):void {
			this._mapXml = new XML((event.target as URLLoader).data); 
			this._map = new TmxMap(this._mapXml);
			this.loadTileImages();
		}
		
		private function loadTileImages():void {
			var imagesToLoad:int = 0;
			var finishedCallback = this.createIsoTiles;
			this._imageCache = new Object();
			
			for each(var tileset:TmxTileSet in this._map.tileSets) {
				var setImage:Loader = new Loader();
				setImage.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
					var bmp:Bitmap = event.target.content as Bitmap;
					tileset.image = bmp.bitmapData;
					imagesToLoad --;
					
					if(imagesToLoad == 0) {
						finishedCallback();
					}
				});
				imagesToLoad ++;
				setImage.load(new URLRequest(MAP_PATH + tileset.imageSource));
			}
		}
		
		private function createIsoTiles():void {
			
		}
	}
}