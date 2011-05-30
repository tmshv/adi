package me.scriptor.platform.core.login {
	import me.scriptor.platform.interfaces.ILoginView;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Daniel Polsen (daniel.polsen[at]gmail.com)
	 */
	[Event(name="change", type="flash.events.Event")]
	public class LoginBaseView extends Sprite implements ILoginView {
		/**
		 * @private модель данных
		 */
		protected var model : LoginModel;
		/**
		 * @private если <code>true</code>, значит вид создан
		 */
		private var isCreated : Boolean;

		public function LoginBaseView(model : LoginModel) {
			this.model = model;
		}

		public function create() : void {
			if(!this.isCreated) {
				this.createView();
				this.model.addEventListener(Event.CHANGE, onModelChangeHandler);
				this.isCreated = true;
			}
		}

		public function dispose() : void {
			if(this.isCreated) {
				this.disposeView();
				this.model.removeEventListener(Event.CHANGE, onModelChangeHandler);
				this.model = null;
				this.isCreated = false;
			}
		}

		public function get type() : String {
			return "";
		}

		public function get instance() : DisplayObject {
			return this;
		}

		protected function createView() : void {
		}
		
		protected function disposeView() : void {
		}

		protected function onModelChange() : void {
		}

		// --		Handlers		--
		private function onModelChangeHandler(event : Event) : void {
			onModelChange();
		}
	}
}
