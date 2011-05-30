package me.scriptor.platform.ui.window {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author Daniel Polsen (daniel.polsen at gmail.com)
	 * @playerversion Adobe Flashplayer 10 or higher
	 * @langversion Actionscript 3.0
	 */
	public class ModalWindow extends WindowView {
		/**
		 * Кнопка <code>OK</code>
		 */
		public var done : Sprite;

		public function ModalWindow() {
			super();
		}

		override public function get type() : String {
			return WindowType.MODAL;
		}
		
		override protected function activate() : void {
			super.activate();
			if(!this.done.buttonMode) {
				this.done.buttonMode = true;
				this.done.addEventListener(MouseEvent.CLICK, onDoneClickHandler);
			}
		}
		
		override protected function deactivate() : void {
			super.deactivate();
			if(this.done.buttonMode) {
				this.done.buttonMode = false;
				this.done.removeEventListener(MouseEvent.CLICK, onDoneClickHandler);
			}
		}

		override protected function onResize() : void {
			super.onResize();
			this.done.x = super.background.width - this.done.width - 40;
			this.done.y = super.background.height - this.done.height * 2 / 3;
		}
		
		protected function onDone() : void {
		}
		
		//		--		Handlers		--
		/**
		 * @eventType flash.events.MouseEvent.CLICK
		 * @private нажатие кнопки <code>OK</code>
		 */
		private function onDoneClickHandler(event : MouseEvent) : void {
			onDone();
		}
	}
}
