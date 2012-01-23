package nano
{
	/**
	 * Singleton to help organize assets.
	 * This is sucky, need to make it a little more flexable 
	 * @author devin
	 * 
	 */	
	public class Assets
	{
		
		public static var _instance:Assets;
		public static function get instance():Assets {
			if(! _instance) {
				_instance = new Assets();
			}
			return _instance;
		}
		
		/////////////////////////////////////////
		//             CHARACTERS              //
		/////////////////////////////////////////
		[Embed(source="assets/character/avatar_suited.swf")]
		public var player_suited:Class;
		
		/////////////////////////////////////////
		//            WORLD OBJECTS            //
		/////////////////////////////////////////
		[Embed(source="assets/objects/scales_weigh_boat.swf", symbol="asset")]
		public var scales_weigh_boat:Class;
		
		[Embed(source="assets/objects/sputter_coater.swf", symbol="asset")]
		public var sputter_coater:Class;
		
		/**
		 * Don't call this! 
		 */		
		public function Assets()
		{
			
		}
	}
}