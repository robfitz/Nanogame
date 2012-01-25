package level
{
	/**
	 * Describes a series of objective that a player myst complete to 
	 * finish the level.  
	 * @author devin
	 * 
	 */	
	public class Script
	{
		
		/** Ordered array of objectives. Each must be competed in order to 
		 *  finish the script */
		public var objectives:Array = [];
		
		public var currentObjective:int = 0;
		
		/**
		 * Default contructor. 
		 * @param scriptXml Optional script xml
		 */		
		public function Script(scriptXml:XML = null)
		{
			
		}
	}
}