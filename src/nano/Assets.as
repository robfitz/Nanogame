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
		
		[Embed(source="assets/avatar.swf")]
		public var Link:Class;
		
		/**
		 * Don't call this! 
		 */		
		public function Assets()
		{
			
		}
	}
}