package nano.minigame
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
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
		
		public static const DROP_GROWTH_RATE:Number = 50;
		public static const DROP_MAX_SIZE:Number = 100;
		public static const GOAL_SIZE:Number = 250;
		
		private var background:MovieClip;
		private var dropper:Bitmap;
		private var drop:Bitmap;
		
		private var dropSize:Number = 0;
		private var targetSize:Number = 0;
		private var currentTargetSize:Number = 0;
		
		public function SpinMinigame()
		{
			super();
			this.buildAssets();
		}
		
		private function buildAssets():void {
			this.background = new Assets.instance.minigameSpinBackground();
			this.dropper = new Assets.instance.minigameSpinDropper();
			this.drop = new Assets.instance.minigameSpinDrop();
			
			this.addChild(this.background);
			this.addChild(this.drop);
			this.addChild(this.dropper);
			
			
			// Initial positions
			this.dropper.x = 760 / 2 - (this.dropper.width / 2) - 10;
			this.dropper.y = -140;
			
			this.drop.x = 760 / 2 - (this.drop.width / 2) - 10;
			this.drop.y = 60;
			this.drop.scaleY = .1;
			this.drop.scaleX = .1;
			
			// Mouse Event
			this.mouseEnabled = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
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
			trace(this.state);
		}
		
		/**
		 * Update the game 
		 * @param dt Seconds passed since last update
		 */		
		override public function update(dt:Number):void {
			super.update(dt);
			
			if(this.state == SP_STATE_DROPGROW) {
				this.dropSize += DROP_GROWTH_RATE * dt;
				
				if(this.dropSize >= DROP_MAX_SIZE) {
					this.dropSize = DROP_MAX_SIZE;
					this.state = SP_STATE_DROPFALL;
				}
			}
			else if(this.state == SP_STATE_DROPFALL) {
				// do falling stuff here
			}
		}
		
		/**
		 * Draw shit and stuff 
		 */		
		override public function render():void {
			
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