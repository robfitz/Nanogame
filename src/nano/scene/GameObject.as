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
			this._asset.addEventListener(MouseEvent.CLICK, this.onAssetClick);
			this.sprites = [this._asset];
			this._asset.gotoAndStop(STATE_STATIC);
		}
		
		public function GameObject(descriptor:Object=null)
		{
			super(descriptor);
			this.container.mouseChildren = true;
			this.container.mouseEnabled = false;
		}
		
		private function onAssetClick(event:MouseEvent):void {
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function activate():void {
			this.asset.gotoAndStop(STATE_ONCLICK);
		}
		
		public function reset():void {
			this.asset.gotoAndStop(STATE_RESET);
		}
		
		public function static():void {
			this.asset.gotoAndStop(STATE_STATIC);
		}
	}
}