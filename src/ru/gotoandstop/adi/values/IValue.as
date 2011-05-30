package ru.gotoandstop.adi.values{
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface IValue extends IEventDispatcher{
		function getValue():*;
		function setValue(value:*):void;
		function update():void;
	}
}