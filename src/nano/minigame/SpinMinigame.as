package nano.minigame
{
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
		
		public function SpinMinigame()
		{
			super();
			this.buildAssets();
		}
		
		private function buildAssets():void {
			this.background = new Assets.instance.minigameSpinBackground();
			this.addChild(this.background);
		}
		
		
	}
}