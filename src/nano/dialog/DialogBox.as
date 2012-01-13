package nano.dialog
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DialogBox extends Sprite
	{
		private var _textfield:TextField;
		private var format:TextFormat;
		
		public function set text(val:String):void {
			this._textfield.text = val;
			this._textfield.setTextFormat(this.format);
			this.reset();
		}
		
		public function DialogBox()
		{
			super();
			
			this.format = new TextFormat("Lucida Grande", 24, 0x000000);
			
			this._textfield = new TextField();
			this._textfield.wordWrap = true;
			this._textfield.selectable = false;
			
			this.addChild(this._textfield);
			this.render();
			
			this.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				next();
			});
		}
		
		protected function reset():void {
			
		}
		
		/**
		 * Are there lines hidden offscreen?
		 * @return true if there are more lines of text to show
		 */		
		public function moreLines():Boolean {
			return this._textfield.scrollV + 3 < this._textfield.numLines;
		}
		
		/**
		 * Shows the next line of text
		 * @return True if there are still more lines to show
		 */		
		public function next():Boolean {
			this._textfield.scrollV += 3;
			return this.moreLines();
		}
		
		public function render():void {
			if(! this.stage) {
				return;
			}
			
			// draw box;
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0xD5ECFA);
			g.lineStyle(5, 0xffffff, 1);
			g.drawRoundRect(0, 0, this.stage.stageWidth - 100, 150, 20, 20);
			
			// position text field
			this._textfield.x = 20;
			this._textfield.y = 20;
			this._textfield.width = this.stage.stageWidth - 140;
		}
	}
}