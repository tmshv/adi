package ru.gotoandstop.adi.character{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseModel;
	import ru.gotoandstop.adi.core.mvc.IModel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * Модель участника битвы
	 * описывает состояние персонажа во время боя
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BattleCharModel extends EventDispatcher implements IModel{
		private var _definition:CharDefinition;
		public function get definition():CharDefinition{
			return this._definition;
		}
		
		private var _lastHealthValue:uint;
		public function get lastHealthValue():uint{
			return this._lastHealthValue;
		}
		
		private var _currentHealth:uint;
		public function get currentHealth():uint{
			return this._currentHealth;
		}
		public function set currentHealth(value:uint):void{
			this._lastHealthValue = this.currentHealth;
			this._currentHealth = value;
			
			//super.dispatch();
			this.update();
		}
		
		private var _totalHealth:uint;
		public function get totalHealth():uint{
			return this._totalHealth;
		}
		
		public function BattleCharModel(definition:CharDefinition){
			super();
			
			this._totalHealth = definition.health;
			this._currentHealth = definition.health;
			
			this._definition = definition;
		}
		
		public function getRatioHealth():Number{
			return this.currentHealth / this.totalHealth;
		}
		
		public function update():void{
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public override function toString():String{
			var text:String = '[char model <def>]';
			text = text.replace(/<def>/, this.definition);
			return text;
		}
	}
}