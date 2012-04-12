package nano.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import nano.Assets;
	import nano.level.Dialog;
	import nano.minigame.CancerMinigame;
	import nano.minigame.Minigame;
	import nano.minigame.SpinMinigame;
	
	public class DialogBox extends Sprite
	{
		public static const BOX_HEIGHT:int = 222;
		
		public static const CUTSCENE_WIDTH:int = 760;
		public static const CUTSCENE_HEIGHT:int = 346;
		
		private var _textfield:TextField;
		private var format:TextFormat;
		
		private var moreButton:Sprite;
		
		private var currentDialog:Dialog;
		private var currentLine:int = 0;
		
		private var nextButton:Button;
		
		// our cutscenes
		private var cutscene:Cutscene;
		private var minigame:Minigame;
		private var professor:Cutscene;
		
		private var isPlayingGame:Boolean = false;
		private var minigameEndTimer:Timer;
		
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
			if(this.isPlayingGame) {
				return;
			}
			
			if(this.currentLine < this.currentDialog.lines.length) {
				var line:Object = this.currentDialog.lines[this.currentLine];
				
				this._textfield.text = line.text;
				this._textfield.setTextFormat(this.format);
				
				if(line.cutscene) {
					
					if(line.type == "game") {
						// Special interactive cutscnene. Load it up.
						this.minigame = this.getMinigame(line.cutscene);
						this.addChild(this.minigame);
						this.minigame.addEventListener(Event.COMPLETE, this.onMinigameWin);
						this.minigame.state = Minigame.STATE_PLAY;
						this.isPlayingGame = true;
					} 
					else if(! this.cutscene || this.cutscene.cutsceneName != line.cutscene) {
						// Remove old cutscene and create the new one
						if(this.cutscene && this.contains(this.cutscene)) {
							this.removeChild(this.cutscene);
						}
						
						this.cutscene = new Cutscene(line.cutscene, new Rectangle(0, 0, CUTSCENE_WIDTH, CUTSCENE_HEIGHT));
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
		
		public function update(dt:Number):void {
			if(this.minigame) {
				this.minigame.update(dt);
				// the reason this is here, and not in the render() method below
				// is that render method wasn't designed to be hooked into the 
				// real render stack.. shouldn't be a problem though cause if your
				// reading this and not me, well, good luck buddy. 
				this.minigame.render();
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
		
		/**
		 * Called when a player wins a minigame! 
		 * @param event
		 * 
		 */		
		private function onMinigameWin(event:Event):void {
			this.minigameEndTimer = new Timer(500, 1);
			this.minigameEndTimer.start();
			this.minigameEndTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.closeMinigame);
		}
		
		private function closeMinigame(event:TimerEvent):void {
			this.isPlayingGame = false;
			this.removeChild(this.minigame);
			this.minigame.removeEventListener(Event.COMPLETE, this.onMinigameWin);
			this.minigame = null;
			this.next();
		}
		
		/**
		 * Creates and returns minigames 
		 * @param classKey
		 * @return A minigame
		 * 
		 */		
		private function getMinigame(classKey:String):Minigame {
			switch(classKey) {
				case "minigameCancer":
					return new CancerMinigame();
				case "minigameSolar":
					return new SpinMinigame();
			}
			return null;
		}
	}
}