package ru.gotoandstop.adi.states{
	import ru.gotoandstop.adi.core.Context;
	
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class LogState extends Screen{
		public function LogState(container:DisplayObjectContainer, context:Context){
			super(container, context, ApplicationStateKey.LOG);
		}
	}
}