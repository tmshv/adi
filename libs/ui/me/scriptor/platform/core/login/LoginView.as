package me.scriptor.platform.core.login {
	import me.scriptor.platform.ui.menu.MainMenu;
	import me.scriptor.platform.ui.panels.UserInfo;

	import flash.display.Sprite;

	/**
	 * @author Daniel Polsen (daniel.polsen[at]gmail.com)
	 */
	public class LoginView extends LoginBaseView {
		/**
		 * Панель информации о пользователе
		 */
		public var user : UserInfo;
		/**
		 * Панель с рейтингов лучших пользователей
		 */
		public var rating : Sprite;
		/**
		 * Меню лобби-локации
		 */
		public var menu : MainMenu;

		public function LoginView(model : LoginModel) {
			super(model);
		}

		override public function get type() : String {
			return LoginType.LOGIN;
		}

		override protected function createView() : void {
			super.createView();
			menu.initialize();
		}

		override protected function onModelChange() : void {
			super.onModelChange();
			user.addPhoto(this.model.getDataByKey("photo"));
		}
	}
}
