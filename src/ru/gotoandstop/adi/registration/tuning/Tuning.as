package ru.gotoandstop.adi.registration.tuning{
	import adiwars.clips.TuneStateClip;
	import ru.gotoandstop.adi.command.Invoker;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import ru.gotoandstop.adi.ITemp;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Tuning extends Sprite{
		private var clip:TuneStateClip;
		private var dic:Dictionary;
		
		private var informers:Vector.<ITemp>;
		
		public function Tuning(confirm:Invoker, def:Invoker, sp:Invoker, sm:Invoker, agp:Invoker, agm:Invoker, accp:Invoker, accm:Invoker){
			super();
			this.clip = new TuneStateClip();
			super.addChild(this.clip);
			this.informers = new Vector.<ITemp>();
			this.dic = new Dictionary();
			this.init(confirm, def, sp, sm, agp, agm, accp, accm);
		}
		
		private function init(confirm:Invoker, def:Invoker, sp:Invoker, sm:Invoker, agp:Invoker, agm:Invoker, accp:Invoker, accm:Invoker):void{
			this.createListeners();
			
			this.createButton(this.clip.confirmButton, confirm);
			this.createButton(this.clip.defaultButton, def);
			
			this.createLine(this.clip.sButton, sp, sm);
			this.createLine(this.clip.agButton, agp, agm);
			this.createLine(this.clip.accButton, accp, accm);
		}
		
		private function dispose():void{
			this.disposeInformers();
			this.removeListeners();
			
			this.deleteButton(this.clip.confirmButton);
			this.deleteButton(this.clip.defaultButton);
			
			this.removeLine(this.clip.sButton);
			this.removeLine(this.clip.agButton);
			this.removeLine(this.clip.accButton);
		}
		
		private function createListeners():void{
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoveFromStage);
		}
		
		private function removeListeners():void{
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoveFromStage);
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
		
		private function handleRemoveFromStage(event:Event):void{
			this.dispose();
		}
		
		private function handleButton(event:MouseEvent):void{
			var command:Invoker = this.dic[event.currentTarget] as Invoker;
			if(command){
				command.executeCommand();
			}
		}
		
		public function addInformer(i:ITemp):void{
			this.informers.push(i);
		}
		
		private function disposeInformers():void{
			for each(var i:ITemp in this.informers){
				i.dispose();
			}
			this.informers = new Vector.<ITemp>();
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
			return this.clip.accValue;
		}
		
		public function get availableField():TextField{
			return this.clip.availablePointsField;
		}
		
		public function get nickField():TextField{
			return this.clip.charname;
		}
	}
}