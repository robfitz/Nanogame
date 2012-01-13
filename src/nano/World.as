package nano
{
	import as3isolib.display.IsoView;
	import as3isolib.display.scene.IsoScene;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;

	/**
	 * The world in which the game take place. Consists of tile layers (foreground, background)
	 * and collision and player layers.   
	 * @author devin
	 */	
	public class World
	{
		private var _hostContainer:DisplayObjectContainer;
		private var _renderTiles:Boolean = false;
		
		public var view:IsoView;
		
		public var player:Character;
		
		private var _background:IsoScene;
		public function get background():IsoScene {
			return this._background;
		}
		public function set background(val:IsoScene):void {
			this._background = val;
			this.view.addScene(this._background);
			//this._background.hostContainer = this._hostContainer;
			this.invalidateTiles();
		}
		
		private var _objects:IsoScene;
		public function get objects():IsoScene {
			return this._objects;
		}
		public function set objects(val:IsoScene):void {
			this._objects = val;
			this.view.addScene(this._objects);
			//this._objects.hostContainer = this._hostContainer;
		}
		
		private var _foreground:IsoScene;
		public function get foreground():IsoScene {
			return this._foreground;
		}
		public function set foreground(val:IsoScene):void {
			this._foreground = val;
			this.view.addScene(this._foreground);
			//this._foreground.hostContainer = this._hostContainer;
			this.invalidateTiles();
		}
		
		/** Nowalk layer */
		private var _collisions:CollisionLayer;
		public function get collisions():CollisionLayer {
			return this._collisions;
		}
		
		/** Trigger layer */
		private var _triggers:CollisionLayer;
		
		/**
		 * World contructor 
		 * @param hostContainer The container that our iso scenes ultimately render on
		 */		
		public function World(hostContainer:DisplayObjectContainer)
		{
			this._hostContainer = hostContainer;
			var stage:Stage = this._hostContainer.stage;
			this.view = new IsoView();
			this.view.setSize(stage.stageWidth, stage.stageHeight);
			this.view.panBy(0, 200);
			this._hostContainer.addChild(this.view);
		}
		
		/**
		 * Helper function that grabs all the things we need from a TmxLoader
		 * that has completed it's load
		 * @param loader TmxLoader that has successfully finished loading
		 * 
		 */		
		public function initWorldFromLoader(loader:TmxLoader):void {
			if(loader.isLoaded) {
				var scenes:Object = loader.scenes;
				
				for (var layer_name:String in loader.scenes) {
					trace("Layer name:" + layer_name);
					if (layer_name == "objects") {
						this.objects = scenes["objects"];
					}
					else {
						this.view.addScene(scenes[layer_name]);
					}
				}
				
//				this.background = scenes["background"];
//				this.objects = scenes["objects"];
//				this.foreground = scenes["foreground"];
				
				// create and add in our character at this time
				// TODO Not the best spot, really
				var img:* = new Assets.instance.Link;
				this.player = new Character(this, 100, 157, 16, 16, 64, img);
				this.objects.addChild(this.player);
				
				this._collisions= loader.getCollisionLayerByName('collisions');
				this._triggers = loader.getCollisionLayerByName('triggers');
			}
		}
		
		/**
		 * Update the world
		 * @param dt The time passed since last update
		 */
		public function update(dt:Number):void {
			
		}
		
		/**
		 * Render the scene 
		 */		
		public function render():void {
			this._objects.render();
			
			if(this._renderTiles) {
				this._background.render();
				this._foreground.render();
				this._renderTiles = false;
			}
		}
		
		/**
		 * Forces the redraw of our static background / foreground scenes. 
		 * The redraw occurs on the next frame.
		 */		
		public function invalidateTiles():void {
			this._renderTiles = true;
		}
	}
}