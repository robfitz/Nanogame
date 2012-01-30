package nano.ui
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
		
		private var moreButton:Sprite;
		
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
				if (!next()) {
					this.visible = false;
				}
			});
			
			// make our more button
			moreButton = new Sprite();
			
			var moreText:TextField = new TextField();
			moreText.x = 10;
			moreText.y = 2;
			moreText.text = "next...";
			moreText.setTextFormat(new TextFormat("Lucida Grande", 18, 0x0));
			moreText.selectable = false;
			
			moreButton.addChild(moreText);
			
			moreButton.graphics.beginFill(0xD5ECFA);
			moreButton.graphics.lineStyle(2, 0x333333, 1);
			moreButton.graphics.drawRoundRect(0, 0, 80, 30, 5, 5);
			
//			this.addChild(moreButton);
		}
		
		protected function reset():void {
			if (this._textfield.numLines > 3) {
				moreButton.visible = true;
			}
			else moreButton.visible = false;
		}
		
		/**
		 * Are there lines hidden offscreen?
		 * @return true if there are more lines of text to show
		 */		
		public function moreLines():Boolean {
			trace(this._textfield.scrollV + 3, this._textfield.numLines);
			return this._textfield.scrollV + 3 < this._textfield.numLines;
		}
		
		/**
		 * Shows the next line of text
		 * @return True if there are still more lines to show
		 */		
		public function next():Boolean {
			this._textfield.scrollV += 3;
			this.render();
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
			
			// position more button
			this.moreButton.x = (this.stage.stageWidth - 100 - 75);
			this.moreButton.y = 150 - 25;
			this.moreButton.visible = this.moreLines();
		}
	}
}