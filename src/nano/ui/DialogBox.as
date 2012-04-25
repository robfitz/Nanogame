package nano.ui
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import nano.AssetLoader;
	import nano.Assets;
	import nano.level.Dialog;
	import nano.minigame.CancerMinigame;
	import nano.minigame.CircuitMinigame;
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
		private var currentLineIndex:int = 0;
		
		private var displayChar:uint = 0;
		private var displayText:String;
		
		private var nextButton:MovieClip;
		
		// our cutscenes
		private var cutscene:Cutscene;
		private var minigame:Minigame;
		private var professor:Cutscene;
		
		// special wipe cutscene is created once the game in init
		public var wipe:MovieClip;
		
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
			
			var _this:DialogBox = this;
			var buttonLoader:AssetLoader = new AssetLoader(Assets.instance.nextbutton);
			buttonLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
				_this.nextButton = event.target.asset;
				_this.addChild(_this.nextButton);
				_this.render();
			});
			
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
			this.currentLineIndex = 0;
			next();
		}
		
		/**
		 * Plays a fullscreen wipe 
		 * 
		 */		
		public function doWipe():void {
			if(this.wipe && ! this.contains(this.wipe)) {
				this.addChild(this.wipe);
				this.wipe.gotoAndPlay(1);
				
				var wipeTimer:Timer = new Timer(600, 1);
				wipeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.wipeEnd);
				wipeTimer.start();
			}
		}
		
		private function wipeEnd(event:Event):void {
			(event.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, this.wipeEnd);
			if(this.contains(this.wipe)) {
				this.removeChild(this.wipe);
			}
		}
		
		/**
		 * Shows the next line of text
		 * @return True if there are still more lines to show
		 */		
		public function next():void {
			if(this.isPlayingGame) {
				return;
			}
			
			if(this.currentLineIndex < this.currentDialog.lines.length) {
				var line:Object = this.currentDialog.lines[this.currentLineIndex];
				
				this._textfield.text = "";
				this.displayChar = 0;
				this.displayText = line.text;
				
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
						if(! this.contains(this.cutscene)) {
							this.addChild(this.cutscene);
						}
						this.cutscene.cue(line.cue);
					}
					
				} else {
					// professor, so something cool to fill the gap!
					if(this.cutscene && this.contains(this.cutscene)) {
						this.removeChild(this.cutscene);
					}
				}
				
				// professor always talks
				this.professor.cue("talk");
				
				this.currentLineIndex ++;
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
			
			if(this.displayText && this.displayChar < this.displayText.length) {
				this.displayChar = Math.min(this.displayChar + 2, this.displayText.length);
				this._textfield.text = this.displayText.substr(0, this.displayChar);
				this._textfield.setTextFormat(this.format);
			}
		}
		
		public function render():void {
			if(! this.stage) {
				return;
			}
			
			var width:int = this.stage.stageWidth;
			var height:int = BOX_HEIGHT;
			var top:int = this.stage.stageHeight - height;
			
			if(this.nextButton) {
				this.nextButton.x = width - this.nextButton.width - 10;
				this.nextButton.y = top + 140;
			}
			
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
				case "minigameCircuit":
					return new CircuitMinigame();
			}
			return null;
		}
	}
}