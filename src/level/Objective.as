package level
{
	/**
	 * Describes a single objective that the player can accomplish.  
	 * @author devin
	 * 
	 */	
	public class Objective
	{
		public var introDialog:String;
		
		public var successDialog:String;
		
		public var failDialog:String;
		
		public var goalTarget:String;
		
		/**
		 * Default contructor 
		 * @param objectiveXml optional description xml
		 */		
		public function Objective(objectiveXml:XML = null)
		{
			if(objectiveXml) {
				this.initFromXml(objectiveXml);
			}
		}
		
		public function initFromXml(xml:XML):void {
			this.goalTarget = xml.goal.@target;
			this.introDialog = xml.intro;
			this.successDialog = xml.success;
			this.failDialog = xml.fail;
		}
	}
}