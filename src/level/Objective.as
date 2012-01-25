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
		
		public var completeDialog:String;
		
		public var failDialog:String;
		
		/**
		 * Default contructor 
		 * @param objectiveXml optional description xml
		 */		
		public function Objective(objectiveXml:XML = null)
		{
			
		}
	}
}