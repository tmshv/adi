package adiwars{
	import adiwars.core.Config;
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseController;
	import adiwars.dialogs.Dialog;
	import adiwars.states.ApplicationStateKey;
	import adiwars.states.BattleState;
	import adiwars.states.MenuState;
	import adiwars.states.RegistrationState;
	import adiwars.states.Screen;
	import adiwars.states.ScreenSlider;
	import adiwars.states.TuneState;
	import adiwars.states.events.StateEvent;
	import adiwars.user.Owner;
	import adiwars.user.OwnerModel;
	import adiwars.user.UserModel;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import remote.GameAPI;
	import remote.GameAPIBuilder;
	import remote.RemoteErrorHelper;
	import remote.RemoteErrorType;
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	import remote.VirtualSocialAPIBuilder;
	
	import ru.gotoandstop.resources.ResourceLibrary;
	
	/**
	 * Контроллер приложения
	 * Приложение и ее компоненты работают в контексте
	 * В случае, если контект не определен, программа создает для себя простейший контекст, при котором может функционировать
	 * Программа может дополнять и расширять контекст
	 * 
	 * Контекст хранит информацию о социальной сети, в которой запущена
	 * @author Timashev Roman
	 */
	public class MainGameController extends BaseController{
		private var config:Config;
		private var owner:Owner;
		
		public function MainGameController(container:DisplayObjectContainer, context:Context, config:Config){
			trace('start')
			
			super(container, context);
			this.config = config;
			this.init();
		}
		
		/**
		 * На будущее, когда приложение будет грузить социальный модуль,
		 * а не социальный контейнер грузит приложение:
		 * при инициализации нужно проинициализировать отправщика запросов
		 * 
		 * В случае, если приложение запускается напрямую, а не загружается внутрь социального контейнера,
		 * необходимо заного проинициализировать <code>RemoteRequest</code>, с виртуальным социалом
		 * 
		 * В процессе инициализации должна быть установлена
		 * социальная информация о пользователе и
		 * о его участии в игре (этап авторизации в игре).
		 * Если игрок новый, должен включиться этап регистрации,
		 * при котором отображается экран выбора персонажа и его имени
		 */
		private function init():void{
			if(!RemoteRequest.isInited()){
				this.initVirtualRemoteRequest();
			}
			
			this.initOwner();
			super.context.opponent.addEventListener(Event.CHANGE, this.handleOpponentChange);
			var config:RemoteRequest = this.createConfig();
			config.getConfig();
		}
		
		/**
		 * Инициализирует подсистему, которая отвечает за информацию о пользователе.
		 */
		private function initOwner():void{
			this.owner = new Owner(this.config.userID, super.context);
			this.owner.model.setName(this.config.userProfile.@firstName, this.config.userProfile.@lastName);
			this.owner.model.friends = this.config.friends;
			this.context.owner = this.owner;
		}
		
		private function init2():void{
			this.owner.update();
			
			var ava_value:uint = super.context.configXML.value.(@name=='availablePoints')[0];
			
			this.owner.paramsPoints.value = ava_value;
			this.init3();
			
			var user_info_request:RemoteRequest = this.createUserInfo();
			user_info_request.getUserInfo();
			
//			this.showBattleState();
//			this.showRegisterState();
//			this.showMenuState();
		}
		
		private function init3():void{
			this.initStates();
		}
		
		private function initStates():void{
			const state_manager:ScreenSlider = super.context.applicationStates;
			
			state_manager.register(new MenuState(super.context));
			state_manager.register(new TuneState(super.context));
			state_manager.register(new BattleState(super.context));
			state_manager.register(new RegistrationState(super.context));
		}
		
		/*
		* USER INFO
		*/
		
		private function createUserInfo():RemoteRequest{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleUserInfo);
			request.addEventListener(RemoteEvent.ERROR, this.handleUserInfoError);
			
			return request;
		}
		
		private function destroyUserInfo(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleUserInfo);
			request.removeEventListener(RemoteEvent.ERROR, this.handleUserInfoError);
		}
		
		/**
		 * Обработка успешного получения информации об игроке с игрового сервера
		 * После получения этой информации следующее действие - показать игровое меню 
		 * @param event
		 */
		private function handleUserInfo(event:RemoteEvent):void{
			this.owner.parseRemoteRequest(event.response);
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyUserInfo(request);
			
			this.showMenuState();
			//this.showRegisterState();
		}
		
		/**
		 * Обработка ошибки при получении информации об игроке.
		 * Если это логическая ошибка - показать окно регистрации.
		 * В противном случае показать окно смерти )))
		 * @param event
		 */
		private function handleUserInfoError(event:RemoteEvent):void{
			trace(new Date(), event);
			trace(event.response.toXMLString())
			
			var error:RemoteErrorHelper = new RemoteErrorHelper(event.response);
			switch(error.errorType){
				case RemoteErrorType.FATAL:
					this.showErrorState();
					break;
				
				case RemoteErrorType.LOGIC:
					this.showRegisterState();
					break;
				
				default: break;
			}
			
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyUserInfo(request);
		}
		
		/*
		* CONFIG
		*/
		
		private function createConfig():RemoteRequest{
			var request:RemoteRequest = new RemoteRequest();
			request.addEventListener(RemoteEvent.COMPLETE, this.handleConfig);
			request.addEventListener(RemoteEvent.ERROR, this.handleConfigError);
			
			return request;
		}
		
		private function destroyConfig(request:RemoteRequest):void{
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleConfig);
			request.removeEventListener(RemoteEvent.ERROR, this.handleConfigError);
		}
		
		/**
		 * @param event
		 */
		private function handleConfig(event:RemoteEvent):void{
			trace('config loaded')
			trace(event.response.toXMLString())
			
			super.context.setConfiguration(event.response);
			
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyUserInfo(request);
			
			this.init2();
		}
		
		/**
		 * @param event
		 */
		private function handleConfigError(event:RemoteEvent):void{
			trace('config not loaded', event.response.toXMLString())
			const request:RemoteRequest = event.target as RemoteRequest;
			this.destroyUserInfo(request);
		}
		
		private function showErrorState():void{
			trace('fatal error occured, lol')
		}
		
		private function showRegisterState():void{
			this.activateState(ApplicationStateKey.REG);
		}
		
		private function showMenuState():void{
			this.activateState(ApplicationStateKey.MENU);
//			this.showRegisterState();
		}
		
		private function showBattleState():void{
			this.activateState(ApplicationStateKey.BATTLE);
		}
		
		private function activateState(key:String, ...params):void{
			var state:Screen = super.context.applicationStates.getState(key);
			if(params.length) state.send(params);
			state.activate();
		}
		
		private function initVirtualRemoteRequest():void{
			trace('init virtual social api')
			RemoteRequest.init(new VirtualSocialAPIBuilder(), new GameAPIBuilder(null));
		}
		
		private function handleOpponentChange(event:Event):void{
			const user:UserModel = event.target as UserModel;
			trace('opponent:')
			trace(user.getName())
			trace(user.userID);
			trace(user.charType);
		}
	}
}