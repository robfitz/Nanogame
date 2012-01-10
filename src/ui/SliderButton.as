package ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class SliderButton extends Sprite
	{
		private var label:TextField;
		private var contents:Sprite;
		
		private static const HEIGHT:int = 36;
		private static const WIDTH:int = 86;
		private static const PADDING:int = 4;
		
		private var is_sliding:Boolean = false;
		private var is_hidden:Boolean = true;
		private var slide_goal:Number = 0;
		
		public function SliderButton(label_text:String, contents:Sprite)
		{
			super();
			
			this.contents = contents;
			this.addChild(contents);
			
			this.label = new TextField();
			this.label.defaultTextFormat = new TextFormat("Helvetica", 12, 0xffffff, true, null, null, null, null, "left");
			this.label.multiline = true;
			this.label.wordWrap = true;
			this.label.text = label_text;
			this.label.width = WIDTH - PADDING * 2;
			this.addChild(label);
			label.height = label.textHeight + 10;
			
			contents.x = - contents.getBounds(this).width;
			contents.y = 3;
			
			label.x = PADDING;
			label.y = HEIGHT / 2 - label.textHeight / 2; 
			
			graphics.beginFill(0, 0.5);
			graphics.drawRoundRectComplex(-contents.width, 0, WIDTH + contents.width, HEIGHT, 0, 10, 0, 10);
			graphics.endFill();
			
			addEventListener(MouseEvent.ROLL_OVER, on_roll_over);
			addEventListener(MouseEvent.ROLL_OUT, on_roll_out);
		}
		
		private function on_roll_over(event:MouseEvent):void {
		
			if (event.buttonDown) return;
		
			stage.removeEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
			stage.removeEventListener(Event.MOUSE_LEAVE, on_mouse_up);
			
			if (timeout) {
				clearTimeout(timeout);
				timeout = 0;
			}
			
			if (this.slide_goal == 0) {
				this.is_sliding = true;
				this.is_hidden = false;
				
				this.slide_goal = this.contents.width;
				
				addEventListener(Event.ENTER_FRAME, on_enter_frame_slide);
			}	
		}
		
		private var timeout:uint = 0;
		 
		private function on_roll_out(event:MouseEvent):void {
			
			if (event.buttonDown) {
				stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
				stage.addEventListener(Event.MOUSE_LEAVE, on_mouse_up);
			}
			else if (timeout == 0) {
				timeout = setTimeout(hide, 1000);
			}
		}
		
		private function on_mouse_up(event:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
			stage.removeEventListener(Event.MOUSE_LEAVE, on_mouse_up);
			if (timeout == 0) {
				timeout = setTimeout(hide, 1000);
			}
		}
		
		private function hide():void {
			if (this.slide_goal != 0) {
				this.is_sliding = true;
				this.slide_goal = 0;
				
				addEventListener(Event.ENTER_FRAME, on_enter_frame_slide);
			}
		}
		private function on_enter_frame_slide(event:Event):void {
			
			var delta:Number = (this.slide_goal - this.x) / 6.0;
			
			if (Math.abs(this.x - this.slide_goal) < delta * 1.5) {
				this.x = slide_goal;
				this.is_sliding = false;
				if (this.slide_goal == 0) {
					this.is_hidden = true;
				}
				else {
					this.is_hidden = false;
				}
			}
			else {
				this.x += delta;
			}
			
			if (!is_sliding) {
				removeEventListener(Event.ENTER_FRAME, on_enter_frame_slide);
			}
		}
	}
}