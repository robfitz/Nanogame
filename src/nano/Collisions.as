package nano
{
	import net.pixelpracht.tmx.TmxObject;
	
	public class Collisions
	{
		private var rects:Array = [];
		
		public function add(collision_rect:TmxObject):void {
			rects.push(collision_rect);
		}
		
		public function Collisions()
		{
		}

	}
}