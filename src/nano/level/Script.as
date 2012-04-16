package nano.level
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.SecureSocket;
	import flash.utils.Timer;
	
	import nano.World;
	import nano.scene.GameObject;
	import nano.ui.DialogBox;

	/**
	 * Describes a series of objective that a player myst complete to 
	 * finish the level. This is the narrative logic of the game.
	 * @author devin
	 * 
	 */	
	public class Script extends EventDispatcher
	{
		
		public var name:String;
		
		public var startMap:String;
		
		private var lastWorldTarget:GameObject;
		
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
		
		/** Countdown to the current completed objective being completed. Does that make sense? */
		private var countdown:Timer;
		
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
			this.startMap = xml.@startin;
			for each(var obj:XML in xml.children()) {
				if(obj.name() == 'objective') {
					this.objectives.push(new Objective(obj));
				}
			}
		}
		
		/**
		 * Starts the current a level anew
		 */		
		public function startLevel():void {
			this.world.goto(this.startMap);
			this.world.isUpdating = true;
			
			if(this.currentObjective.intro) {
				this.showDialog(this.currentObjective.intro);
			}
		}
		
		/**
		 * Update the game, check to see if things have progressed 
		 * @param dt Seconds that have passed since the last update
		 * 
		 */		
		public function update(dt:Number):void {
			if(this.world.collisions.justHit) {
				var trigger:String = this.world.collisions.justHit.trigger;
				if(trigger == this.currentObjective.goalTarget
					&& this.world.currentTarget
					&& trigger == this.world.currentTarget.objectName) {
					
					this.lastWorldTarget = this.world.currentTarget;
					this.lastWorldTarget.activate();
					
					if(this.currentObjective.goalHoldTime) {
						this.countdown = new Timer(this.currentObjective.goalHoldTime, 1);
						this.countdown.start();
						this.countdown.addEventListener(TimerEvent.TIMER_COMPLETE, this.completeObjective);
					} else {
						this.completeObjective();
					}
				}
			}
			
			if(this.dialogUi) {
				this.dialogUi.update(dt);
			}
		}
		
		/**
		 * Called when the script has determined the current goal has been completed 
		 */		
		protected function completeObjective(event:TimerEvent = null):void {
			if(this.countdown) {
				this.countdown.removeEventListener(TimerEvent.TIMER_COMPLETE, this.completeObjective);
			}
			
			this.countdown = null;
			
			// need to move? 
			if(this.currentObjective.goalMoveTo) {
				this.world.goto(this.currentObjective.goalMoveTo);
				this.dialogUi.doWipe();
			}
			
			// Need an outro ?
			if(this.currentObjective.outro) {
				this.showDialog(this.currentObjective.outro);
			}
			
			// Advance the objective
			this._currentObjective ++;
		}
		
		/**
		 * This level has been compelted! 
		 * 
		 */		
		protected function scriptFinished():void {
			trace("TODO: Show victory screen here");
			this.dispatchEvent(new Event(Event.COMPLETE));
			}
		
		/**
		 * Shows a section of dialog text 
		 * @param text The text to display to the player
		 */		
		public function showDialog(dialog:Dialog):void {
			// pause our world
			this.world.pause();
			this.dialogUi.display(dialog);
		}
		
		private function onDialogComplete(event:Event):void {
			if(this.world.currentTarget) {
				this.world.currentTarget.static();
				this.world.currentTarget = null;
			}
			
			if(this.lastWorldTarget) {
				this.lastWorldTarget.reset();
			}
			
			if(this._currentObjective >= this.objectives.length) {
				// totally complete
				this.scriptFinished();
			} else {
				this.world.start();
			}
			
			this.world.objects.getChildByTrigger(this.currentObjective.goalTarget).signal();
		}
	}
}