package level
{
	import flash.net.SecureSocket;
	
	import nano.World;

	/**
	 * Describes a series of objective that a player myst complete to 
	 * finish the level. This is the narrative logic of the game.
	 * @author devin
	 * 
	 */	
	public class Script
	{
		
		public var name:String;
		
		public var introDialog:String;
		
		/**
		 * The world the player moves around in.  
		 */		
		public var world:World
		
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
		
		/**
		 * Starts the current a level anew
		 */		
		public function startLevel():void {
			this.showDialog(this.introDialog);
			this.world.isUpdating = true;
		}
		
		/**
		 * Update the game, check to see if things have progressed 
		 * @param dt Seconds that have passed since the last update
		 * 
		 */		
		public function update(dt:Number):void {
			if(this.world.collisions.justHit) {
				var trigger:String = this.world.collisions.justHit.trigger;
				trace(trigger, this.currentObjective.goalTarget);
				if(trigger == this.currentObjective.goalTarget) {
					this.showDialog(this.currentObjective.successDialog);
				}
			}
		}
		
		/**
		 * Shows a section of dialog text 
		 * @param text The text to display to the player
		 */		
		public function showDialog(text:String):void {
			trace("++++++++++++++++++++ DIALOG ++++++++++++++++++++")
			trace(text);
			trace("++++++++++++++++++++++++++++++++++++++++++++++++\n");
		}
			
	}
}