package nano.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import nano.Assets;
	import nano.level.Dialog;
	
	public class DialogBox extends Sprite
	{
		private var _textfield:TextField;
		private var format:TextFormat;
		
		private var moreButton:Sprite;
		
		private var currentDialog:Dialog;
		private var currentLine:int = 0;
		
		// our cutscenes
		private var cutsceneMask:Sprite;
		private var cutscene:Cutscene;
		
		public function DialogBox()
		{
			super();
			
			this.cutsceneMask = new Sprite();
			
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
					
					if(! this.cutscene || this.cutscene.cutsceneName != line.cutscene) {
						// Remove old cutscene and create the new one
						if(this.cutscene && this.contains(this.cutscene)) {
							this.removeChild(this.cutscene);
						}
						
						this.cutscene = new Cutscene(line.cutscene);
						this.addChild(this.cutscene);
						this.cutscene.cue(line.cue);
						this.render();
					} else {
						// Cutscene is the right cutscene, cue up the right part
						this.cutscene.cue(line.cue);
					}
					
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
			
			if(this.cutscene) {
				this.cutscene.y = top;
			}
		}
	}
}