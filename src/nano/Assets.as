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
		
		[Embed(source="assets/cleanroom.tmx", mimeType="application/octet-stream")]
		public var level_cleanroom:Class;
		
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
		[Embed(source="assets/objects/stretch_scales.swf", mimeType="application/octet-stream")]
		public var stretch_scales:Class;
		
		[Embed(source="assets/objects/stretch_vacuum.swf", symbol="asset")]
		public var stretch_vacuum:Class;
		
		[Embed(source="assets/objects/stretch_spincoater.swf", symbol="asset")]
		public var stretch_spincoater:Class;
		
		[Embed(source="assets/objects/stretch_printer.swf", symbol="asset")]
		public var stretch_printer:Class;
		
		[Embed(source="assets/objects/stretch_photolithography.swf", symbol="asset")]
		public var stretch_photolithography:Class;
		
		/////////////////////////////////////////
		//                TILES                //
		/////////////////////////////////////////
		[Embed(source="assets/walls/walls_correct-measurements_002.png")]
		public var image_walls:Class;
		
		[Embed(source="assets/floor/floortiles_002.png")]
		public var image_floors:Class;
		
		/**
		 * Used this map to lookup the correct named asset
		 */
		public var image_map:Object = {
			"walls/walls_correct-measurements_002.png" : image_walls,
			"floor/floortiles_002.png" : image_floors
		};
		
		/**
		 * Don't call this! 
		 */		
		public function Assets()
		{
			
		}
	}
}