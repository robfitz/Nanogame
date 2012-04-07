package nano.minigame
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	/**
	 * The circuit minigame! Place that mask! 
	 * @author devin
	 * 
	 */	
	
	public class CircuitMinigame extends Minigame
	{
		private var background:Bitmap;
		private var theMask:MovieClip;
		private var maskTarget:MovieClip;
		private var electrodes:Bitmap;
		private var foreground:Bitmap;
		
		public function CircuitMinigame()
		{
			super();
		}
		
		override protected function buildAssets():void {
			
			//SUPERMAN
			super.buildAssets();
		}
		
		override public function set state(val:String):void {
			super.state = val;
		}
		
		override public function update(dt:Number):void {
			super.update(dt);
		}

	}
}