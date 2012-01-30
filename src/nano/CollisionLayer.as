package nano
{
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.scene.IsoGrid;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;
	
	import org.osmf.net.StreamingURLResource;
	
	/**
	 * Generic layer that alert you when you enter a collision hull. 
	 * @author devin
	 * 
	 */	
	
	public class CollisionLayer
	{
		public var rects:Array = [];
		private var grid:IsoGrid;
		
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
				'hull': (collision_rect.custom && collision_rect.custom['hull'] == 'true'),
				'trigger': collision_rect.custom ? collision_rect.custom['trigger'] : false,
				'props': collision_rect.custom,
				'x': collision_rect.x,
				'y': collision_rect.y,
				'x2': collision_rect.x + collision_rect.width,
				'y2': collision_rect.y + collision_rect.height,
				'width': collision_rect.width,
				'height': collision_rect.height
			});
		}

		/**
		 * Tests a sprite against the collision map 
		 * @param sprite The sprite to test
		 * @param updateState When true, justHit and currentlyHitting will be updated. 
		 * @return True if a collision has occured
		 */		
		public function test(sprite:IIsoDisplayObject, updateState:Boolean = true):Boolean {
			var sprite_x:int = sprite.x;
			var sprite_y:int = sprite.y;
			var sprite_x2:int = sprite.x + sprite.width;
			var sprite_y2:int = sprite.y + sprite.length;
			
			// test against collision rectangles
			for each (var r:* in rects) {
				if(! r['hull']) {
					continue;
				}
				
				if (r.x < sprite_x2 && r.x2 > sprite_x &&
    				r.y < sprite_y2 && r.y2 > sprite_y) 
    			{
					// set hit objects
					if(updateState) {
						if(! this._currentlyHit || this._currentlyHit != r) {
							this._justHit = r;
						} else {
							this._justHit = null;
						}
						this._currentlyHit = r;
					}
					
    				return true;
    			}
			}
						
			// no tile collision, so we need to clear our last hit
			if(updateState) {
				this._currentlyHit = null;
				this._justHit = null;
			}
			
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
				
		/**
		 * Default constructor. Can be initialized with a TmxObjectGroup containing
		 * hulls. Assumes all hulls on that layer represent nowalk zones
		 * @param objs TmxObjectGroup of hulls
		 * @param limitProp Limits the items held in this group to 
		 * 		  just one object type, usually <code>hull</code> or <code>trigger</code>
		 */		
		public function CollisionLayer(objs:TmxObjectGroup=null, limitProp:String = null)
		{
			if(objs) {
				for each(var obj:TmxObject in objs.objects) {
					if(! limitProp || (obj.custom && obj.custom[limitProp])) {
						this.add(obj);
					}
				}
			}
		}
		
	}
}