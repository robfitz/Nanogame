package nano
{
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.scene.IsoGrid;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;
	
	/**
	 * Generic layer that alert you when you enter a collision hull. 
	 * @author devin
	 * 
	 */	
	
	public class CollisionLayer
	{
		public var rects:Array = [];
		private var grid:IsoGrid;
		
		private var tiles:TmxLayer;
		
		/** Object that successfully hit detected last, if any */
		private var _currentlyHit:Object;
		public function get currentlyHit():Object {
			return _currentlyHit;
		}
		
		private var _justHit:Object;
		public function get justHit():Object {
			return _justHit;
		}
		
		/** 
		 * Consider a new collision rectangle, usually pulled from
		 * an object layer with property: "nowalk"=true 
		 */
		public function add(collision_rect:TmxObject):void {
			rects.push({
				'name': collision_rect.name,
				'props': collision_rect.custom,
				'x': collision_rect.x,
				'y': collision_rect.y,
				'x2': collision_rect.x + collision_rect.width,
				'y2': collision_rect.y + collision_rect.height,
				'width': collision_rect.width,
				'height': collision_rect.height
			});
		}
		
		/** returns whether or not a sprite is within the set of 
		 * collision rectangles */
		public function test(sprite:IIsoDisplayObject):Boolean {
			var sprite_x:int = sprite.x;
			var sprite_y:int = sprite.y;
			var sprite_x2:int = sprite.x + sprite.width;
			var sprite_y2:int = sprite.y + sprite.length;
			
			// test against collision rectangles
			for each (var r:* in rects) {
				if (r.x < sprite_x2 && r.x2 > sprite_x &&
    				r.y < sprite_y2 && r.y2 > sprite_y) 
    			{
					// set hit objects
					if(! this._currentlyHit || this._currentlyHit != r) {
						this._justHit = r;
					} else {
						this._justHit = null;
					}
					this._currentlyHit = r;
					
    				return true;
    			}
			}
			
			if (tiles) {
				if (col_tile(sprite_x, sprite_y) || 
					col_tile(sprite_x2, sprite_y) ||
					col_tile(sprite_x, sprite_y2) || 
					col_tile(sprite_x2, sprite_y2)) 
				{
					return true;
				}
			
			}
			
			// no tile collision, so we need to clear our last hit
			this._currentlyHit = null;
			this._justHit = null;
			
			if(grid) {
				// test against map boundaries
				if (sprite.x >= grid.gridSize[0] * grid.width - sprite.width ||
					sprite.x < 0 ||
					sprite.y >= grid.gridSize[1] * grid.length - sprite.length ||
					sprite.y < 0) 
				{
					return true;
				}
			}
			
			// no collision
			return false;
		}
		
		public function col_tile(x:int, y:int):Boolean {
			if (!tiles) return false;
			
			var tile_r:int = y / 32;
			var tile_c:int = x / 32;
			
			try {
				var collision:* = tiles.tileGIDs[tile_r][tile_c];
				return collision != 0;
				
			}
			catch (e:*) {
				return false;
			}
			return false;
		}
		
		/**
		 * Default constructor. Can be initialized with a TmxObjectGroup containing
		 * hulls. Assumes all hulls on that layer represent nowalk zones
		 * @param objs TmxObjectGroup of hulls
		 * 
		 */		
		public function CollisionLayer(objs:TmxObjectGroup=null, layer:TmxLayer=null)
		{
			if(objs) {
				for each(var obj:TmxObject in objs.objects) {
					this.add(obj);
				}
			}
			this.tiles = layer;
		}
	}
}