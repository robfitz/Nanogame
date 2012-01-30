package nano.level
{
	/**
	 * Describes a single objective that the player can accomplish.  
	 * @author devin
	 * 
	 */	
	public class Objective
	{
		public var intro:Dialog;
		
		public var outro:Dialog;
		
		public var goalTarget:String;
		
		public var goalReward:String;
		
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
			this.goalReward = xml.goal.@reward;
			
			for each(var dialog:XML in xml.children()) {
				if(dialog.name() == "dialog") {
					
					if(dialog.@type == "outro") {
						this.outro = new Dialog(dialog);
					}
					if(dialog.@type == "intro") {
						this.intro = new Dialog(dialog);
					}	
				}
			}
		}
	}
}