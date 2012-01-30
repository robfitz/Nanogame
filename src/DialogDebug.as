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
			
			var gameXml:XML = new XML(new Assets.instance.game_script);
			
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
			
			
			dialogbox.text = "Welcome to Earth!\n\n\n\
You were flying in the area to learn how the local people live and work - but your rocket booster exploded and you’ve crashed! Now you are stuck here and need to survive. \
You need to take care of yourself and fix your spaceship so you can return home! \
Be sure to eat and come back to the spaceship when you are done for the day to record what you’ve learned and take a long nap.";
			dialogbox.render();
			dialogbox.y = 100;
			dialogbox.x = 50;
		}
	}
}