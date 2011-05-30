package ru.gotoandstop.adi.menu{
	import adiwars.clips.LevelUpClip;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.ITemp;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class LevelUpView extends Sprite{
		private var clip:LevelUpClip;
		private var dic:Dictionary;
		private var informers:Vector.<ITemp>;
		
		public function LevelUpView(confirm:Invoker, si:Invoker, sd:Invoker, agi:Invoker, agd:Invoker, aci:Invoker, acd:Invoker){
			super();
			this.clip = new LevelUpClip();
			this.clip.cacheAsBitmap = true;
			super.addChild(this.clip);
			this.dic = new Dictionary();
			this.informers = new Vector.<ITemp>();
			
			this.clip.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
			this.createButton(this.clip.confirmButton, confirm);
			
			this.createLine(this.clip.sButton, si, sd);
			this.createLine(this.clip.agButton, agi, agd);
			this.createLine(this.clip.accButton, aci, acd);
		}
		
		private function handleRemoved(event:Event):void{
			this.clip.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
			this.deleteButton(this.clip.confirmButton);
			
			this.removeLine(this.clip.sButton);
			this.removeLine(this.clip.agButton);
			this.removeLine(this.clip.accButton);
		}
		
		private function handleButton(event:MouseEvent):void{
			var command:Invoker = this.dic[event.currentTarget] as Invoker;
			if(command){
				command.executeCommand();
			}
		}
		
		private function createLine(bu:*, p:Invoker, m:Invoker):void{
			this.createButton(bu.p, p);
			this.createButton(bu.m, m);
		}
		
		private function removeLine(bu:*):void{
			this.deleteButton(bu.p);
			this.deleteButton(bu.m);
		}
		
		private function createButton(target:IEventDispatcher, action:Invoker):void{
			this.dic[target] = action;
			target.addEventListener(MouseEvent.CLICK, this.handleButton);
		}
		
		private function deleteButton(target:IEventDispatcher):void{
			this.dic[target] = null;
			target.removeEventListener(MouseEvent.CLICK, this.handleButton);
		}
		
		public function addInformer(i:ITemp):void{
			this.informers.push(i);
		}
		
		public function get strengthLine():MovieClip{
			return this.clip.sLine;
		}
		
		public function get agilityLine():MovieClip{
			return this.clip.agLine;
		}
		
		public function get accuracyLine():MovieClip{
			return this.clip.accLine;
		}
		
		public function get strengthField():TextField{
			return this.clip.sValue;
		}
		
		public function get agilityField():TextField{
			return this.clip.agValue;
		}
		
		public function get accuracyField():TextField{
			return this.clip.acValue;
		}
		
		public function get availableField():TextField{
			return this.clip.bonusField;
		}
	}
}