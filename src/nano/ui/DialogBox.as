package nano.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import nano.level.Dialog;
	
	public class DialogBox extends Sprite
	{
		private var _textfield:TextField;
		private var format:TextFormat;
		
		private var moreButton:Sprite;
		
		private var currentDialog:Dialog;
		private var currentLine:int = 0;
		
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
		
		/**
		 * Shows the dialog given to it 
		 */		
		public function display(dialog:Dialog):void {
			this.visible = true;
			this.currentDialog = dialog;
			this.currentLine = 0;
			next();
		}
		
		
		/**
		 * Shows the next line of text
		 * @return True if there are still more lines to show
		 */		
		public function next():void {
			if(this.currentLine < this.currentDialog.lines.length) {
				var line:Object = this.currentDialog.lines[this.currentLine];
				
				this._textfield.text = line.text;
				this._textfield.setTextFormat(this.format);
				
				if(line.cutscene) {
					trace("TODO:: Show cutscene for line");
				}
				
				this.currentLine ++;
			} else {
				// signal that the dialog is done
				this.dispatchEvent(new Event(Event.COMPLETE));
				this.visible = false;
			}
		}
		
		public function render():void {
			if(! this.stage) {
				return;
			}
			
			var width:int = this.stage.stageWidth;
			var height:int = this.stage.stageHeight * .4;
			var top:int = this.stage.stageHeight - height;
			
			var g:Graphics = this.graphics;
			g.clear();
			
			// draw background
			g.beginFill(0xffffff);
			g.lineStyle(2, 0xdce4e4);
			g.drawRect(0, top, width, height);
			
			// borders
			
			// dividers
			
			// position text field
			this._textfield.x = 240;
			this._textfield.y = top + 20;
			this._textfield.width = width - 240 - 20;
			this._textfield.height = height - 40;
		}
	}
}