package ru.gotoandstop.adi.character.events{
	import flash.events.Event;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class CharEvent extends Event{
		public static const NECESSARY_COMPLETE:String = 'necessaryComplete';
		public static const COMPLETE:String = 'complete';
		public static const ANIMATION_STATE:String = 'animationState';
		public static const DO_ACTION:String = 'doAction';
		public static const DAMAGE:String = 'damage';
		
		private var _animation:String;
		public function get animation():String{
			return this._animation;
		}
		
		private var _damage:uint;
		public function get damage():uint{
			return this._damage;
		}
		
		public function CharEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, animaiton:String=null, damage:uint=0){
			super(type, bubbles, cancelable);
			this._animation = animaiton;
			this._damage = 0;
		}
		
		public override function clone():Event{
			return new CharEvent(super.type, super.bubbles, super.cancelable, this.animation, this.damage);
		}
	}
}