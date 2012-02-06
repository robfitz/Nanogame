package nano.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * Simple buttons for nanogame 
	 * @author devin
	 * 
	 */	
	
	public class Button extends Sprite
	{
		private var textfield:TextField;
		
		public var _label:String;
		public function get label():String {
			return _label;
		}
		public function set label(val:String):void {
			_label = val;
			this.textfield.text = _label;
			this.render();
		}
		
		public function get buttonWidth():Number {
			return this.textfield.textWidth + 20;
		}
		
		public function get buttonHeight():Number {
			return this.textfield.textHeight + 20;
		}
		
		public function Button(label:String)
		{
			super();
			this.textfield = new TextField();
			this.addChild(this.textfield);
			this.label = label;
		}
		
		public function render():void {
			this.textfield.x = 10;
			this.textfield.y = 10;
			
			var g:Graphics = this.graphics;
			var w:int = this.textfield.textWidth;
			var h:int = this.textfield.textHeight;
			
			g.beginFill(0xff0000, 1);
			g.drawRect(0, 0, w + 20, h + 20);
		}
	}
}