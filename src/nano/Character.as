package nano
{
	import as3isolib.display.IsoSprite;
	import as3isolib.geom.Pt;
	
	import com.gskinner.motion.GTween;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nano.ui.DialogBox;
	
	public class Character extends IsoSprite
	{
		public static var DIRECTIONS:Array = ['east', 'southeast', 'south', 'southwest', 'west', 'northwest', 'north', 'northeast'];
		
		/** The world this character lives in */
		protected var world:World;
		
		private var destination:Pt;
		public var current_dir:uint = 0;
		
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
	
		/**
		 * Flags if the player is carrying a object
		 */
		private var _isCarrying:Boolean = false;
		public function set isCarrying(val:Boolean):void {
			_isCarrying = val;
			if (!destination) stand();
		}
		public function get isCarrying():Boolean { return _isCarrying; }

		/**
		 * Default constructor for a nanogame character 
		 * @param world The world the character lives in
		 * @param characterSprite The flash sprite that is the visual rep of the character
		 * @param descriptor IsoLib descriptor for this sprite
		 * 
		 */		
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
		}
		
		/**
		 * Update loop for the character 
		 * @param dt Amount of time that has passed in seconds
		 * 
		 */		
		public function update(dt:Number):void {
			if (destination) {
				updatePosition(dt);
			} else {
				this.world.collisions.test(this);
			}
		}
		
		public function stand():void {
			destination = null;
		
			try {
				(spriteswf as MovieClip).gotoAndStop(this.animationLabel(this.current_dir, "stand"));
			} catch (error:*) {
				trace('FAILED TO CALL GOTOANDSTOP ON SWF in Character.stand()');
			}
		}		
		
		public function walkTo(destination:Pt):void {
			this.destination = destination;
		}
		
		protected function updatePosition(dt:Number):void {
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
					
					if (this.world.collisions.test(this, false) || int(unmovedY) == 0) {
						// if Y doesn't work, try sliding in only X direction
						this.x += int(unmovedX);
						this.y -= int(unmovedY);
						
						if (this.world.collisions.test(this, false) || int(unmovedX) == 0) {
							this.x -= int(unmovedX);
							// can't move at all in the direction we'd like. stop moving
							unmovedX = 0;
							unmovedY = 0;
							destination.x = this.x;
							destination.y - this.y;
							this.stand();
						}
					}
				}
				 
				distanceToNextFrame -= Math.sqrt(dx*dx + dy*dy);
				
				unmovedX -= int(unmovedX);
				unmovedY -= int(unmovedY);
			}
			dispatchEvent(new Event("moved"));
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
			//carryAnchor.x = this.x + this.width / 2 + ax;
			//carryAnchor.y = this.y + this.length / 2 + ay;
			
			try {
				(spriteswf as MovieClip).gotoAndStop(this.animationLabel(this.current_dir, "walk"));
			}
			catch (e:*) {
				trace("ACCESS TO PLAYER SWF FAILED IN Character.updateDirection");
			}
		}
		
		/**
		 * Generate the correct turn label to apply to our avatar 
		 * @param direction The direction int 
		 * @param action Either "walk" or "stand"
		 * @return String to call on our asset movieclip 
		 * 
		 */		
		private function animationLabel(direction:int, action:String):String {
			return DIRECTIONS[direction] + " " + action;
		}
		
		private function initSpriteswf():void {
			stand();
		}
	}
}