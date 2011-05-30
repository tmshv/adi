package me.scriptor.platform.core.login {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Daniel Polsen (daniel.polsen[at]gmail.com)
	 */
	[Event(name="change", type="flash.events.Event")]
	public class LoginModel extends EventDispatcher {
		private var storage : Object;

		public function LoginModel() {
		}

		public function getDataByKey(key : String) : * {
			return this.storage[key];
		}

		public function set data(data : Object) : void {
			this.storage = data;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
