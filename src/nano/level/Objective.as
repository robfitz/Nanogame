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
		
		/** The objective that triggers this goals completion */
		public var goalTarget:String;
		
		/** What the player gets if he's successful */
		public var goalReward:String;
		
		/** If set, the player is moved to this map on goal completion */
		public var goalMoveTo:String;
		
		/** Time to hold the game in pause while the goal plays out */
		public var goalHoldTime:int;
		
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
			this.goalMoveTo = xml.goal.@moveto;
			if(xml.goal.@wait) {
				this.goalHoldTime = int(xml.goal.@wait);
			}
			
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