package nano.scene
{
	import as3isolib.display.IsoSprite;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * Object in the game, can represent an objective 
	 * @author devin
	 * 
	 */	
	
	public class GameObject extends IsoSprite
	{
		public var objectName:String;
		public var objectType:String;
		public var objectData:Object; 
		
		private var _asset:DisplayObjectContainer;
		public function get asset():DisplayObjectContainer {
			return this._asset;
		}
		public function set asset(val:DisplayObjectContainer):void {
			if(this._asset) {
				(this.sprites[0] as DisplayObjectContainer).removeEventListener(MouseEvent.CLICK, this.onAssetClick);
			}
			this._asset = val;
			this._asset.mouseChildren = false;
			this._asset.x = 0;
			this._asset.y = 32;
			this._asset.addEventListener(MouseEvent.CLICK, this.onAssetClick);
			this.sprites = [this._asset];
			
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
	}
}