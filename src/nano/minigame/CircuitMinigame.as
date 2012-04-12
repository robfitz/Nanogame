package nano.minigame
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import nano.Assets;
	
	/**
	 * The circuit minigame! Place that mask! 
	 * @author devin
	 * 
	 */	
	
	public class CircuitMinigame extends Minigame
	{
		
		public static const CM_STATE_DRAG:String = "drag";
		
		private static const MOUSE_LAG:Number = .6;
		private static const WIN_DIST:Number = 10;
		
		private var background:Bitmap;
		private var theMask:Sprite;
		private var maskGuide:Sprite;
		private var electrodes:Sprite;
		private var foreground:Bitmap;
		
		private var maskStart:Point;
		private var mouseStart:Point;
		private var lastMouse:Point;
		
		public function CircuitMinigame()
		{
			super();
		}
		
		override protected function buildAssets():void {
			this.electrodes = new Assets.instance.minigameCirCircuit();
			this.theMask = new Assets.instance.minigameCirMask()
			this.maskGuide = new Assets.instance.minigameCirGuide();
			this.foreground = new Assets.instance.minigameCirForground();
			
			this.addChild(this.electrodes);
			this.addChild(this.theMask);
			this.addChild(this.maskGuide);
			this.addChild(this.foreground);
			
			// Initial Position
			this.electrodes.x = 278;
			this.electrodes.y = -120;
			this.theMask.y = 220;
			this.theMask.x = 250;
			this.theMask.rotation = -6;
			this.maskGuide.y = 180;
			this.maskGuide.x = 380;
			
			// Interactive Events
			this.mouseEnabled = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			
			//SUPERMAN
			super.buildAssets();
		}
		
		override public function set state(val:String):void {
			super.state = val;
			
			switch(this.state) {
				case Minigame.STATE_PLAY:
					
					// check for win case on drop
					var xd:Number = (this.theMask.x - this.maskGuide.x) * (this.theMask.x - this.maskGuide.x);
					var yd:Number = (this.theMask.y - this.maskGuide.y) * (this.theMask.y - this.maskGuide.y);
					if(xd + yd < WIN_DIST && Math.abs(this.theMask.rotation) < 1) {
						this.state = Minigame.STATE_SUCCESS;
					}
					break;
			}
		}
		
		override public function update(dt:Number):void {
			super.update(dt);
			
			if(this.state == CM_STATE_DRAG) {
				var mouse:Point = new Point(this.mouseX, this.mouseY);
				this.theMask.x = this.maskStart.x + (mouse.x - this.mouseStart.x) / MOUSE_LAG;
				this.theMask.y = this.maskStart.y + (mouse.y - this.mouseStart.y) / MOUSE_LAG;
				 
				var spin:Number = 0;
				var mouseDiff:Point = mouse.subtract(this.lastMouse);
				var centerToMouse:Point = mouse.subtract(new Point(this.theMask.x, this.theMask.y));
				var angle:Number = Math.atan2(mouse.y - theMask.y, mouse.x - theMask.x);
				
				// Somewhat good feeling but totally fake body motion:
				// 1) Figure out what quadrant the mouse is in
				var quadrant:int;
				if(angle < 0) {
					quadrant = (angle + 2 * Math.PI) / (Math.PI / 2);
				} else {
					quadrant = angle / (Math.PI / 2);
				}				
				var quadrantMultiplier:Number = quadrant % 2 == 1 ? 1 : -1;
				
				// 2) Figure out if the pointer is moving towards or away from the center of mass, and then choose the multiplier 
				var dirMultiplier:Number = centerToMouse.x * mouseDiff.x + centerToMouse.y * mouseDiff.y > 0 ? 1 : -1;
				
				// 3) Spin is determined by multiplying the two 
				spin = quadrantMultiplier * dirMultiplier; 
				
				this.theMask.rotation = Math.min(5, Math.max(-5, this.theMask.rotation + spin * mouseDiff.length / 3));
				this.lastMouse = mouse;
			}
		}
		
		private function onMouseDown(event:MouseEvent):void {
			if(this.state == Minigame.STATE_PLAY) {
				this.state = CM_STATE_DRAG;
				this.maskStart = new Point(this.theMask.x, this.theMask.y);
				this.mouseStart = new Point(this.mouseX, this.mouseY);
				this.lastMouse = this.mouseStart.clone();
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			if(this.state == CM_STATE_DRAG) {
				this.state = Minigame.STATE_PLAY;
			}
		}
	}
}