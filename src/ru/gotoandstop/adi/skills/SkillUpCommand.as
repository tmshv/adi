package ru.gotoandstop.adi.skills{
	import ru.gotoandstop.adi.command.IAsyncCommand;
	import ru.gotoandstop.adi.user.SkillItem;
	import ru.gotoandstop.adi.values.IntValue;
	
	import flash.events.EventDispatcher;
	
	import ru.gotoandstop.adi.remote.RemoteEvent;
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SkillUpCommand extends EventDispatcher implements IAsyncCommand{
		private var item:SkillItem;
		private var skillPoints:IntValue;
		
		public function SkillUpCommand(item:SkillItem, skillPoints:IntValue){
			this.item = item;
			this.skillPoints = skillPoints;
		}
		
		public function execute():void{
			trace('executing skill up command')
			//trace(this.item)
			
			if(this.skillPoints.value){
				this.sendRequest();
			}else{
				
			}
		}
		
		private function sendRequest():void{
			var r:RemoteRequest = new RemoteRequest();
			r.addEventListener(RemoteEvent.COMPLETE, this.handleUpComplete);
			r.addEventListener(RemoteEvent.ERROR, this.handleUpError);
			r.skillUp(this.item.name);
		}
		
		private function handleUpComplete(event:RemoteEvent):void{
			const r:RemoteRequest = event.target as RemoteRequest;
			r.removeEventListener(RemoteEvent.COMPLETE, this.handleUpComplete);
			r.removeEventListener(RemoteEvent.ERROR, this.handleUpError);
			
			var x:XML = event.response.item[0];
			var skill:String = x.@skill;
			var level:uint = x.@lvl;
			var points:uint = x.@skillpoints;
			
			trace('skill up complete')
			trace(x.toXMLString());
			trace(skill, level, points)
			
			if(skill == this.item.name){
				this.skillPoints.value = points;
				this.item.level = level;
			}
			
			//this.skillPoints.value --;
			//this.item.level ++;
		}
		
		private function handleUpError(event:RemoteEvent):void{
			const r:RemoteRequest = event.target as RemoteRequest;
			r.removeEventListener(RemoteEvent.COMPLETE, this.handleUpComplete);
			r.removeEventListener(RemoteEvent.ERROR, this.handleUpError);
			
			trace('skill up error', event.response.toXMLString());
		}
	}
}