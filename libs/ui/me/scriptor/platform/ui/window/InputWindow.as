package me.scriptor.platform.ui.window {
	import me.scriptor.platform.ui.controls.InputField;

	/**
	 * 
	 * @author Daniel Polsen (daniel.polsen at gmail.com)
	 * @playerversion Adobe Flashplayer 10 or higher
	 * @langversion Actionscript 3.0
	 */
	public class InputWindow extends ModalWindow {
		/**
		 * Поле для ввода текста
		 */
		public var input : InputField;

		public function InputWindow() {
			super();
		}

		override public function get type() : String {
			return WindowType.INPUT;
		}

		override protected function onDone() : void {
			super.onDone();
			resultObject = {field:input.field.text};
			super.onResult();
		}
	}
}
