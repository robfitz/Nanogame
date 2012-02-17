package {
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.graphics.Stroke;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	
	import nano.AssetLoader;
	import nano.Assets;
	import nano.CollisionLayer;
	import nano.TmxLoader;
	import nano.World;
	import nano.level.Script;
	import nano.ui.DialogBox;
	
	/**
	 * Nanogame.as
	 * Top level control flow and execution for Nanogame
	 */

	[SWF(width='760', height='570')]
	public class Nanogame extends Sprite
	{
		
		// Master states of the game
		public const GAMESTATE_LOADING:String = "gamestate loading";
		public const GAMESTATE_MENU:String = "gamestate menu";
		public const GAMESTATE_INGAME:String = "gamestate ingame";
		
		private var _state:String;
		public function get state():String {
			return _state;
		}
		
		/** Current frame time in milliseconds since game start */
		private var now:int = 0;
		
		/** Last frame time in milliseconds */
		private var then:int = 0;
		
		/** Controlling script for the current world */
		private var script:Script;
		
		/** The isometric world our main character lives in */
		private var world:World;
		
		/** The main menu */
		private var mainMenu:MovieClip;
		
		/** Holds all the UI that rests on top of the world */
		private var gameUi:Sprite; 
		
		/** Name of the current level being played */
		private var currentLevel:String;
		
		public function Nanogame()
		{
			this.gameUi = new Sprite();
			this.addChild(this.gameUi);
			this.setGameState(GAMESTATE_LOADING);
			
			this.graphics.beginFill(0x555555);
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.graphics.endFill();
		}
		
		/**
		 * Starts the game loop and subsequently the interactive game 
		 */		
		public function startLoop():void {
			this.now = flash.utils.getTimer();
			this.addEventListener(Event.ENTER_FRAME, this.loopdeloop);
		}
		
		/**
		 * Stops the game for the time being
		 */
		public function stopLoop():void {
			this.removeEventListener(Event.ENTER_FRAME, this.loopdeloop);
		}
		
		public function loopdeloop(event:Event):void {
			this.then = this.now;
			this.now = flash.utils.getTimer();
			var dt:Number = (this.now - this.then) / 1000.0;
			this.update(dt);
			this.render();
		}
		
		/**
		 * Update game logic 
		 * @param dt Time (in seconds) since the last frame
		 */		
		public function update(dt:Number):void {
			// We always update the world first, since the script will look at the current state
			// to decide if something significant happened
			this.world.update(dt);
			this.script.update(dt);
		}
		
		/**
		 * Render game object that need to be blitted to the screen
		 */		
		public function render():void {
			this.world.render();
		}
		
		public function setGameState(newState:String):void {
			var oldState:String = this.state;
			this._state = newState;
			
			switch(this.state) {
				case GAMESTATE_LOADING:
					if(this.stage.loaderInfo.bytesLoaded != this.stage.loaderInfo.bytesTotal) { 
						this.stage.loaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onGameLoading);
						this.stage.loaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
							trace('yeah');
						});
					} else {
						this.setGameState(GAMESTATE_MENU);
					}
					break;
				
				case GAMESTATE_MENU:
					this.stopLoop();
					
					if(this.world && this.contains(this.world.view)) {
						this.removeChild(this.world.view);
						this.world = null;
					}
					
					if(! this.mainMenu) {
						var loader:AssetLoader = new AssetLoader(Assets.instance.main_menu);
						loader.addEventListener(Event.COMPLETE, function(event:Event):void {
							mainMenu = (event.target as AssetLoader).asset;
							gameUi.addChild(mainMenu);
							gameUi.visible = true;
							mainMenu['level1'].addEventListener(MouseEvent.CLICK, onLevelClick);
							mainMenu['level2'].addEventListener(MouseEvent.CLICK, onLevelClick);
							mainMenu['level3'].addEventListener(MouseEvent.CLICK, onLevelClick);
						});
					} else {
						this.gameUi.addChild(this.mainMenu);
						this.gameUi.visible = true;
					}
					break;
				
				case GAMESTATE_INGAME:
					this.gameUi.removeChild(this.mainMenu);
					this.initLevel(this.currentLevel);
			}
		}
		
		/**
		 * Called while the game is loading 
		 */		
		private function onGameLoading(event:ProgressEvent):void {
			trace("progress");
			if(event.bytesLoaded == event.bytesTotal) {
				this.setGameState(GAMESTATE_MENU);
			}
		}
		
		/**
		 * Loads and preps a level for play 
		 * TODO :: Load different levels
		 */		
		private function initLevel(scriptName:String):void {
			// create out world
			this.world = new World(this);
			this.addChildAt(this.world.view, 0);
			
			// load the current script
			this.script = new Script(new XML(new Assets.instance[scriptName]));
			this.script.addEventListener(Event.COMPLETE, onScriptComplete);
			this.script.world = world;
			
			// our UI
			var dialogUi:DialogBox = new DialogBox();
			dialogUi.visible = false;
			this.gameUi.addChild(dialogUi);
			this.script.dialogUi = dialogUi;
			this.script.dialogUi.render();
			
			// kick off the game
			startLoop();
			script.startLevel();
		}
				
		private function onLevelClick(event:Event):void {
			switch(event.target.name) {
				case "level1":
					this.currentLevel = "script_stretch";
					break;
				case "level2":
					this.currentLevel = "script_solar";
					break;
				case "level3":
					this.currentLevel = "script_cancer";
					break;
			}
			
			this.setGameState(GAMESTATE_INGAME);
		}
		
		private function onScriptComplete(event:Event):void {
			(event.target as Script).removeEventListener(Event.COMPLETE, onScriptComplete);
			this.script.world = null;
			this.script = null;
			this.setGameState(GAMESTATE_MENU);
		}
	}
}
