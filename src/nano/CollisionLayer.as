package nano
{
	import as3isolib.core.IIsoDisplayObject;
	
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;
	
	/**
	 * Generic layer that alert you when you enter a collision hull. 
	 * @author devin
	 * 
	 */	
	
	public class CollisionLayer
	{
		private var rects:Array = [];
		
		/** 
		 * Consider a new collision rectangle, usually pulled from
		 * an object layer with property: "nowalk"=true 
		 */
		public function add(collision_rect:TmxObject):void {
			rects.push({
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
			var sprite_y2:int = sprite.y + sprite.height;
			
			for each (var r:* in rects) {
				if (r.x < sprite_x2 && r.x2 > sprite_x &&
    				r.y < sprite_y2 && r.y2 > sprite_y) 
    				
    				return true;
			}
			return false;
		}
		
		/**
		 * Default constructor. Can be initialized with a TmxObjectGroup containing
		 * hulls. Assumes all hulls on that layer represent nowalk zones
		 * @param objs TmxObjectGroup of hulls
		 * 
		 */		
		public function CollisionLayer(objs:TmxObjectGroup = null)
		{
			for each(var obj:TmxObject in objs.objects) {
				this.add(obj);
			}
		}

	}
}