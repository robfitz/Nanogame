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
	
	import nano.scene.GameObject;
	import nano.scene.GameObjectEvent;
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
		
		public var isUpdating:Boolean = true;
		
		private var _hostContainer:DisplayObjectContainer;
		private var _renderTiles:Boolean = false;
		
		public var view:IsoView;
		
		public var grid:IsoGrid;
		
		public var gridScene:IsoScene;
		
		public var player:Character;
		
		/** The thing the player is currently walking to, if any */
		public var currentTarget:GameObject;
		
		private var _objects:ObjectScene;
		public function get objects():ObjectScene {
			return this._objects;
		}
		public function set objects(val:ObjectScene):void {
			this._objects = val;
			this.view.addScene(this._objects);
		}
		
		/** NoWalk Layer */
		private var _collisions:CollisionLayer;
		public function get collisions():CollisionLayer {
			return this._collisions;
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
				
				var scenes:Object = loader.tileScenes;
				
				// Create and add the grid that the user will click
				this.grid = new IsoGrid();
				this.grid.setGridSize(loader.map.width, loader.map.height, 0);
				this.grid.cellSize = 32;
				this.gridScene = new IsoScene();
				this.gridScene.addChild(this.grid);
				
				// Inject scenes in order
				this.view.addScene(scenes['background']);
				this.view.addScene(this.gridScene);
				this.objects = loader.objectScene;
				this.view.addScene(scenes['foreground']);
				
				// Create and add in our character at this time
				var img:* = new Assets.instance.player_suited;
				this.player = new Character(this, new Assets.instance.player_suited);
                
				var p:Character = player;
				img.addEventListener(Event.ADDED_TO_STAGE, function(e:*):void {
					p.updateDialogTriggers();
				});
				
				// add player
				this.objects.addChild(this.player);
				if(loader.spawnPoint) {
					this.player.moveTo(loader.spawnPoint.x, loader.spawnPoint.y, 0);
				}
				
				// add collision and trigger information
				this._collisions= loader.getCollisionLayer();
			
				
				// Setup our interaction listeners
				this.objects.addEventListener(GameObjectEvent.CLICK, this.onObjectClick);
				this.grid.addEventListener(MouseEvent.CLICK, this.onGridClick);
				
				// Finish up by forcing a complete redraw
				this.invalidateTiles();
			}
		}
		
		/**
		 * Update the world. Some notes on flow: 
		 * The player updates the state of the collisions layer. 
		 * The world updates the state of the triggers layer after the sprite has moved
		 * 
		 * @param dt The time passed since last update
		 */
		public function update(dt:Number):void {
			if(this.isUpdating) {
				if(this.player) {
					this.player.update(dt);
				}
			}
		}
		
		/**
		 * Render the scene 
		 */		
		public function render():void {
			
			if(this._renderTiles) {
				// render everything this frame
				for (var i:int = 0; i < this.view.scenes.length; i++) {
					this.view.scenes[i].render();
					
				}
				
				this._renderTiles = false;
			} else {
				// just objects this frame
				if(this._objects) {
					this._objects.render();
				}
			}
		}
		
		/**
		 * Forces the redraw of our static background / foreground scenes. 
		 * The redraw occurs on the next frame.
		 */		
		public function invalidateTiles():void {
			this._renderTiles = true;
		}
		
		///////////////////////////////////////////////////
		// WORLD INTERACTION
		///////////////////////////////////////////////////
		
		/**
		 * User has clicked on a game object, set as movement target 
		 * @param event GameObjectEvent
		 */		
		private function onObjectClick(event:GameObjectEvent):void {
			this.currentTarget = event.triggerObject;
			var pt:Pt = new Pt(event.triggerObject.x, event.triggerObject.y, 0);
			this.player.walkTo(pt);
		}
		
		/**
		 * The user has clicked on the host container 
		 * @param event The mouse event
		 * 
		 */		
		private function onGridClick(event:ProxyEvent):void {
			this.currentTarget = null;
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
			var stage:Stage = this._hostContainer.stage;
			var pt:Pt = new Pt(x - stage.stageWidth / 2 + this.view.currentX, y - stage.stageHeight / 2 + this.view.currentY);
			return IsoMath.screenToIso(pt); 
		}
	}
}