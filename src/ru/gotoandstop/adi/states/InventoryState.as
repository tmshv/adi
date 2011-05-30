package ru.gotoandstop.adi.states{
	import adiawars.clips.LeiaClip;
	
	import ru.gotoandstop.adi.GoodsItem;
	import ru.gotoandstop.adi.ITemp;
	import ru.gotoandstop.adi.character.CharSuite;
	import ru.gotoandstop.adi.character.CharType;
	import adiwars.clips.ChewbaccaClip;
	import adiwars.clips.GoodsInvItem;
	import adiwars.clips.InventoryClip;
	import adiwars.clips.LukClip;
	import adiwars.clips.VaderClip;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.inventory.CharTuningController;
	import ru.gotoandstop.adi.inventory.InventoryView;
	import ru.gotoandstop.adi.inventory.ItemHint;
	import ru.gotoandstop.adi.inventory.ItemHintController;
	import ru.gotoandstop.adi.inventory.WearedItemContainer;
	import ru.gotoandstop.adi.ui.ItemContainer;
	import ru.gotoandstop.adi.ui.SlideContainerCommand;
	import ru.gotoandstop.adi.ui.SliderButtonsController;
	import ru.gotoandstop.adi.user.Goods;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InventoryState extends Screen{
		private var items:Vector.<GoodsInvItem>;
		private var itemsByClip:Dictionary;
		
		private var view:InventoryView;
		internal override function getLayout():DisplayObject{
			return this.view;
		}
		
		private var ava:Avatar;
		private var charParamsController:CharTuningController;
		
		private var temps:Vector.<ITemp>;
		
		public function InventoryState(context:Context){
			super(null, context, 'inv');
		}
		
		internal override function init():void{
			var suite:Goods = super.context.owner.suite;
			this.ava = new Avatar(super.context.owner.model.charType, suite);
			this.view = new InventoryView(this.ava, 0, suite);
			this.charParamsController = new CharTuningController(super.context, this.view);
			super.context.owner.suite.addEventListener(Event.ADDED, this.handleSuiteAdded);
		}
		
		/**
		 * Активирует интерактив состояния 
		 * 
		 */
		public override function enable():void{
			this.temps = new Vector.<ITemp>();
			
			this.update();
			super.manager.addLayout(this.view);
			
			var next:SlideContainerCommand = new SlideContainerCommand(this.view.container);
			var prev:SlideContainerCommand = new SlideContainerCommand(this.view.container, false);
			var buttons:SliderButtonsController = new SliderButtonsController(new Invoker(next), new Invoker(prev));
			this.view.configureSlideButtons(buttons);
			
			this.ava.enable();
			super.enable();
		}
		
		/**
		 * Деактивирует интерактив состояния 
		 * 
		 */
		public override function disable():void{
			if(super.manager && this.view) super.manager.removeLayout(this.view);
			this.ava.disable();
			super.disable();
			
			for each(var temp:ITemp in this.temps){
				temp.dispose();
			}
			this.temps = null;
		}
		
		private function destroyItemsListeners():void{
			for each(var item:GoodsInvItem in this.items){
				item.removeEventListener(MouseEvent.CLICK, this.handleItemClick);
			}
		}
		
		/**
		 * Перерисовывает список купленных айтемов, аватара. 
		 */
		private function update():void{
			var list:Vector.<String> = super.context.owner.getGoodiesList();
			
			this.view.clear();
			this.items = new Vector.<GoodsInvItem>();
			this.itemsByClip = new Dictionary();
			
			const length:uint = list.length;
			for(var i:uint; i<length; i++){
				var goo:GoodsItem = super.context.getGoodsItem(list[i]);
				var item:GoodsInvItem = this.createItem(goo);
				item.addEventListener(MouseEvent.CLICK, this.handleItemClick);
				this.items.push(item);
				this.itemsByClip[item] = goo;
				this.view.addChild(item);
				
				this.temps.push(new ItemHintController(goo, item));
			}
		}
		
		/**
		 * Создает вьюшку товарного айтема 
		 * @param item
		 * @return 
		 * 
		 */
		private function createItem(item:GoodsItem):GoodsInvItem{
			var clip:GoodsInvItem = new GoodsInvItem();
			clip.cacheAsBitmap = true;
			var ava:DisplayObject = super.context.getResourceClip(item.image);
			if(ava) clip.point.addChild(ava);
			return clip;
		}
		
		private function handleItemClick(event:MouseEvent):void{
			const clip:GoodsInvItem = event.currentTarget as GoodsInvItem;
			const item:GoodsItem = this.itemsByClip[clip];
			this.wearItemUp(item);
		}
		
		private function wearItemUp(item:GoodsItem):void{
			super.context.owner.wearUp(item);
		}
		
		private function sendGoods():void{
			//var list:Vector.<GoodsItem> = super.context.owner.suite.getList();
			var item:GoodsItem = super.context.owner.suite.lastAdded;
			var list:Vector.<String> = new Vector.<String>();
			list.push(item.name);
			
			var r:RemoteRequest = new RemoteRequest();
			r.updateSuite(list);
		}
		
		private function handleSuiteAdded(event:Event):void{
			this.sendGoods();
		}
	}
}

