package nano
{
	import as3isolib.display.IsoSprite;
	
	import com.gskinner.motion.GTween;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import nano.dialog.DialogBox;
	
	public class Character extends IsoSprite
	{
		/** The world this character lives in */
		protected var world:World;
		
		private var destination:Point;
		
		private var distancePerFrame:Number = 4.5;
        private var distanceToNextFrame:Number = distancePerFrame;
        
        private var decelerationFactor:Number = 2;
        private var maxSpeed:Number = 100;
        
        private static const FPS:int = 12;
        
		private var spriteswf:*;
		protected var spritesheet:DisplayObject;
		
		private var num_spritesheet_frames:int;
		
		private var spriteContainer:Sprite = new Sprite();
		
		protected var image_height:int;
		protected var image_width:int;
		
		public var carryAnchor:IsoSprite;
		
		// as3isolib only moves in integer increments, so
		// we use these to track fractional movement over
		// multiple frames
		private var unmovedX:Number = 0;
        private var unmovedY:Number = 0;
        
        private var dialogbox:DialogBox;
                

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
			spriteContainer.y = - image_height * 3 / 4;
            
            this.sprites = [spriteContainer]
            
            carryAnchor = new IsoSprite();
            carryAnchor.z = 20;
            
            addEventListener(Event.ENTER_FRAME, update);
		}
		
		protected function update(event:Event):void {
			if (destination) {
				updatePosition();
			}
		}
		
		public function stand():void {
			destination = null;
			
			if (spritesheet) {
				spritesheet.x = -image_width * current_dir;
				spritesheet.y = - image_height * 8;
				
				if (isCarrying) {
					//show carrying walk instead of normal walk
					spritesheet.y -= image_height * 9;
				}
			}
			else {
				try {
					spriteswf.stand();
				}
				catch (error:*) { }
			}
		}
		
		public function set isCarrying(val:Boolean):void {
			_isCarrying = val;
			if (!destination) stand();
			
			
		}
		public function get isCarrying():Boolean { return _isCarrying; }
		private var _isCarrying:Boolean = false;
		
		public function walkTo(destination:Point):void {
			this.destination = destination;
		}
		
		protected function updatePosition():void {
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
							unmovedX = 0;
							unmovedY = 0;
							destination.x = this.x;
							destination.y - this.y;
						}
					}
				}
				 
				distanceToNextFrame -= Math.sqrt(dx*dx + dy*dy);
				
				updateDialogTriggers();
				
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
			dispatchEvent(new Event("moved"));
		}
		
		public function updateDialogTriggers():void {
			this.world.triggers.test(this);
			if (this.world.triggers.justHit) {
				var hit_rect:* = this.world.triggers.justHit;
				
				if (!dialogbox) {
					dialogbox = new DialogBox();
					this.spriteContainer.stage.addChild(dialogbox);
				}
				
				dialogbox.y = -300;
				dialogbox.x = 50;
				
				dialogbox.text = hit_rect.props["text"];
				dialogbox.render();
				dialogbox.visible = true;
				
				var gt:GTween = new GTween(dialogbox, 0.4, {"y": 10});
			}
			else if (dialogbox && !this.world.triggers.currentlyHit) {
				dialogbox.visible = false;
				}
		}
		
		public var current_dir:uint = 0;
		
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
			
			current_dir = direction;
			
			var arm:int = 24;
			var ax:int = 0;
			var ay:int = 0;
			switch (current_dir) {
				case 0:
					ax = arm;
					ay = 0;
					break;
				case 1:
					ax = arm*3/2;
					ay = arm*3/2;
					break;
				case 2:
					ax = 0;
					ay = arm;
					break;
				case 3:
					ax = -arm/2;
					ay = arm/2;
					break;
				case 4:
					ax = -arm;
					ay = 0;
					break;
				case 5:
					ax = -arm/2;
					ay = -arm/2;
					break;
				case 6:
					ax = 0;
					ay = -arm;
					break;
				case 7:
					ax = arm/2;
					ay = -arm/2;
					break;
			}
			carryAnchor.x = this.x + this.width / 2 + ax;
			carryAnchor.y = this.y + this.length / 2 + ay;
			
			if (spritesheet) {
				spritesheet.y = - image_height * direction;
				if (isCarrying) {
					//show carrying walk instead of normal walk
					spritesheet.y -= image_height * 9;
				}
			}
			else {
				try {
					spriteswf.getChildAt(0).content.turn(direction);
				}
				catch (e:*) { 
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