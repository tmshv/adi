package me.scriptor.platform.core.login {
	import me.scriptor.platform.interfaces.ILoginView;
	import me.scriptor.platform.interfaces.IView;

	import ru.ogilvyrussia.utils.Config;
	import ru.ogilvyrussia.utils.css.CSSLibrary;
	import ru.ogilvyrussia.vkontakte.application.AdditionalInfo;
	import ru.ogilvyrussia.vkontakte.net.RequestLoader;
	import ru.ogilvyrussia.vkontakte.net.RequestResponder;
	import ru.ogilvyrussia.vkontakte.net.methods.OtherMethod;
	import ru.ogilvyrussia.vkontakte.net.methods.UserMethod;
	import ru.ogilvyrussia.vkontakte.shortcuts.OtherShortcut;
	import ru.ogilvyrussia.vkontakte.shortcuts.UserShortcut;
	import ru.ogilvyrussia.vkontakte.utils.UserProfileField;

	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;

	/**
	 * @author Daniel Polsen (daniel.polsen[at]gmail.com)
	 */
	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="connect", type="flash.events.Event")]
	public class LoginController extends EventDispatcher {
		/**
		 * @private контейнер для визуала
		 */
		private var container : DisplayObjectContainer;
		/**
		 * @private модель данных
		 */
		private var _model : LoginModel;
		/**
		 * @private визуал данных
		 */
		private var _view : ILoginView;

		public function LoginController(container : DisplayObjectContainer) {
			this.container = container;
			this._model = new LoginModel();
		}

		public function login() : void {
			var fields : Vector.<String> = new Vector.<String>(1, true);
			var userIDs : Vector.<String> = new Vector.<String>(1, true);
			userIDs[0] = AdditionalInfo.VIEWER_ID;
			fields[0] = UserProfileField.PHOTO_MEDIUM;
			var request : RequestLoader = UserShortcut.getProfiles(userIDs, fields);
			request.responder.addEventListener(Event.COMPLETE, onRequestLoadedHandler);
			request.responder.addEventListener(ErrorEvent.ERROR, onRequestErrorHandler);
			request.load();
		}

		public function register() : void {
			var request : RequestLoader = OtherShortcut.getVariable(1281);
			request.responder.addEventListener(Event.COMPLETE, onRequestLoadedHandler);
			request.responder.addEventListener(ErrorEvent.ERROR, onRequestErrorHandler);
			request.load();
		}

		private function setRegisterInof() : void {
			var request : RequestLoader = OtherShortcut.putVariable(1504, getTimer().toString());
			request.responder.addEventListener(Event.COMPLETE, onRequestLoadedHandler);
			request.responder.addEventListener(ErrorEvent.ERROR, onRequestErrorHandler);
			request.load();
		}

		public function set viewType(viewType : String) : void {
			if(this.view) {
				if(this.view.type == viewType)
					return;
				this.removeView();
			}
			var definition : String = Config.getConfig("references").child("view").(attribute("type").valueOf().toString() == viewType).valueOf().toString();
			if(ApplicationDomain.currentDomain.hasDefinition(definition)) {
				var ViewReference : Class = ApplicationDomain.currentDomain.getDefinition(definition) as Class;
				this._view = new ViewReference(this.model);
				this.addView();
			} else {
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Указанный тип " + viewType + " не найден в ApplicationDomain.currentDomain"));
			}
		}

		public function get model() : LoginModel {
			return this._model;
		}

		public function get view() : IView {
			return this._view;
		}

		private function addView() : void {
			if(this.view) {
				this.view.addEventListener(Event.CHANGE, onViewChangedHandler);
				this.container.addChild(this.view.instance);
				this.view.create();
			}
		}

		private function removeView() : void {
			if(this.view) {
				this.view.removeEventListener(Event.CHANGE, onViewChangedHandler);
				if(this.view.instance.parent) {
					this.view.instance.parent.removeChild(this.view.instance);
				}
				this.view.dispose();
			}
		}

		private function handleReques(request : RequestLoader) : void {
			if(request) {
				switch(request.method) {
					case OtherMethod.GET_VARIABLE:
						if(this.view.type == LoginType.REGISTER) {
							var username : String = XML(request.responder.data).valueOf().toString();
							this.model.data = {username:username, title:"<h1>Назови персонажа</h1>", styleshet:CSSLibrary.getStyle()};
						}
						break;
					case OtherMethod.PUT_VARIABLE:
						dispatchEvent(new Event(Event.CONNECT));
						break;
					case UserMethod.GET_PROFILES:
						var photoURL : String = XML(request.responder.data)..photo_medium.valueOf().toString();
						this.getPhoto(photoURL);
						break;
				}
			}
		}

		private function getPhoto(photoURL : String) : void {
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoLoadedHandler);
			loader.load(new URLRequest(photoURL), new LoaderContext(true));
		}

		private function removeRequest(request : RequestLoader) : void {
			if(request) {
				request.responder.removeEventListener(Event.COMPLETE, onRequestLoadedHandler);
				request.responder.removeEventListener(ErrorEvent.ERROR, onRequestErrorHandler);
				request.close();
				request = null;
			}
		}

		// --		Handlers		--
		private function onRequestLoadedHandler(event : Event) : void {
			var request : RequestLoader = RequestResponder(event.target).request;
			this.handleReques(request);
			this.removeRequest(request);
		}

		private function onRequestErrorHandler(event : ErrorEvent) : void {
			var request : RequestLoader = RequestResponder(event.target).request;
			this.removeRequest(request);
		}

		private function onViewChangedHandler(event : Event) : void {
			this.view.type == LoginType.REGISTER ? setRegisterInof() : Event.CHANGE;
		}
		
		private function onPhotoLoadedHandler(event : Event) : void {
			var loader : Loader = LoaderInfo(event.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPhotoLoadedHandler);
			this.model.data = {photo:Bitmap(loader.content).bitmapData};
			loader.unload();
			loader = null;
		}
	}
}