import adiawars.clips.LeiaClip;

import ru.gotoandstop.adi.GoodsItem;
import ru.gotoandstop.adi.character.CharType;
import adiwars.clips.ChewbaccaClip;
import adiwars.clips.InventoryClip;
import adiwars.clips.LukClip;
import adiwars.clips.VaderClip;
import ru.gotoandstop.adi.inventory.WearedItemContainer;
import ru.gotoandstop.adi.ui.ItemContainer;
import ru.gotoandstop.adi.ui.PrevNextInfoController;
import ru.gotoandstop.adi.ui.SliderButtonsController;
import ru.gotoandstop.adi.user.Goods;
import ru.gotoandstop.adi.user.Suite;
import ru.gotoandstop.adi.user.SuiteEvent;
import ru.gotoandstop.adi.values.IntValue2;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.geom.Point;

internal class Avatar extends MovieClip{
	private var model:IEventDispatcher;
	private var clip:MovieClip;
	
	public function Avatar(type:String, suiteModel:Goods){
		this.clip = this.createChar(type);
		super.addChild(this.clip);
		this.model = suiteModel;
		this.enable();
		
		var list:Vector.<GoodsItem> = suiteModel.getList();
		for each(var item:GoodsItem in list){
			this.wearUp(item);
		}
	}
	
	public function enable():void{
		this.model.addEventListener(Event.ADDED, this.handleAdded);
		this.model.addEventListener(Event.REMOVED, this.handleRemoved);
	}
	
	public function disable():void{
		this.model.removeEventListener(Event.ADDED, this.handleAdded);
		this.model.removeEventListener(Event.REMOVED, this.handleRemoved);
	}
	
	private function handleRemoved(event:SuiteEvent):void{
		//trace(event, event.item);
	}
	
	private function handleAdded(event:SuiteEvent):void{
		trace(event, event.item);
		this.wearUp(event.item);
	}
	
	private function wearUp(item:GoodsItem):void{
		if(!item) return;
		var anim:Sprite = this.clip.getChildAt(0) as Sprite;
		var goods_clips:Vector.<MovieClip> = this.getSuiteClips(anim, item.name);
		
		trace('pizda lolol')
		trace(item, item.title)
		trace(goods_clips)
		
		for each(var clip:MovieClip in goods_clips){
			trace(clip, item.frame)
			if(clip) clip.gotoAndStop(item.frame);
		}
	}
	
	private function createChar(type:String):MovieClip{
		var clip:MovieClip;
		switch(type){
			case CharType.CHEWBACCA:
				clip = new ChewbaccaClip();
				break;
			
			case CharType.LEIA:
				clip = new LeiaClip();
				break;
			
			case CharType.LUKE:
				clip = new LukClip();
				break;
			
			case CharType.VADER:
				clip = new VaderClip();
				break;
			
			default:
				clip = new VaderClip();
				break;
		}
		clip.scaleX *= 1.2;
		clip.scaleY *= 1.2;
		clip.stop();
		return clip;
	}
	
	private function getSuiteClips(container:Sprite, type:String):Vector.<MovieClip>{
		type = type.substr(0, 1);
		//trace('processing for type', type)
		
		var s:* = container;	
		var list:Vector.<MovieClip> = new Vector.<MovieClip>();
		switch(type){
			//shoes
			case '1':
				list.push(s.foot_left);
				list.push(s.footRight);
				break;
				
			//pants
			case '2':
				list.push(s.shinRight);
				list.push(s.legRight);
				list.push(s.shinLeft);
				list.push(s.legLeft);
				list.push(s.body.pants);
				break;
				
			//shirts
			case '3':
				list.push(s.forearmRight.jacket);
				list.push(s.forearmLeft.jacket);
				list.push(s.body.jacket);
				break;
			
			//jackets
			case '4':
				list.push(s.forearmRight.jacket);
				list.push(s.forearmLeft.jacket);
				list.push(s.body.jacket);
				break;
			
			//weapone
			case '5':
				list.push(s.weapon);
				break;
		}
		return list;
	}
}