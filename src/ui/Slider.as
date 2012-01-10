package ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Slider extends Sprite
	{
		override public function set width(value:Number):void {
			_set_width = value;
			redraw();
		}
		override public function set height(value:Number):void {
			_set_height = value;
			redraw();
		}
		
		private var _set_height:int;
		private var _set_width:int;
		
		private var min:int;
		private var max:int;
		
		public function set val(value:Number):void {
			_val = int(value);
			dispatchEvent(new Event(Event.CHANGE));
			this.redraw_selection();
		}
		public function get val():Number {
			if (this.custom_values) {
				return custom_values[_val];
			} 
			else {
				return _val + min;
			}
		}
		private var _val:int;
		
		private var labels:Array;
		
		private static const TRACK_H:int = 6;
		
		private var highlight:Sprite;
		private var selection:Sprite;
		
		private var label_names:Array;
		private var custom_values:Array;
		
		public function Slider(min:int, max:int, val:int, width:int, height:int, label_names:Array=null, values:Array=null)
		{
			super();
			
			this.label_names = label_names;
			this.custom_values = values;
			
			highlight = new Sprite();
			addChild(highlight);
		
			selection = new Sprite();
			addChild(selection);
		
			this.min = min;
			this.max = max;
			if (this.custom_values) {
				this.val = val - min;
			}
			else {
				this.val = val;
			}
			
			this.width = width;	
			this.height = height;
			
			this.buttonMode = true;
			this.useHandCursor = true;
			
			addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
			addEventListener(MouseEvent.ROLL_OUT, on_mouse_out);
			addEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			
			this.redraw_selection();
		}
		
		private function redraw_highlight():void {
			highlight.graphics.clear();
			
			//which section?
			var delta:Number = this._set_width / (this.max - this.min);
			var section:int = Math.min(Math.max(0, this.mouseX / delta), this.max-min);
			
			highlight.graphics.beginFill(0x999999);
			highlight.graphics.drawRect(delta * section + 1, 0, delta - 2, _set_height);
			highlight.graphics.endFill();
		}
		
		private function on_mouse_move(event:MouseEvent):void {
			redraw_highlight();
		}
		private function on_mouse_out(event:MouseEvent):void {
			highlight.graphics.clear();
		}
		
		private function on_mouse_down(event:MouseEvent):void {
			var delta:Number = this._set_width / (this.max - this.min);
			var section:int = Math.min(Math.max(0, this.mouseX / delta), this.max);
			
			this.val = section;
			
			this.redraw_selection();
			
			event.stopPropagation();
		}
		
		private function redraw_selection():void {
			if (selection) {
				selection.graphics.clear();
				
				var delta:Number = this._set_width / (this.max - this.min);
				
				selection.graphics.beginFill(0xffffff);
				selection.graphics.drawRect(delta * _val, 0, delta - 2, _set_height);
				selection.graphics.endFill();
			}
		}

		private function redraw():void {
			if (labels) {
				for each (var l:DisplayObject in labels) {
					this.removeChild(l);
				}
			}
			labels = new Array();
			
			graphics.clear();
			
			//transparent bg for catching mouse events
			graphics.beginFill(0, 0.001);
			graphics.drawRect(0, 0, _set_width, _set_height);
			
			//track
//			graphics.beginFill(0xCCCCCC, 1);
//			graphics.drawRoundRect(0, _set_height / 2 - TRACK_H / 2, _set_width, TRACK_H, TRACK_H, TRACK_H);
//			graphics.endFill();
			
			//notches
			var label:TextField;
			graphics.lineStyle(1, 0xCCCCCC);
			var delta:Number = this._set_width / (this.max - this.min);
			for (var i:int = 0; i <= this.max - this.min; i ++) {
				graphics.moveTo(i * delta, 0);
				graphics.lineTo(i * delta, _set_height);
				label = new TextField();
				label.height = _set_height - 8;
				label.x = i * delta;
				label.width = delta;
				label.text = (i + this.min).toString();
				if (this.label_names && label_names.length > i) {
					label.text = label_names[i]; 
				}
				label.setTextFormat(new TextFormat("Helvetica", _set_height-8, 0xCCCCCC, true, null, null, null, null, "center"));
				label.mouseEnabled = false;
				label.selectable = false;
				label.y = _set_height / 2 - label.textHeight / 2;
				addChild(label);
				labels.push(label);
			}
		}
		
	}
}