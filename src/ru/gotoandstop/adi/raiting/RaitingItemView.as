package ru.gotoandstop.adi.raiting{
	import adiwars.clips.RaitingItemClip;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.core.Context;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RaitingItemView extends Sprite{
		private var hint:MenuController;
		private var achievementsCommand:Invoker;
		private var battleCommand:Invoker;
		private var showID:uint;
		
		private var clip:RaitingItemClip;
		
		public function RaitingItemView(context:Context, item:RaitingItem, menu:MenuController, info:Invoker, battle:Invoker){
			super();
			
			this.clip = new RaitingItemClip();
			this.clip.level.text = item.level.toString();
			this.clip.pos.text = item.top.toString();
			
			this.achievementsCommand = info;
			this.battleCommand = battle;
			this.hint = menu;
			
			var pic:DisplayObject = context.getRemoteImage(item.picURL);
			this.clip.userpic.addChild(pic);
			
			super.addChild(this.clip);
			
			if(context.owner.model.userID != item.userID){
				super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
				super.addEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
				super.addEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
			}
		}
		
		private function handleRemoved(event:Event):void{
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
			super.removeEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
			super.removeEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
		}
		
		private function handleOver(event:MouseEvent):void{
			clearTimeout(this.showID);
			this.showID = setTimeout(this.show, 500);
		}
		
		private function handleOut(event:MouseEvent):void{
			clearTimeout(this.showID);
			this.showID = setTimeout(this.hide, 3000);
		}
		
		private function show():void{
			var coord:Point = this.clip.localToGlobal(new Point());
			this.hint.show(coord, this.achievementsCommand, this.battleCommand);
		}
		
		private function hide():void{
			this.hint.hide();
		}
	}
}