package nano.scene
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.scene.IsoScene;
	
	import flash.display.DisplayObject;
	
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxPropertySet;
	
	public class ObjectScene extends IsoScene
	{
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
		public function addTmxObject(tmxObj:TmxObject, asset:DisplayObject):void {
			var sprite:IsoSprite = new IsoSprite();
			sprite.data = tmxObj.custom;
			sprite.sprites = [asset];
			sprite.x = tmxObj.x;
			sprite.y = tmxObj.y;
			trace(asset.width, asset.height);
			sprite.setSize(32, 32, 0);
			
			asset.x = 0;
			asset.y = 32;
			
			this.addChild(sprite);
		}
	}
}