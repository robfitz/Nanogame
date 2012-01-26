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
		
		public var name:String;
		
		public var introDialog:String;
		
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
			if(scriptXml) {
				this.initFromXml(scriptXml);
			}
		}
		
		/**
		 * Populates this script from an xml description 
		 * @param xml The script to parse
		 */		
		public function initFromXml(xml:XML):void {
			this.name = xml.@name;
			this.introDialog = xml.intro;
			for each(var obj:XML in xml.children()) {
				this.objectives.push(new Objective(obj));
			}
		}
	}
}