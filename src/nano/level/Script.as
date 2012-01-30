package nano.level
{
	import flash.events.Event;
	import flash.net.SecureSocket;
	
	import nano.World;
	import nano.ui.DialogBox;

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
		
		private var _dialogUi:DialogBox;
		public function get dialogUi():DialogBox
		{
			return _dialogUi;
		}
		
		public function set dialogUi(value:DialogBox):void
		{
			if(_dialogUi) {
				_dialogUi.removeEventListener(Event.COMPLETE, this.onDialogComplete);
			}
			_dialogUi = value;
			if(_dialogUi) {
				_dialogUi.addEventListener(Event.COMPLETE, this.onDialogComplete);
			}
		}
		
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
				if(trigger == this.currentObjective.goalTarget) {
					this.completeObjective();
				}
			}
		}
		
		/**
		 * Called when the script has determined the current goal has been completed 
		 */		
		protected function completeObjective():void {
			// Need an outro ?
			if(this.currentObjective.outro) {
				this.showDialog(this.currentObjective.outro);
			}
			
			// Advance the objective
			this._currentObjective ++;
			if(this._currentObjective >= this.objectives.length) {
				// totally complete
				this.scriptFinished();
			}
		}
		
		/**
		 * This level has been compelted! 
		 * 
		 */		
		protected function scriptFinished():void {
			trace("LEVEL COMPELTE! WELL DONE!");
		}
		
		/**
		 * Shows a section of dialog text 
		 * @param text The text to display to the player
		 */		
		public function showDialog(dialog:Dialog):void {
			// pause our world
			this.world.isUpdating = false;
			this.dialogUi.display(dialog);
		}
		
		private function onDialogComplete(event:Event):void {
			this.world.isUpdating = true;
		}
	}
}