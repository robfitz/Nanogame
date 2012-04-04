package nano.minigame
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import nano.AssetLoader;
	import nano.Assets;
	
	/**
	 * Let's cure cancer with this Minigame. Stand alone game executable routine.   
	 * @author devin
	 * 
	 */	
	public class CancerMinigame extends Minigame
	{
		public static const CM_STATE_BOUNCING:String = "bouncing";
		public static const CM_STATE_DROP_SUCCESS:String = "drop success";
		public static const CM_STATE_DROP_FAIL:String = "drop fail";
		public static const CM_RESET_DROP:String = "reset drop";
		
		private static const TARGET_RADIUS:Number = 20;
		
		/** Offset to the 'tip' of the syringe */
		private static const ARM_OFFSET_X:Number = 239;
		private static const ARM_OFFSET_Y:Number = 348;
		
		private var arm:Bitmap;
		private var clipboard:MovieClip;
		private var background:Bitmap;
		
		private var armVelocity:Number = 200;
		
		private var targets:Array;
		private var targetIndex:uint = 0;
		
		private function get currentTarget():Object {
			return this.targets[this.targetIndex];
		}
		
		public function CancerMinigame()
		{
			super();
			this.buildAssets();
		}
		
		private function buildAssets():void {
			this.background = new Assets.instance.minigameCancerBackground();
			this.arm = new Assets.instance.minigameCancerArm();
			
			this.addChild(this.background);
			this.addChild(this.arm);
			
			var _this:CancerMinigame = this;
			var clipboardLoader:AssetLoader = new AssetLoader(Assets.instance.minigameCancerClipboard);
			clipboardLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
				clipboard = (event.target).asset;
				clipboard.x = 470;
				clipboard.y = 70;
				_this.addChild(clipboard);
			});
			
			// initial setups
			this.arm.x = 20;
			this.arm.y = -220;
			
			// events
			this.mouseChildren = false;
			this.mouseEnabled = true;
			this.addEventListener(MouseEvent.CLICK, this.onMatteClick);
			
			// targets
			this.targets = [
				{ position: new Point(107, 192) },
				{ position: new Point(226, 243) },
				{ position: new Point(331, 225) },
				{ position: new Point(436, 225) }
			];
			
			// DEBUG DRAWING
			var matte:Sprite = new Sprite();
			matte.graphics.beginFill(0xff00ff);
			for each(var traget:Object in this.targets) {
				matte.graphics.drawCircle(traget.position.x, traget.position.y, 10);
			}
		}
		
		override public function update(dt:Number):void {
			super.update(dt);
			
			switch(this.state) {
				case CM_STATE_BOUNCING:
					this.arm.x += armVelocity * dt;
					
					if(this.arm.x > 300) {
						this.armVelocity *= -1;
						this.arm.x = 300;
					} else if(this.arm.x < -200) {
						this.arm.x = -200;
						this.armVelocity *= -1;
					}
					
					break;
				
				case CM_STATE_DROP_FAIL:
					this.arm.y += (-140 - this.arm.y) / 5;
					
					if(isClose(this.arm.y, -150)) {
						this.state = CM_RESET_DROP;
					}
					break;
				
				case CM_STATE_DROP_SUCCESS:
					var p:Point = this.currentTarget.position;
					
					this.arm.x += (p.x - (this.arm.x + ARM_OFFSET_X)) / 5;
					this.arm.y += (p.y - (this.arm.y + ARM_OFFSET_Y)) / 5;
					
					if(isClose(this.arm.x + ARM_OFFSET_X, p.x) && isClose(this.arm.y + ARM_OFFSET_Y, p.y)) {
						this.state = CM_RESET_DROP;
					}
					
					break;
				
				case CM_RESET_DROP:
					this.arm.y += (-220 - this.arm.y) / 6;
					
					if(this.arm.y < -218) {
						this.arm.y = -220;
						this.state = CM_STATE_BOUNCING;
					}
			}
		}
		
		override protected function startMinigame():void {
			super.startMinigame();
			
			this.state = CM_STATE_BOUNCING;
		}
		
		override public function set state(val:String):void {
			var oldState:String = this.state;
			
			super.state = val;
			
			switch(this.state) {
				case CM_RESET_DROP:
					if(oldState == CM_STATE_DROP_SUCCESS) {
						this.targetIndex ++;
						if(this.targetIndex == this.targets.length) {
							this.state = Minigame.STATE_SUCCESS;
						} else {
							this.updateGoal();
						}
					}
					break;
			}
		}
		
		/**
		 * Update the visual state of the goal
		 */		
		private function updateGoal():void {
			
		}
		
		private function onMatteClick(event:Event):void {
			if(this.state == CM_STATE_BOUNCING) {
				if(Math.abs(this.currentTarget.position.x - (this.arm.x + ARM_OFFSET_X)) <= TARGET_RADIUS) {
					this.state = CM_STATE_DROP_SUCCESS;
				} else {
					this.state = CM_STATE_DROP_FAIL;
				}
			}
		}
		
		private function isClose(a:Number, b:Number, radius:Number = 2):Boolean {
			return Math.abs(a - b) <= radius;
		}
	}
}