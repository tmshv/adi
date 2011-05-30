package adiwars.core.mvc{
	import adiwars.core.Context;
	import adiwars.core.IContextDependent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class BaseController extends EventDispatcher implements IController, IContextDependent{
		private var _container:DisplayObjectContainer;
		public function get container():DisplayObjectContainer{
			return this._container;
		}
		public function set container(value:DisplayObjectContainer):void{
			this._container = value;
		}
		
		private var _context:Context;
		public function get context():Context{
			return this._context;
		}
		public function set context(value:Context):void{
			this._context = value;
		}
		
		public function BaseController(container:DisplayObjectContainer, context:Context){
			super();
			this.container = container;
			this.context = context;
		}
	}
}