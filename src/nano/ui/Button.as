package nano.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
			this.textfield.setTextFormat(new TextFormat("Lucida Grande", 18, 0x000000));
			this.render();
		}
		
		public function get buttonWidth():Number {
			return this.textfield.textWidth + 20;
		}
		
		public function get buttonHeight():Number {
			return this.textfield.textHeight + 23;
		}
		
		public function Button(label:String)
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.textfield = new TextField();
			this.textfield.selectable = false;
			this.addChild(this.textfield);
			this.label = label;
		}
		
		public function render():void {
			this.textfield.x = 10;
			this.textfield.y = 10;
			
			var g:Graphics = this.graphics;
			var w:int = this.textfield.textWidth;
			var h:int = this.textfield.textHeight;
			
			g.lineStyle(2, 0x60d1d1, 1);
			g.beginFill(0xb8d1d1, 1);
			g.drawRoundRect(0, 0, w + 20, h + 23, 8);
		}
	}
}