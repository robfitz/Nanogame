package nano
{
	import as3isolib.display.IsoSprite;
	
	import com.gskinner.motion.GTween;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
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
        
		private var spriteswf:DisplayObject;
		
		protected var image_height:int;
		protected var image_width:int;
		
		public var carryAnchor:IsoSprite;
		
		// as3isolib only moves in integer increments, so
		// we use these to track fractional movement over
		// multiple frames
		private var unmovedX:Number = 0;
        private var unmovedY:Number = 0;
        
        private var dialogbox:DialogBox;
                

		public function Character(world:World, characterSprite:MovieClip, descriptor:Object = null)
		{
			super(descriptor);
			this.world = world;
			
			//this.image_height = image_height;
			//this.image_width = image_width;
			
			this.spriteswf = characterSprite;
   			this.initSpriteswf();
            
            this.sprites = [this.spriteswf]
			this.setSize(32, 32, 0);
            
            //carryAnchor = new IsoSprite();
            //carryAnchor.z = 20;
            
            //addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Update loop for the character 
		 * @param dt Amount of time that has passed in seconds
		 * 
		 */		
		protected function update(dt:Number):void {
			if (destination) {
				updatePosition();
			}
		}
		
		public function stand():void {
			destination = null;
		
			try {
				(spriteswf as Object).gotoAndStop("south stand");
			} catch (error:*) {
				trace('failed to call stand');
				// do nothing on failure
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
			}
			dispatchEvent(new Event("moved"));
		}
		
		public function updateDialogTriggers():void {
			this.world.triggers.test(this);
			if (this.world.triggers.justHit) {
				var hit_rect:* = this.world.triggers.justHit;
				
				if (!dialogbox) {
					dialogbox = new DialogBox();
					//this.spriteContainer.stage.addChild(dialogbox);
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
			
			try {
				trace("IMPLEMENT TURNING");
				(spriteswf as Object).turn(direction);
			}
			catch (e:*) { 
			}
		}
		
		private function initSpriteswf():void {
			stand();
		}
	}
}