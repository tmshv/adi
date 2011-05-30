package ru.gotoandstop.adi.user{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.sampler.stopSampling;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Skills extends EventDispatcher{
		private var storage:Object;
		
		public function Skills(){
			super();
			this.storage = new Object();
		}
		
		public function add(item:SkillItem):void{
			var old:SkillItem = this.storage[item.name] as SkillItem;
			if(old){
				//old.description = item.description;
				old.level = item.level;
			}else{
				this.storage[item.name] = item;
			}
		}
		
//		public function clear():void{
//			this.storage = new Object();
//		}
		
		public function getList():Vector.<SkillItem>{
			var list:Vector.<SkillItem> = new Vector.<SkillItem>();
			for each(var item:SkillItem in this.storage) list.push(item);
			return list;
		}
	}
}