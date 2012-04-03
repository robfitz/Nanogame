package nano.minigame
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import nano.Assets;
	
	/**
	 * Let's cure cancer with this Minigame. Stand alone game executable routine.   
	 * @author devin
	 * 
	 */	
	public class CancerMinigame extends Minigame
	{
		
		private var arm:Bitmap;
		private var clipboard:Bitmap;
		private var background:Bitmap;
		
		public function CancerMinigame()
		{
			super();
			this.buildAssets();
		}
		
		private function buildAssets():void {
			this.background = new Assets.instance.minigameCancerBackground();
			this.arm = new Assets.instance.minigameCancerArm();
			this.clipboard = new Assets.instance.minigameCancerClipboard();
			
			this.addChild(this.background);
			this.addChild(this.arm);
			this.addChild(this.clipboard);
			
			// initial positions
			this.arm.x = 20;
			this.arm.y = -130;
			
			this.clipboard.x = 470;
			this.clipboard.y = 70;
		}
		
		override public function update(dt:Number):void {
			super.update(dt);
			
		}
		
		override protected function startMinigame():void {
			super.startMinigame();
		}
	}
}