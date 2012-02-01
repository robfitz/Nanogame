package {
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.graphics.Stroke;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
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
		
		/** Holds all the UI that rests on top of the world */
		private var gameUi:Sprite;
		
		public function Nanogame()
		{
			
			this.setGameState(GAMESTATE_LOADING);
			
			this.world = new World(this);
			this.gameUi = new Sprite();
			this.addChild(this.gameUi);
			
			// load the world!
			var loader:TmxLoader = new TmxLoader();
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				// create our world!
				world.initWorldFromLoader(loader);
				
				// create our script and dialog system
				script = new Script(new XML(new Assets.instance.game_script));
				script.world = world;
				
				var dialogUi:DialogBox = new DialogBox();
				dialogUi.visible = false;
				
				gameUi.addChild(dialogUi);
				script.dialogUi = dialogUi;
				script.dialogUi.render();
				
				startLoop();
			});
			loader.load("./assets/demo_002_reformat.tmx");
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
		}
	}
}
