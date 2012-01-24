package nano
{
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.SolidColorFill;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mysa.Sheep;
	
	import nano.scene.ObjectScene;
	
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
		
		private var _objects:IsoScene;
		public function get objects():IsoScene {
			return this._objects;
		}
		public function set objects(val:IsoScene):void {
			this._objects = val;
			this.view.addScene(this._objects);
		}
		
		public var grid:IsoGrid;
		public var gridScene:IsoScene;
		
		// TODO :: REMOVE THIS ONCE MYSA IS DECOUPLED
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
		
		// TODO :: REMOVE THIS ONCE MYSA IS DECOUPLED
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
		
		/** Markers */
		private var _markers:ObjectScene;
		
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
			//this.view.panBy(0, 200);
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
				
				// Create and add all our tile scenes
				var scenes:Object = loader.tileScenes;
				for (var i:int = 0; i < loader.orderedTileScenes.length; i ++) {
					var scene:IsoScene = loader.orderedTileScenes[i];
				
					if (scene.name == "objects") {
						this.objects = scene;
					}
					else {
						this.view.addScene(scene);
					}
				}
				this.objects = loader.objectScene;
				
				
				// Create and add in our character at this time
				var img:* = new Assets.instance.player_suited;
				this.player = new Character(this, new Assets.instance.player_suited);
				
				if (DEBUG_DRAW) {
                	var collision_hull:IsoBox = new IsoBox();
                    collision_hull.setSize(player.width, player.length, player.height);
                    var f:SolidColorFill = new SolidColorFill(0xffffff, 0.2);
                    collision_hull.fills = [f, f, f, f, f, f];
                    objects.addChild(collision_hull);
                    img.addEventListener(Event.ENTER_FRAME, function(e:*):void {
                    	collision_hull.moveTo(player.x, player.y, player.z);
                    });
                }
				
                
				var p:Character = player;
				img.addEventListener(Event.ADDED_TO_STAGE, function(e:*):void {
					p.updateDialogTriggers();
				});
				
				// add player
				this.objects.addChild(this.player);
				
				if(loader.spawnPoint) {
					this.player.moveTo(loader.spawnPoint.x, loader.spawnPoint.y, 0);
				}
				
				this._collisions= loader.getCollisionLayerByName('collisions');
				this._triggers = loader.getCollisionLayerByName('triggers');
				
				// Create and add the grid that the user will click
				this.grid = new IsoGrid();
				this.grid.setGridSize(loader.map.width, loader.map.height, 0);
				this.grid.cellSize = 32;
				this.gridScene = new IsoScene();
				this.gridScene.addChild(this.grid);
				this.view.addScene(this.gridScene);
				
				this.grid.addEventListener(MouseEvent.CLICK, this.onGridClick);
				
				// Finish up by forcing a complete redraw
				this.invalidateTiles();
			}
		}
		
		/**
		 * Update the world
		 * @param dt The time passed since last update
		 */
		public function update(dt:Number):void {
			if(this.player) {
				this.player.update(dt);
			}
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
		
		/**
		 * The user has clicked on the host container 
		 * @param event The mouse event
		 * 
		 */		
		private function onGridClick(event:ProxyEvent):void {
			var mEvent:MouseEvent = event.targetEvent as MouseEvent;
			var pt:Pt = this.stageToWorld(mEvent.stageX, mEvent.stageY);
			this.player.walkTo(pt);
		}
		
		/**
		 * Convert a stage coordinates to a position in our world space. 
		 * @param x X position on the stage 
		 * @param y Y position on the state
		 * @return Pt representing position in the world
		 * 
		 */		
		public function stageToWorld(x:Number, y:Number):Pt {
			trace("-------------------------------------------");
			trace("      Stage Position:", x, y);
			var stage:Stage = this._hostContainer.stage;
			var pt:Pt = new Pt(x - stage.stageWidth / 2 + this.view.currentX, y - stage.stageHeight / 2 + this.view.currentY);
			trace(" Normalized Position:", pt);
			return IsoMath.screenToIso(pt); 
		}
	}
}