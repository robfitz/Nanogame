package
{
	import as3isolib.display.IsoSprite;
	
	import flash.display.Sprite;
	
	import nano.level.Script;
	
	import nano.Assets;
	import nano.CollisionLayer;
	import nano.ui.DialogBox;
	
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;
	import net.pixelpracht.tmx.TmxPropertySet;
	
	
	/**
	 * For debugging dialog 
	 * @author devin
	 * 
	 */	
	
	public class DialogDebug extends Sprite
	{
		public function DialogDebug()
		{
			super();
			
			var gameXml:XML;
			
			var script:Script = new Script(gameXml);
			
			var triggers:CollisionLayer = new CollisionLayer();
			triggers.rects.push({
				'name': "test",
				'props': null,
				'x': 0,
				'y': 0,
				'x2': 100,
				'y2': 100,
				'width': 100,
				'height': 100
			});
			
			var sprite:IsoSprite = new IsoSprite(null);
			sprite.width = 10;
			sprite.height = 10;
			sprite.length = 10;
			
			sprite.x = 0;
			sprite.y = 0;
			trace("----------------------------");
			trace("Hitting?           " + triggers.test(sprite));
			trace("Just hitting?      " + (triggers.justHit != null));
			trace("Currently hitting? " + (triggers.currentlyHit != null));
			
			sprite.x = 10;
			sprite.y = 10;
			trace("----------------------------");
			trace("Hitting?           " + triggers.test(sprite));
			trace("Just hitting?      " + (triggers.justHit != null));
			trace("Currently hitting? " + (triggers.currentlyHit != null));
			
			sprite.x = 101;
			sprite.y = 101;
			trace("----------------------------");
			trace("Hitting?           " + triggers.test(sprite));
			trace("Just hitting?      " + (triggers.justHit != null));
			trace("Currently hitting? " + (triggers.currentlyHit != null));
			
			sprite.x = 90;
			sprite.y = 90;
			trace("----------------------------");
			trace("Hitting?           " + triggers.test(sprite));
			trace("Just hitting?      " + (triggers.justHit != null));
			trace("Currently hitting? " + (triggers.currentlyHit != null));
			
			var dialogbox:DialogBox = new DialogBox();
			this.addChild(dialogbox);
		}
	}
}