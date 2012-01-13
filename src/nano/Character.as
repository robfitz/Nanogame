package nano
{
	import as3isolib.display.IsoSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.describeType;
	
	public class Character extends IsoSprite
	{
		/** The world this character lives in */
		private var world:World;
		
		private var destination:Point;
		
		private var distancePerFrame:Number = 4.5;
        private var distanceToNextFrame:Number = distancePerFrame;
        
        private var decelerationFactor:Number = 10;
        private var maxSpeed:Number = 100;
        
        private static const FPS:int = 12;
        
		private var spriteswf:*;
		private var spritesheet:DisplayObject;
		
		private var num_spritesheet_frames:int;
		
		private var spriteContainer:Sprite = new Sprite();
		
		private var image_height:int;
		private var image_width:int;
		
		// as3isolib only moves in integer increments, so
		// we use these to track fractional movement over
		// multiple frames
		private var unmovedX:Number = 0;
        private var unmovedY:Number = 0;
                

		public function Character(world:World, image_width:int, image_height:int, iso_width:int, iso_length:int, iso_height:int, spriteswf:DisplayObject=null, spritesheet:DisplayObject=null, descriptor:Object=null)
		{
			super(descriptor);
			this.world = world;
			this.setSize(iso_width, iso_length, iso_height);
			
			this.image_height = image_height;
			this.image_width = image_width;
			
			this.spriteswf = spriteswf;
			this.spritesheet = spritesheet;
			
			if (spritesheet) {
				initSpritesheet(image_width, image_height);
   			}
   			else if (spriteswf) {
   				initSpriteswf();
   			}
   			spriteContainer.x = -image_width / 2;
            spriteContainer.y = -(image_height - iso_height);
            
            this.sprites = [spriteContainer]
            
            addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		
		
		private function update(event:Event):void {
			if (destination) {
				updatePosition();
			}
		}
		
		public function stand():void {
			destination = null;
			
			if (spritesheet) {
					spritesheet.x = 0;
			}
			else {
				try {
					spriteswf.stand();
				}
				catch (error:*) { }
			}
		}
		
		public function walkTo(destination:Point):void {
			this.destination = destination;
		}
		
		private function updatePosition():void {
			updateDirection();
			
			var dx:Number = (destination.x - this.x);
			var dy:Number = (destination.y - this.y);
			
			if (Math.abs(dx) < 2) {
				dx = 0;
				this.x = destination.x;
			} 
			if (Math.abs(dy) < 2) {
				dy = 0;
				this.y = destination.y;
			}
			
			dx /= decelerationFactor;
			dy /= decelerationFactor;
			
			var dist:Number = Math.sqrt( dx * dx + dy * dy );
			
			var maxSpeedRatio:Number = dist / (maxSpeed / FPS);
			if (maxSpeedRatio > 1) {
				dx /= maxSpeedRatio;
				dy /= maxSpeedRatio;
				dist /= maxSpeedRatio;
			}
			
			unmovedX += dx;
			unmovedY += dy;
			
			if (dist < 0.1) {
				//close enough, come to rest
				stand();
			} 
			else {
				//isolib only wants to move by full pixels, so store
				//up the incremental moves until it's at least 1 in any direction
				var new_x:int = this.x + int(unmovedX);
				var new_y:int = this.x + int(unmovedY);
 				
 				// try moving in the full direction
 				this.x += int(unmovedX);
				this.y += int(unmovedY);
				
				if (this.world.collisions.test(this)) {
					// can't move to where we want
					
					// try sliding along in just the Y direction
					this.x -= int(unmovedX);
					
					if (this.world.collisions.test(this)) {
						// if Y doesn't work, try sliding in only X direction
						this.x += int(unmovedX);
						this.y -= int(unmovedY);
						
						if (this.world.collisions.test(this)) {
							this.x -= int(unmovedX);
							// can't move at all in the direction we'd like. stop moving
							stand();
							return;
						}
					}
				}
				
				distanceToNextFrame -= Math.sqrt(dx*dx + dy*dy);
				
				unmovedX -= int(unmovedX);
				unmovedY -= int(unmovedY);
				
				if (spritesheet && distanceToNextFrame < 0) {
					distanceToNextFrame += distancePerFrame;
					spritesheet.x -= image_width;
					if (spritesheet.x <= - num_spritesheet_frames * image_width) {
						spritesheet.x = 0;
					} 
				}  
			}
		}
		
		private function updateDirection():void {
			var temp:* = spriteswf;
			
			var dx:Number = destination.x - this.x;
			var dy:Number = destination.y - this.y; 
			
			var angle:Number = Math.atan2(dy, dx);
			
			//scoot everything forward to make the math slightly easier
			angle += Math.PI / 8;
			while (angle < 0) angle += 2 * Math.PI;
			while (angle >= 2 * Math.PI) angle -= 2 * Math.PI;
			
			var direction:int = 0;
			if (angle > 2 * Math.PI || angle < Math.PI / 4) direction = 0;
			else direction = int(angle / (Math.PI / 4));
			
			if (spritesheet) {
				spritesheet.y = - image_height * direction;
			}
			else {
				try {
					trace("trying to turn:" + direction);
					spriteswf.getChildAt(0).content.turn(direction);
					trace("turning:" + direction);
				}
				catch (e:*) { 
					trace("fail");
					trace(flash.utils.describeType(spriteswf.loaderInfo));
				}
			}
		}
		
		private function initSpriteswf():void {
			spriteContainer.addChild(spriteswf);
			spriteswf.width = image_width;
			spriteswf.height = image_height;
			stand();
		}
		
		private function initSpritesheet(image_width:int, image_height:int):void {
			spriteContainer.addChild(spritesheet);
            var mask:Sprite = new Sprite();
            mask.graphics.beginFill(0xffffff);
            mask.graphics.drawRect(0, 0, image_width, image_height);
            mask.graphics.endFill();
            spriteContainer.addChild(mask);
            spriteContainer.mask = mask;
            
            num_spritesheet_frames = spritesheet.width / image_width;
  		}
		
	}
}