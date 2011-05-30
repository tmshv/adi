package ru.gotoandstop.adi.command{
	import flash.events.IEventDispatcher;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface IAsyncCommand extends IEventDispatcher, ICommand{
		
	}
}