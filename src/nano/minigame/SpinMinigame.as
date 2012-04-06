package nano.minigame
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import nano.AssetLoader;
	import nano.Assets;
	
	/**
	 * The always fun spincoater minigame.  
	 * @author devin
	 * 
	 */	
	
	public class SpinMinigame extends Minigame
	{
		
		public static const SP_STATE_DROPGROW:String = "dropgrow";
		public static const SP_STATE_DROPFALL:String = "dropfall";
		public static const SP_STATE_SPLASH:String = "splash";
		
		public static const DROP_GROWTH_RATE:Number = 50;
		public static const DROP_MAX_SIZE:Number = 100;
		public static const GOAL_SIZE:Number = 260;
		public static const GOAL_THRESHOLD:Number = 245;
		
		private var background:MovieClip;
		private var dropper:Bitmap;
		private var drop:Sprite;
		private var matte:Sprite;
		
		private var dropSize:Number = 0;
		private var targetSize:Number = 0;
		private var currentTargetSize:Number = 0;
		
		private var dropVelocity:Number = 0;
		
		public function SpinMinigame()
		{
			super();
			this.buildAssets();
		}
		
		override protected function buildAssets():void {
			this.background = new Assets.instance.minigameSpinBackground();
			this.dropper = new Assets.instance.minigameSpinDropper();
			this.drop = new Sprite();
			var dropImg:Bitmap = new Assets.instance.minigameSpinDrop();
			this.drop.addChild(dropImg);
			this.matte = new Sprite();
			
			this.addChild(this.background);
			this.addChild(this.drop);
			this.addChild(this.dropper);
			this.addChild(this.matte);
			
			// Initial positions
			this.background.y = 43;
			this.background.x = 11;
			
			this.dropper.x = 760 / 2 - (this.dropper.width / 2);
			this.dropper.y = -140;
			
			dropImg.y = 0;
			dropImg.x = -dropImg.width / 2;
			dropImg.smoothing = true;
			
			this.drop.x = 760 / 2;
			this.drop.y = 60;
			this.drop.scaleX = .1;
			this.drop.scaleY = .1;
			this.drop.visible = false;
			
			// Mouse Event
			this.mouseEnabled = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			
			// SUPERMAN!
			super.buildAssets();
		}
		
		override protected function startMinigame():void {
			
		}
		
		/**
		 * State being set! 
		 * @param val The new state
		 * 
		 */		
		override public function set state(val:String):void {
			var oldState:String = val;
			super.state = val;
			
			switch(this.state) {
				case STATE_PLAY:
					this.drop.visible = false;
					break;
				case SP_STATE_DROPGROW:
					this.drop.visible = true;
					break;
				case SP_STATE_SPLASH:
					this.drop.visible = false;
					this.drop.y = 60;
					this.dropSize = 0;
					this.state = Minigame.STATE_PLAY;
					break;
				case Minigame.STATE_FAIL:
					this.dropSize = 0;
					this.targetSize = 0;
					this.currentTargetSize = 0;
					this.drop.y = 60;
					this.matte.graphics.clear();
					this.state = Minigame.STATE_PLAY;
					break;
			}
		}
		
		/**
		 * Update the game 
		 * @param dt Seconds passed since last update
		 */		
		override public function update(dt:Number):void {
			super.update(dt);
			
			if(this.targetSize > 0 && this.currentTargetSize != this.targetSize) {
				this.currentTargetSize += (this.targetSize - this.currentTargetSize) / 5;
				
				if(this.currentTargetSize > GOAL_SIZE) {
					this.state = Minigame.STATE_FAIL;
				}
				
				if(this.isClose(this.currentTargetSize, this.targetSize)) {
					this.currentTargetSize = this.targetSize;
					
					// Check to see if we're done growing visually, and if we should continue, win, or fail
					if(this.currentTargetSize <= GOAL_SIZE && this.currentTargetSize > GOAL_THRESHOLD) {
						this.state = Minigame.STATE_SUCCESS;
					}
				}
			}
			
			if(this.state == SP_STATE_DROPGROW) {
				this.dropSize += DROP_GROWTH_RATE * dt;
				
				if(this.dropSize >= DROP_MAX_SIZE) {
					this.dropSize = DROP_MAX_SIZE;
					this.state = SP_STATE_DROPFALL;
				}
			}
			else if(this.state == SP_STATE_DROPFALL) {
				this.dropVelocity += 250 * dt;
				this.drop.y += this.dropVelocity * dt;
				
				if(this.drop.y >= 200 - this.drop.height) {
					this.drop.y = 200 - this.drop.height;
					this.targetSize += this.dropSize;
					this.state = SP_STATE_SPLASH;
				}
			}
		}
		
		/**
		 * Draw shit and stuff 
		 */		
		override public function render():void {
			
			// the wierd division at the end is a size adustment. We want the max sie of the circle
			// to be 166 when it's perfectly sized
			var dropScale:Number = Math.max(.1, this.dropSize / DROP_MAX_SIZE) * .5; 
			this.drop.scaleX = dropScale;
			this.drop.scaleY = dropScale;
			
			if(this.currentTargetSize > 0) {
				var g:Graphics = this.matte.graphics;
				var radius:Number = this.currentTargetSize * (165 / GOAL_SIZE);
				var jigglex:Number = Math.random() - .5;
				var jiggley:Number = Math.random() - .5;
				
				g.clear();
				g.beginFill(0xDCE9EA, .8);
				g.lineStyle(1, 0x23B5C4, .6);
				g.drawEllipse(760 / 2 - radius / 2 + jigglex, 200 - (radius * .5) / 2 + jiggley, radius, radius * .5);
				g.endFill();
			}
		}
		
		private function onMouseDown(event:MouseEvent):void {
			if(this.state == Minigame.STATE_PLAY) {
				this.state = SP_STATE_DROPGROW;
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			if(this.state == SP_STATE_DROPGROW) {
				this.state = SP_STATE_DROPFALL;
			}
		}
	}
}