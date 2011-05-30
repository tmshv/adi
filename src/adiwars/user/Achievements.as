package adiwars.user{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.sampler.stopSampling;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Achievements extends EventDispatcher{
		private var storage:Object;
		
		public function Achievements(){
			super();
			this.storage = new Object();
		}
		
		public function add(item:AchieveItem):void{
			this.storage[item.id] = item;
		}
		
		public function clear():void{
			this.storage = new Object();
		}
		
		public function getList():Vector.<AchieveItem>{
			var list:Vector.<AchieveItem> = new Vector.<AchieveItem>();
			for each(var item:AchieveItem in this.storage) list.push(item);
			return list;
		}
	}
}