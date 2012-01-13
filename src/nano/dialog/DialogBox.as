package nano.dialog
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class DialogBox extends Sprite
	{
		private var _textfield:TextField;
		
		public function set text(val:String):void {
			this._textfield.text = val;
			this.reset();
		}
		
		public function DialogBox()
		{
			super();
			this._textfield = new TextField();
			
			this.addChild(this._textfield);
			this.render();
		}
		
		protected function reset():void {
			
		}
		
		public function render():void {
			if(! this.stage) {
				return;
			}
			
			// draw box;
			
			// position text field
		}
	}
}