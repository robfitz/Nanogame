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
		[Embed(source="assets/nanogame-solar.xml", mimeType="application/octet-stream")]
		public var game_script:Class;
		
		[Embed(source="assets/office.tmx", mimeType="application/octet-stream")]
		public var office:Class;
		
		[Embed(source="assets/cleanlab.tmx", mimeType="application/octet-stream")]
		public var cleanlab:Class;
		
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
		[Embed(source="assets/objects/closet.swf", mimeType="application/octet-stream")]
		public var closet:Class;
		
		[Embed(source="assets/objects/bench.swf", mimeType="application/octet-stream")]
		public var bench:Class;
		
		[Embed(source="assets/objects/cabinet.swf", mimeType="application/octet-stream")]
		public var cabinet:Class;

		[Embed(source="assets/objects/eyewash.swf", mimeType="application/octet-stream")]
		public var eyewash:Class;
		
		[Embed(source="assets/objects/locker.swf", mimeType="application/octet-stream")]
		public var locker:Class;
		
		[Embed(source="assets/objects/misc_furnace.swf", mimeType="application/octet-stream")]
		public var misc_furnace:Class;
		
		[Embed(source="assets/objects/periodictable.swf", mimeType="application/octet-stream")]
		public var periodictable:Class;
		
		[Embed(source="assets/objects/pictures.swf", mimeType="application/octet-stream")]
		public var pictures:Class;
		
		[Embed(source="assets/objects/shelves.swf", mimeType="application/octet-stream")]
		public var shelves:Class;
		
		//
		// Objectives
		//
		
		[Embed(source="assets/objects/professor_ingame.swf", mimeType="application/octet-stream")]
		public var professor_ingame:Class;
		
		[Embed(source="assets/objects/stretch_scales.swf", mimeType="application/octet-stream")]
		public var stretch_scales:Class;
		
		[Embed(source="assets/objects/stretch_vacuum.swf", mimeType="application/octet-stream")]
		public var stretch_vacuum:Class;
		
		[Embed(source="assets/objects/stretch_spincoater.swf", mimeType="application/octet-stream")]
		public var stretch_spincoater:Class;
		
		[Embed(source="assets/objects/stretch_printer.swf", mimeType="application/octet-stream")]
		public var stretch_printer:Class;
		
		[Embed(source="assets/objects/stretch_evaporater.swf", mimeType="application/octet-stream")]
		public var stretch_evaporater:Class;
		
		[Embed(source="assets/objects/stretch_photolithography.swf", mimeType="application/octet-stream")]
		public var stretch_photolithography:Class;
		
		[Embed(source="assets/objects/solar_sputter.swf", mimeType="application/octet-stream")]
		public var solar_sputter:Class;
		
		[Embed(source="assets/objects/solar_ultrasoniccleaner.swf", mimeType="application/octet-stream")]
		public var solar_ultrasoniccleaner:Class;
		
		[Embed(source="assets/objects/solar_bath.swf", mimeType="application/octet-stream")]
		public var solar_bath:Class;
		
		[Embed(source="assets/objects/solar_atomiclayer.swf", mimeType="application/octet-stream")]
		public var solar_atomiclayer:Class;
		
		[Embed(source="assets/objects/solar_spinhood.swf", mimeType="application/octet-stream")]
		public var solar_spinhood:Class;
		
		/////////////////////////////////////////
		//              CUTSCENES              //
		/////////////////////////////////////////
		[Embed(source="assets/cutscene/professor.swf", mimeType="application/octet-stream")]
		public var professor:Class;
		
		[Embed(source="assets/cutscene/cutscene_weighstation.swf", mimeType="application/octet-stream")]
		public var cutscene_weighstation:Class;
		
		[Embed(source="assets/cutscene/cutscene_vacuum.swf", mimeType="application/octet-stream")]
		public var cutscene_vacuum:Class;
		
		[Embed(source="assets/cutscene/cutscene_spincoater.swf", mimeType="application/octet-stream")]
		public var cutscene_spincoater:Class;
		
		[Embed(source="assets/cutscene/cutscene_maskcutter.swf", mimeType="application/octet-stream")]
		public var cutscene_maskcutter:Class;
		
		[Embed(source="assets/cutscene/cutscene_evaporator.swf", mimeType="application/octet-stream")]
		public var cutscene_evaporator:Class;
		
		[Embed(source="assets/cutscene/cutscene_photolithography.swf", mimeType="application/octet-stream")]
		public var cutscene_photolithography:Class;
		
		[Embed(source="assets/cutscene/cutscene_sputter1.swf", mimeType="application/octet-stream")]
		public var cutscene_sputter1:Class;
		
		[Embed(source="assets/cutscene/cutscene_ultrasoniccleaner.swf", mimeType="application/octet-stream")]
		public var cutscene_ultrasoniccleaner:Class;
		
		[Embed(source="assets/cutscene/cutscene_sputter2.swf", mimeType="application/octet-stream")]
		public var cutscene_sputter2:Class;
		
		[Embed(source="assets/cutscene/cutscene_bath.swf", mimeType="application/octet-stream")]
		public var cutscene_bath:Class;
		
		[Embed(source="assets/cutscene/cutscene_atomiclayer.swf", mimeType="application/octet-stream")]
		public var cutscene_atomiclayer:Class;
		
		[Embed(source="assets/cutscene/cutscene_solarspin.swf", mimeType="application/octet-stream")]
		public var cutscene_solarspin:Class;
		
		/////////////////////////////////////////
		//                TILES                //
		/////////////////////////////////////////
		[Embed(source="assets/walls/walls_003.png")]
		public var image_walls:Class;
		
		[Embed(source="assets/floor/floors_002.png")]
		public var image_floors:Class;
		
		/**
		 * Used this map to lookup the correct named asset
		 */
		public var image_map:Object = {
			"walls/walls_003.png" : image_walls,
			"floor/floors_002.png" : image_floors
		};
		
		/**
		 * Don't call this! 
		 */		
		public function Assets()
		{
			
		}
	}
}