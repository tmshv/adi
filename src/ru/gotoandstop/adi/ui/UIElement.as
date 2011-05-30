package ru.gotoandstop.adi.ui{
	import flash.display.DisplayObjectContainer;
	
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.core.Context;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class UIElement extends BaseController{
		public function UIElement(container:DisplayObjectContainer, context:Context){
			super(container, context);
		}
		
		public function enable():void{
			
		}
		
		public function disable():void{
			
		}
	}
}