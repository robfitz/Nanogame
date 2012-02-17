package nano.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import nano.Assets;
	import nano.level.Dialog;
	
	public class DialogBox extends Sprite
	{
		public const BOX_HEIGHT:int = 222;
		
		private var _textfield:TextField;
		private var format:TextFormat;
		
		private var moreButton:Sprite;
		
		private var currentDialog:Dialog;
		private var currentLine:int = 0;
		
		private var nextButton:Button;
		
		// our cutscenes
		private var cutscene:Cutscene;
		private var professor:Cutscene;
		
		public function DialogBox()
		{
			super();
			
			this.format = new TextFormat("Lucida Grande", 24, 0x000000);
			
			this._textfield = new TextField();
			this._textfield.wordWrap = true;
			this._textfield.selectable = false;
			this.addChild(this._textfield);
			
			this.nextButton = new Button("Next..");
			this.addChild(this.nextButton);
			
			this.professor = new Cutscene("professor");
			this.addChild(this.professor);
			
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
						
						this.cutscene = new Cutscene(line.cutscene, new Rectangle(0, 0, 760, 346));
						this.addChild(this.cutscene);
						this.cutscene.cue(line.cue);
						this.render();
					} else {
						// Cutscene is the right cutscene, cue up the right part
						this.cutscene.cue(line.cue);
					}
					
				} else {
					// professor, so something cool to fill the gap!
					if(this.cutscene && this.contains(this.cutscene)) {
						this.removeChild(this.cutscene);
					}
					this.professor.cue("talk");
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
			var height:int = BOX_HEIGHT;
			var top:int = this.stage.stageHeight - height;
			
			this.nextButton.x = width - this.nextButton.buttonWidth - 20;
			this.nextButton.y = top - this.nextButton.buttonHeight / 2;
			
			var g:Graphics = this.graphics;
			g.clear();
			
			// draw background
			g.beginFill(0xffffff);
			g.lineStyle(4, 0xdce4e4);
			g.drawRect(0, top, width, height);
			
			// position text field
			this._textfield.x = 240;
			this._textfield.y = top + 20;
			this._textfield.width = width - 240 - 20;
			this._textfield.height = height - 40;
			
			if(this.professor) {
				this.professor.x = 2;
				this.professor.y = top + 2;
			}
		}
	}
}