package ru.gotoandstop.adi.social{
	import ru.gotoandstop.adi.core.Config;
	
	import flash.events.IEventDispatcher;
	
	import ru.gotoandstop.adi.remote.RemoteRequest;

	/**
	 *
	 * @author Timashev Roman
	 */
	public interface ISocialGameApplication extends IEventDispatcher{
		function launch(config:Config):void;
	}
}