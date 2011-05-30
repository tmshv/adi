package adiwars.ui{
	import adiwars.ITemp;
	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class GroupController implements ITemp{
		private var _active:DisplayObject;
		private var list:Vector.<DisplayObject>;
		
		public function GroupController(...items){
			this.list = new Vector.<DisplayObject>();
			
			for each(var item:DisplayObject in items){
				if(item is DisplayObject){
					this.add(item);
				}
			}
		}
		
		public function add(item:DisplayObject):void{
			this.list.push(item);
			item.filters = [this.getFilter()]; 
		}
		
		public function select(item:DisplayObject):void{
			if(this._active){
				this._active.filters = [this.getFilter()];
			}
			
			trace('selected was', this._active)
			
			this._active = item;
			this._active.filters = [];
		}
		
		public function dispose():void{
			for each(var item:DisplayObject in list){
				item.filters = [];
			}
			this.list = null;
		}
		
		private function getFilter():ColorMatrixFilter{
			return new ColorMatrixFilter([
				.33, .33, .33, 0, 0,
				.33, .33, .33, 0, 0,
				.33, .33, .33, 0, 0,
				0,   0,   0,   1, 0
			]);
//			const value:Number = 0.6;
//			return new ColorMatrixFilter([
//				0, 0, value, 0, 0,
//				0, 0, value, 0, 0,
//				0, 0, value, 0, 0,
//				0, 0, value, .65, 0
//			]);
		}
	}
}