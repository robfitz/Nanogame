package nano
{
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.graphics.SolidColorFill;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	
	import mysa.Sheep;
	
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;

	/**
	 * The world in which the game take place. Consists of tile layers (foreground, background)
	 * and collision and player layers.   
	 * @author devin
	 */	
	public class World
	{
		public static const DEBUG_DRAW:Boolean = false;
		
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
		public function get triggers():CollisionLayer {
			return this._triggers;
		}
		
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
				
				for (var i:int = 0; i < loader.ordered_scenes.length; i ++) {
					var scene:IsoScene = loader.ordered_scenes[i];
				
					if (scene.name == "objects") {
						this.objects = scene;
					}
					else {
						this.view.addScene(scene);
					}
				}
				
//				this.background = scenes["background"];
//				this.objects = scenes["objects"];
//				this.foreground = scenes["foreground"];
				
				// create and add in our character at this time
				// TODO Not the best spot, really
				var img:* = new Assets.instance.Link;
				this.player = new Character(this, 96, 96, 16, 16, 56, null, img);
				
				if (DEBUG_DRAW) {
                    	var collision_hull:IsoBox = new IsoBox();
	                    collision_hull.setSize(player.width, player.length, player.height);
//	                    collision_hull.moveTo(object.x, object.y, 0);
	                    var f:SolidColorFill = new SolidColorFill(0xffffff, 0.2);
	                    collision_hull.fills = [f, f, f, f, f, f];
	                    objects.addChild(collision_hull);
	                    img.addEventListener(Event.ENTER_FRAME, function(e:*):void {
	                    	collision_hull.moveTo(player.x, player.y, player.z);
	                    });
//	                    sprite.addChild(collision_hull);
                    }
                var p:Character = player;
				img.addEventListener(Event.ADDED_TO_STAGE, function(e:*):void {
					p.updateDialogTriggers();
				});
				if(this.objects) {
					this.objects.addChild(this.player);
				}
				
//				for each (var objectGroup:TmxObjectGroup in loader.map.objectGroups) {
//            		for each (var object:TmxObject in objectGroup.objects) {
//            			if (object.custom && object.custom.hasOwnProperty("spawn")) {
//	                 		if (object.custom["spawn"] == "player") {
//                 				player.moveTo(object.x, object.y, 0);
//                 				view.centerOnIso(player);
//	                 		}
//	                 		else if (object.custom["spawn"] == "sheep") {
//	                 			var sheep:Sheep = new Sheep(this, 64, 64, 16, 16, 16, null, new Assets.instance.SheepImg);
//								objects.addChild(sheep);
//								sheep.moveTo(object.x, object.y, 0);	     	            			
//	                 		}
//            			}
//            		}
//            	}
				
				this._collisions= loader.getCollisionLayerByName('collisions');
				this._triggers = loader.getCollisionLayerByName('triggers');
				
				this.invalidateTiles();
				
				
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
			if(this._objects) {
				this._objects.render();
			}
			
			if(this._renderTiles) {
				
				for (var i:int = 0; i < this.view.scenes.length; i++) {
					this.view.scenes[i].render();
					
				}
				
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