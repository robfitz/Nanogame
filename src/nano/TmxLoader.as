package nano
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.scene.IsoScene;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxMap;
	import net.pixelpracht.tmx.TmxObjectGroup;
	import net.pixelpracht.tmx.TmxPropertySet;
	import net.pixelpracht.tmx.TmxTileSet;

	/**
	 * Parses and loads a tile map into TmxMaps and then builds IsoScenes from that data 
	 * @author devin
	 */	
	public class TmxLoader extends EventDispatcher
	{
		public static const FLAG_FLIPPED_HORZ:int = 0x80000000;
		public static const MAP_PATH:String = "./assets/";
		
		/**
		 * IsoScenes stored by name. Do not access unless <code>isLoaded</code> is true. 
		 */		
		public var scenes:Object;
		
		private var _isLoaded:Boolean = false;
		public function get isLoaded():Boolean {
			return _isLoaded;
		}
		
		public var _bitmapCache:Object;
		private var _mapXml:XML;
		private var _map:TmxMap;
		public function get map():TmxMap {
			return this._map;
		}
		
		/** Global helpers for loading tileset images */
		private var _tilsetsToProcess:Array;
		private var _nextTilesetIndex:int;
		
		/**
		 * Default contructor 
		 */		
		public function TmxLoader()
		{
			this._bitmapCache = new Object();
			this.scenes = new Object();
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
			this._nextTilesetIndex = 0;
			this._tilsetsToProcess = [];
			
			for each(var tileset:TmxTileSet in this._map.tileSets) {
				this._tilsetsToProcess.push(tileset);
			}
			this.loadNextTilesetImage();
		}
		
		private function loadNextTilesetImage():void {
			if(this._nextTilesetIndex >= this._tilsetsToProcess.length) {
				this.createIsoTiles();
				return;
			}
			
			var tileset:TmxTileSet = this._tilsetsToProcess[this._nextTilesetIndex];
			var setImage:Loader = new Loader();
			
			setImage.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
				var bmp:Bitmap = event.target.content as Bitmap;
				tileset.image = bmp.bitmapData;
				_nextTilesetIndex ++;
				loadNextTilesetImage();
			});
			setImage.load(new URLRequest(MAP_PATH + tileset.imageSource));
		}
		
		private function createIsoTiles():void {
			var c:Object = new Object();
			for each(var layer:TmxLayer in this._map.layers) {
				var scene:IsoScene = new IsoScene();
				
				for(var row:int = 0; row < layer.tileGIDs.length; row ++) {
					for(var col:int = 0; col < layer.tileGIDs[row].length; col ++) {
						var gid:uint = layer.tileGIDs[row][col];
						var isFlippedHorz:Boolean = (gid & FLAG_FLIPPED_HORZ) != 0;
						
						//clear flags
						gid = gid & (~ FLAG_FLIPPED_HORZ);
							
						if(gid != 0) {
							var tileset:TmxTileSet = this._map.getGidOwner(gid);
							var bmd:BitmapData = this.getTileBitmap(gid);
							var bitmap:Bitmap = new Bitmap(bmd);
							var sprite:IsoSprite = new IsoSprite();
							
							bitmap.x = - tileset.tileWidth / 2;
							bitmap.y = 32 - tileset.tileHeight;
							
							if(isFlippedHorz) {
								bitmap.scaleX = -1;
								bitmap.x += tileset.tileWidth;
							}
							
							sprite.setSize(tileset.tileWidth, tileset.tileHeight, 0);
							sprite.sprites = [bitmap];
							sprite.x = col * 32;
							sprite.y = row * 32;
							scene.addChild(sprite);
						}
					}
				}
				
				this.scenes[layer.name] = scene;
			}
			
			// All done!
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Returns the correct bitmap data for drawing a tile 
		 * @param gid The guid of the tile you want bitmap data for
		 * @return The bitmap data, or null if no valid bitmap data exists
		 */		
		private function getTileBitmap(gid:uint):BitmapData {
			if(this._bitmapCache.hasOwnProperty(gid)) {
				return this._bitmapCache[gid];
			}
			
			var tileset:TmxTileSet = this._map.getGidOwner(gid);
			var props:TmxPropertySet = tileset.getPropertiesByGid(gid);
			var rect:Rectangle = tileset.getRect(gid - tileset.firstGID);
			trace(rect);
			var mat:Matrix = new Matrix();
			mat.translate(-rect.left, -rect.top);
			var bmd:BitmapData = new BitmapData(tileset.tileWidth, tileset.tileHeight, true, 0x00ffffff);
			bmd.draw(tileset.image, mat);
			
			this._bitmapCache[gid] = bmd;
			return bmd;
		}
		
		/**
		 * Returns a collision object for the map that has been loaded. 
		 * Calling this before calling <code>load</code> will fail 
		 */	
		public function getCollisions():Collisions {
			if(!this._map) {
				return null;
			}
			
			var collisionGroup:TmxObjectGroup = this._map.getObjectGroup("collisions");
			return new Collisions(collisionGroup);
			
		}
	}
}