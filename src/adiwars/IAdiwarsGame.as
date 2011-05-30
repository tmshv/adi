package adiwars{
	import adiwars.core.Config;
	import adiwars.core.Context;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface IAdiwarsGame{
		function launch(context:Context, config:Config):void;
	}
}