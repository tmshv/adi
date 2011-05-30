package adiwars.core.mvc{
	import flash.events.IEventDispatcher;

	/**
	 *
	 * @author Timashev Roman
	 */
	public interface IModel extends IEventDispatcher{
		function update():void;		
	}
}