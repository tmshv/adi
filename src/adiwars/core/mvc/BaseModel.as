package adiwars.core.mvc{
	import adiwars.core.Context;
	import adiwars.core.IContextDependent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class BaseModel extends EventDispatcher implements IModel, IContextDependent{
		protected var locked:Boolean;
		
		private var _context:Context;
		public function get context():Context{
			return this._context;
		}
		
		public function BaseModel(context:Context){
			super();
			this._context = context;
		}
		
		public function update():void{
			
		}
		
		protected function dispatch():void{
			if(!this.locked) this.update();
		}
		
		public function lock():void{
			this.locked = true;
		}
		
		public function unlock():void{
			this.locked = false;
		}
	}
}