package nano.scene
{
	import as3isolib.display.IsoSprite;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * Object in the game, can represent an objective 
	 * @author devin
	 * 
	 */	
	
	public class GameObject extends IsoSprite
	{
		
		public static const STATE_STATIC:String = "static";
		public static const STATE_HOVER:String = "hover";
		public static const STATE_ONCLICK:String = "onclick";
		public static const STATE_RESET:String = "reset";
		public static const STATE_SIGNAL:String = "signal";
		
		public var objectName:String;
		public var objectType:String;
		public var objectData:Object; 
		
		private var _asset:MovieClip;
		public function get asset():MovieClip {
			return this._asset;
		}
		public function set asset(val:MovieClip):void {
			if(this._asset) {
				this._asset.removeEventListener(MouseEvent.CLICK, this.onAssetClick);
			}
			this._asset = val;
			this._asset.mouseChildren = false;
			var d:Pt = IsoMath.isoToScreen(new Pt(this.width, this.length, 0));
			this._asset.x = d.x;
			this._asset.y = d.y;
			
			if(! this.objectData['static']) {
				this._asset.addEventListener(MouseEvent.CLICK, this.onAssetClick);
				this._asset.addEventListener(MouseEvent.MOUSE_OVER, this.onAssetMouseOver);
				this._asset.addEventListener(MouseEvent.MOUSE_OUT, this.onAssetMouseOut);
			}
			
			this.sprites = [this._asset];
			this._asset.gotoAndStop(STATE_STATIC);
		}
		
		private var _state:String = STATE_STATIC;
		private function get state():String {
			return _state;
		}
		private function set state(val:String):void {
			var oldState:String = this._state;
			_state = val;
			this._asset.gotoAndStop(_state);
		}
		
		/**
		 * Default contructor 
		 * @param descriptor optional iso descriptor
		 * 
		 */			
		public function GameObject(descriptor:Object=null)
		{
			super(descriptor);
			this.container.mouseChildren = true;
			this.container.mouseEnabled = false;
		}
		
		private function onAssetClick(event:MouseEvent):void {
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onAssetMouseOver(event:MouseEvent):void {
			if(this.state == STATE_STATIC) {
				this.state = STATE_HOVER;
			}
		}
		
		private function onAssetMouseOut(event:MouseEvent):void {
			if(this.state == STATE_HOVER) {
				this.state = STATE_STATIC;
			}
		}
		
		public function activate():void {
			this.state = STATE_ONCLICK;
		}
		
		public function reset():void {
			this.state = STATE_RESET;
		}
		
		public function static():void {
			this.state = STATE_STATIC;
		}
		
		public function signal():void {
			this.state = STATE_SIGNAL;
		}
	}
}