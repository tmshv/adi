package social{
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public interface ISocialApplication extends IEventDispatcher{
		function get game():ISocialGameApplication;
	}
}