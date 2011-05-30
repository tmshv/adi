package adiwars.ui{
	import flash.display.DisplayObjectContainer;
	
	import adiwars.core.mvc.BaseController;
	import adiwars.core.Context;
	
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