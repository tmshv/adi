package adiwars.states{
	import adiwars.states.events.StateEvent;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	[Event(name="registred", type="adiwars.states.events.StateEvent")]
	
	/**
	 * Контейнер состояний
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ScreenSlider extends EventDispatcher{
		/**
		 * Флаг состояния работы сдайдера
		 */
		private var worked:Boolean;
		
		/**
		 * Величина слайда при смене стейта 
		 */
		private var width:uint;
		
		/**
		 * Библиотека зарегистрированных стейтов текущей машины 
		 */
		private var _states:Object;
		
		/**
		 * Контейрей лейаутов стейтов
		 */
		private var container:DisplayObjectContainer;
		
		/**
		 * Ссылка на стейт, указанный для активации 
		 */
		private var showedState:Screen;
		
		/**
		 * Ссылка на текущий активный стейт
		 */
		private var activeState:Screen;
		
		/**
		 * 
		 * @param container
		 * @param width
		 * 
		 */
		public function ScreenSlider(container:DisplayObjectContainer, width:uint=700){
			super();
			
			this.width = width;
			
			this._states = new Object();
			
			this.container = container;
		}
		
		/**
		 * Реристрирует переданный стейт в текущей машине 
		 * @param state экземпляр класса <code>State</code>
		 * 
		 */
		public function register(state:Screen):void{
			const key:String = state.key;
			this._states[key] = state;
			state.manager = this;
			state.init();
			
			if(state.enabled) state.disable();
			state.addEventListener(StateEvent.ENABLED, this.handleStateEnabled);
			state.addEventListener(StateEvent.DISABLED, this.handleStateDisabled);
			
			super.dispatchEvent(new StateEvent(StateEvent.REGISTRED, false, false, state));
		}
		
		/**
		 * Возвращает экземпляр <code>State</code> по ключу
		 * @param key уникальный ключ требуемого состояния
		 * @return 
		 * 
		 */
		public function getState(key:String):Screen{
			return this._states[key] as Screen;
		}
		
		/**
		 * Активировать указанное состояние 
		 * @param key
		 * 
		 */
		public function activateState(key:String):void{
			var old_key:String = this.showedState ? this.showedState.key : '';
			var same:Boolean = old_key == key;
			if(same || this.worked) return;
			
			this.showedState = this.getState(key);
			if(this.showedState){
				this.showedState.enable();
			}
		}
				
		private function handleStateEnabled(event:StateEvent):void{
			const layout:DisplayObject = this.showedState.getLayout();
			Tweener.addTween(layout, {
				time: .5,
				x: 0,
				transition:'easeOutQuad',
				onUpdate: this.onShowTweenUpdate,
				onComplete: this.onShowTweenComplete
			});
			this.worked = true;
		}
		
		private function handleStateDisabled(event:StateEvent):void{
			this.activeState = this.showedState;
		}
		
		internal function addLayout(layout:DisplayObject):void{
			if(!layout) throw new Error();
			var pos:Point = this.getLayoutPosition();
			if(pos.x == 0){
				pos.x = -layout.width;
			}
			layout.x = pos.x;
			layout.y = pos.y;
			
			this.container.addChild(layout);
		}
		
		internal function removeLayout(layout:DisplayObject):void{
			this.container.removeChild(layout);
		}
		
		/**
		 * Возвращает точку, в которую отслайдится старый стейт 
		 * @return <code>Point</code>
		 */
		private function getLayoutPosition():Point{
			var x:uint;
			var length:uint = this.container.numChildren;
			for(var i:uint; i<length; i++){
				var layout:DisplayObject = this.container.getChildAt(i);
				x += this.width;
			}
			return new Point(x, 0);
		}
		
		private function onShowTweenComplete():void{
//			if(this.activeState){
//				this.activeState.disable();
//			}else{
//				this.activeState = this.showedState;
//			}
			
			if(this.activeState){
				this.activeState.disable();
			}
			
			this.activeState = this.showedState;
			this.worked = false;
		}
		
		private function onShowTweenUpdate():void{
			if(this.activeState && this.showedState){
				var active_layout:DisplayObject = this.activeState.getLayout();
				var showed_layout:DisplayObject = this.showedState.getLayout();
				active_layout.x = showed_layout.x - this.width;
			}
		}
	}
}
import adiwars.states.Screen;

import flash.geom.Point;

internal class StateInfo{
	public var state:Screen;
	public var layoutPosition:Point;
	
	public function StateInfo(state:Screen, layoutPosition:Point){
		this.state = state;
		this.layoutPosition = layoutPosition;
	}
}