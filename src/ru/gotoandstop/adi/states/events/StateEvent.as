package ru.gotoandstop.adi.states.events{
	import ru.gotoandstop.adi.states.Screen;
	
	import flash.events.Event;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class StateEvent extends Event{
		public static const REGISTRED:String = 'stateRegistred';
		public static const DISABLED:String = 'stateDisabled';
		public static const ENABLED:String = 'stateEnabled';
		
		private var _state:Screen;
		public function get state():Screen{
			return this._state;
		}
		
		public function StateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, state:Screen=null){
			super(type, bubbles, cancelable);
			this._state = state;
		}
		
		public override function clone():Event{
			return new StateEvent(super.type, super.bubbles, super.cancelable, this.state);
		}
	}
}