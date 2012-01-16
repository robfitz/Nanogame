package mysa
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import nano.Character;
	import nano.World;

	public class Sheep extends Character
	{
		private var isPlayerInit:Boolean = false;
		private var justDropped:Boolean = false;
		
		public function Sheep(world:World, image_width:int, image_height:int, iso_width:int, iso_length:int, iso_height:int, spriteswf:DisplayObject=null, spritesheet:DisplayObject=null, descriptor:Object=null)
		{
			super(world, image_width, image_height, iso_width, iso_length, iso_height, spriteswf, spritesheet, descriptor);
			stand();
		}
		
		override public function stand():void {
			super.stand();
			if (spritesheet) {
				spritesheet.y = - image_height * 1;
			}
		}
		
		private var isCarried:Boolean = false;
		
		private var frame:uint = 0;
		private var stationaryFrames:int = 0;
		private var lastX:int;
		private var lastY:int;
		
		override protected function update(event:Event):void {
			if (!isPlayerInit) {
				if (world.player) {
					world.player.addEventListener(Event.ENTER_FRAME, refresh);
					isPlayerInit = true;
				}
			}
		}
		private function refresh(event:Event):void {
			if (isCarried) {
				this.moveTo(this.world.player.carryAnchor.x, this.world.player.carryAnchor.y, this.world.player.carryAnchor.z);
				this.spritesheet.x = - image_width * world.player.current_dir;
				if (this.x == lastX && this.y == lastY) {
					stationaryFrames ++;
					if (stationaryFrames >= 24) {
						stationaryFrames = 0;
						isCarried = false;
						spritesheet.y = -image_height;
						justDropped = true;
						world.player.isCarrying = false;
					}
				} 
				else {
					stationaryFrames = 0;
				}
				lastX = this.x;
				lastY = this.y;
			}
			else {
				// animate
				this.spritesheet.x = -image_width * (int((frame++)/2) % 8)
				
				// if very close to player, get picked up
				if (Math.abs(x - world.player.carryAnchor.x) < 16 &&
					Math.abs(y - world.player.carryAnchor.y) < 16)
				{
					if (!justDropped) {
						isCarried = true;
						spritesheet.y = - image_height * 2;
						spritesheet.x = - image_width * world.player.current_dir;
						world.player.isCarrying = true;
					} 
				}
				else {
					justDropped = false;
				}
			}
		}
	}
}