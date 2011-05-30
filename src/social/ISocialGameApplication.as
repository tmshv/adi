package social{
	import adiwars.core.Config;
	
	import flash.events.IEventDispatcher;
	
	import remote.RemoteRequest;

	/**
	 *
	 * @author Timashev Roman
	 */
	public interface ISocialGameApplication extends IEventDispatcher{
		function launch(config:Config):void;
	}
}