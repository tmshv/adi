package ru.gotoandstop.adi.core.mvc{
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.IContextDependent;
	
	import flash.display.Sprite;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class BaseView extends Sprite implements IView, IContextDependent{
		private var _model:IModel;
		public function get model():IModel{
			return this._model;
		}
		
		private var _context:Context;
		public function get context():Context{
			return this._context;
		}
		
		public function BaseView(model:IModel, context:Context){
			super();
			this._model = model;
			this._context = context;
		}		
	}
}