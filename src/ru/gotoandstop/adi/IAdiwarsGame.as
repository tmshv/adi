package ru.gotoandstop.adi{
	import ru.gotoandstop.adi.core.Config;
	import ru.gotoandstop.adi.core.Context;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface IAdiwarsGame{
		function launch(context:Context, config:Config):void;
	}
}