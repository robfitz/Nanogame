package nano.minigame
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import nano.Assets;
	
	/**
	 * The always fun spincoater minigame.  
	 * @author devin
	 * 
	 */	
	
	public class SpinMinigame extends Minigame
	{
		
		private var background:MovieClip;
		private var dropper:Bitmap;
		
		public function SpinMinigame()
		{
			super();
			this.buildAssets();
		}
		
		private function buildAssets():void {
			this.background = new Assets.instance.minigameSpinBackground();
			this.dropper = new Assets.instance.minigameSpinDropper();
			
			this.addChild(this.background);
			this.addChild(this.dropper);
			
			// Initial positions
			this.dropper.x = 760 / 2 - (this.dropper.width / 2) - 10;
			this.dropper.y = -140;
		}
	}
}