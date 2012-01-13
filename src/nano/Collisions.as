package nano
{
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.scene.IsoGrid;
	
	import net.pixelpracht.tmx.TmxObject;
	
	public class Collisions
	{
		private static var rects:Array = [];
		private static var grid:IsoGrid;
		
		/** consider a new collision rectangle, usually pulled from
		 * an object layer with property: "nowalk"=true */
		public static function add(collision_rect:TmxObject):void {
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
		public static function test(sprite:IIsoDisplayObject):Boolean {
			var sprite_x:int = sprite.x;
			var sprite_y:int = sprite.y;
			var sprite_x2:int = sprite.x + sprite.width;
			var sprite_y2:int = sprite.y + sprite.length;
			
			// test against collision rectangles
			for each (var r:* in rects) {
				if (r.x < sprite_x2 && r.x2 > sprite_x &&
    				r.y < sprite_y2 && r.y2 > sprite_y) 
    			{
    				return true;
    			}
			}
			
			// test against map boundaries
			if (sprite.x >= grid.gridSize[0] * grid.width - sprite.width ||
				sprite.x < 0 ||
				sprite.y >= grid.gridSize[1] * grid.length - sprite.length ||
				sprite.y < 0) 
			{
				return true;
			}
			
			// no collision
			return false;
		}
		
		public static function init(g:IsoGrid):void {
			grid = g;
		}
		
		public function Collisions()
		{
		}

	}
}