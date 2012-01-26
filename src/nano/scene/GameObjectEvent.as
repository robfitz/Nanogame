package nano.scene
{
	import flash.events.Event;
	
	public class GameObjectEvent extends Event
	{
		public static const CLICK:String = "game_click";
		
		/** The object that caused the event to be created */
		public var triggerObject:GameObject;
		
		public function GameObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}