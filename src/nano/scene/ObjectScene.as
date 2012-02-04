package nano.scene
{
	import as3isolib.display.scene.IsoScene;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import nano.AssetLoader;
	
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
		 * @param assetClass The class of the asset to init
		 * 
		 */		
		public function addTmxObject(tmxObj:TmxObject, assetClass:Class):void {
			var sprite:GameObject = new GameObject();
			sprite.setSize(tmxObj.width, tmxObj.height, 100);
			sprite.objectName = tmxObj.name;
			sprite.objectType = tmxObj.type;
			sprite.objectData = tmxObj.custom;
			sprite.x = tmxObj.x;
			sprite.y = tmxObj.y;
			sprite.addEventListener(MouseEvent.CLICK, this.onObjectClick);
			
			// async load in the asset for this guys, with weak referencing
			var loader:AssetLoader = new AssetLoader(assetClass);
			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				sprite.asset = (event.target as AssetLoader).asset;
			}, false, 0, true);
			
			this.addChild(sprite);
		}
		
		public function onObjectClick(event:ProxyEvent):void {
			var ev:GameObjectEvent = new GameObjectEvent(GameObjectEvent.CLICK);
			ev.triggerObject = event.target as GameObject;
			this.dispatchEvent(ev);
		}
	}
}