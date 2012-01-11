package nano
{
	import as3isolib.display.scene.IsoScene;
	
	import flash.display.DisplayObjectContainer;

	/**
	 * The world in which the game take place. Consists of tile layers (foreground, background)
	 * and collision and player layers.   
	 * @author devin
	 */	
	public class World
	{
		private var _hostContainer:DisplayObjectContainer;
		private var _renderTiles:Boolean = false;
		
		private var _background:IsoScene;
		public function get background():IsoScene {
			return this._background;
		}
		public function set background(val:IsoScene):void {
			this._background = val;
			this._background.hostContainer = this._hostContainer;
			this.invalidateTiles();
		}
		
		private var _objects:IsoScene;
		public function get objects():IsoScene {
			return this._objects;
		}
		public function set objects(val:IsoScene):void {
			this._objects = val;
			this._objects.hostContainer = this._hostContainer;
			this.invalidateTiles();
		}
		
		private var _foreground:IsoScene;
		public function get foreground():IsoScene {
			return this._foreground;
		}
		public function set foreground(val:IsoScene):void {
			this._foreground = val;
			this._foreground.hostContainer = this._hostContainer;
			this.invalidateTiles();
		}
		
		/**
		 * World contructor 
		 * @param hostContainer The container that our iso scenes ultimately render on
		 */		
		public function World(hostContainer:DisplayObjectContainer)
		{
			this._hostContainer = hostContainer;
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