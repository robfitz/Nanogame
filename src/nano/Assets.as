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
		//          THE SCRIPT, LOL            //
		/////////////////////////////////////////
		[Embed(source="assets/nanogame.xml", mimeType="application/octet-stream")]
		public var game_script:Class;
		
		/////////////////////////////////////////
		//               MENUS                 //
		/////////////////////////////////////////
		[Embed(source="assets/menu.swf", symbol="main_menu")]
		public var main_menu:Class;
		
		/////////////////////////////////////////
		//             CHARACTERS              //
		/////////////////////////////////////////
		[Embed(source="assets/character/avatar_suited.swf", symbol="asset")]
		public var player_suited:Class;
		
		/////////////////////////////////////////
		//            WORLD OBJECTS            //
		/////////////////////////////////////////
		[Embed(source="assets/objects/evaporator.swf", symbol="asset")]
		public var evaporator:Class;
		
		[Embed(source="assets/objects/photolithography.swf", symbol="asset")]
		public var photolithography:Class;
		
		[Embed(source="assets/objects/printer.swf", symbol="asset")]
		public var printer:Class;
		
		[Embed(source="assets/objects/scales.swf", symbol="asset")]
		public var scales:Class;
		
		[Embed(source="assets/objects/spin_coater.swf", symbol="asset")]
		public var spin_coater:Class;
		
		[Embed(source="assets/objects/vacuumcontainer.swf", symbol="asset")]
		public var vacuumcontainer:Class;
		
		/**
		 * Don't call this! 
		 */		
		public function Assets()
		{
			
		}
	}
}