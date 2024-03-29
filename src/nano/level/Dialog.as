package nano.level
{
	
	/**
	 * Describes a dialog sequence 
	 * @author devin
	 * 
	 */	
	public class Dialog
	{
		/**
		 * Array of lines, which are objects that must always contain a <code>text</code> attr 
		 * and optionally a <code>cutscene</code> attr which holds the key of a cutscene
		 * to play alongside the text
		 */
		public var lines:Array = [];
		
		/**
		 * Default contrcutor 
		 * @param dialogXml Optional. XML description of this dialog
		 */		
		public function Dialog(dialogXml:XML = null)
		{
			if(dialogXml) {
				for each(var line:XML in dialogXml.children()) {
					this.addLine(line, line.@cutscene, line.@cue, line.@type);
				}
			}
		}
		
		/**
		 * Adds a line onto this dialog 
		 * @param text Text for this dialog
		 * @param cutscene Optional. Cutscene key
		 * @param cue Optional. Name of cue point (frame name) of the cutscene to play
		 */		
		public function addLine(text:String, cutscene:String, cue:String, type:String=null):void {
			this.lines.push({text: text, cutscene: cutscene, cue: cue, type: type});
		}
	}
}