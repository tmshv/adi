package me.scriptor.platform.ui.controls {
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 
	 * @author Daniel Polsen (daniel.polsen at gmail.com)
	 * @playerversion Adobe Flashplayer 10 or higher
	 * @langversion Actionscript 3.0
	 */
	public class InputField extends Sprite {
		/**
		 * Поле для ввода текста
		 */
		public var field : TextField;
		/**
		 * Задний фон для текстового поля
		 */
		public var background : Sprite;

		public function InputField() {
		}

		override public function set width(value : Number) : void {
			this.background.width = value;
			this.field.width = value - 20;
		}
	}
}
