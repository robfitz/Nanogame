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
		
		/**
		 * Pointer to the current objective 
		 */		
		private var _currentObjective:int = 0;
		public function get currentObjective():Objective {
			return this.objectives[this._currentObjective] as Objective;
		}
		
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
				trace(obj.name());
				if(obj.name() == 'objective') {
					this.objectives.push(new Objective(obj));
				}
			}
		}
	}
}