package nano.scene
{
	import as3isolib.display.scene.IsoScene;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxPropertySet;
	
	
	[Event(name="game_click", type="nano.scene.GameObjectEvent")]
	
	public class ObjectScene extends IsoScene
	{
		private var assetToIsoMap:Object = {};
		
		public function ObjectScene()
		{
			super();
		}
		
		/**
		 * Adds an object to this scene described by a TmxObject. Creating a iso sprite, places it, and create a lookup
		 * for the props
		 * @param tmxObj Tmx description of the object 
		 * @param asset DisplayObject to build the sprite with
		 * 
		 */		
		public function addTmxObject(tmxObj:TmxObject, asset:DisplayObjectContainer):void {
			var sprite:GameObject = new GameObject();
			sprite.setSize(tmxObj.width, tmxObj.height, 100);
			sprite.objectName = tmxObj.name;
			sprite.objectType = tmxObj.type;
			sprite.objectData = tmxObj.custom;
			sprite.asset = asset as MovieClip;
			sprite.x = tmxObj.x;
			sprite.y = tmxObj.y;
			sprite.addEventListener(MouseEvent.CLICK, this.onObjectClick);
			
			this.addChild(sprite);
		}
		
		public function onObjectClick(event:ProxyEvent):void {
			var ev:GameObjectEvent = new GameObjectEvent(GameObjectEvent.CLICK);
			ev.triggerObject = event.target as GameObject;
			this.dispatchEvent(ev);
		}
	}
}