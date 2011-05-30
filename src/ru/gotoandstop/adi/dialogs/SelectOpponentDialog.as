package ru.gotoandstop.adi.dialogs{
	import adiwars.clips.SelectOpponentDialogClip;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.informers.AvailableButtonController;
	import ru.gotoandstop.adi.menu.GetEnemyMatch;
	import ru.gotoandstop.adi.ui.ItemContainer;
	import ru.gotoandstop.adi.ui.UICommandEvent;
	import ru.gotoandstop.adi.values.BooleanValue;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import ru.gotoandstop.adi.remote.RemoteEvent;
	import ru.gotoandstop.adi.remote.RemoteRequest;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SelectOpponentDialog extends Dialog{
		private var view:SelectOpponentDialogClip;
		private var itemsContainer:ItemContainer;
		private var items:Vector.<OpponentItem>;
		
		private var battleAvailable:BooleanValue;
		private var confirmController:AvailableButtonController;
		
		private var _selectedItem:OpponentItem;
		public function get selectedItem():OpponentItem{
			return this._selectedItem;
		}
		public function set selectedItem(value:OpponentItem):void{
			this._selectedItem = value;
			this.battleAvailable.value = Boolean(this._selectedItem);
		}
		
		public function SelectOpponentDialog(context:Context, list:XMLList){
			super(context);
			
			FilterShortcuts.init();
			
			this.view = new SelectOpponentDialogClip();
			this.view.cacheAsBitmap = true;
			this.view.x -= 700;
			
			OpponentItem.initHint(this.view.popup);
			
			this.items = new Vector.<OpponentItem>();
			
			this.itemsContainer = new ItemContainer(2, 3);
			this.itemsContainer.setLayout('horizontal', 185*3, new Point(185, 143), 'easeInBack');
			
			this.view.point.addChild(this.itemsContainer);
			
			Tweener.addTween(this.view, {time:0.8, x:0, transition:'easeOutElastic'});
			
			super.container.addChild(this.view);
			this.createListeners();
			
			this.battleAvailable = new BooleanValue();
			this.confirmController = new AvailableButtonController(this.view.confirmButton, this.battleAvailable);
			
			this.drawEnemies(list);
		}
		
		private function drawEnemies(list:XMLList):void{
			this.destroyItems();
			
			for each(var item:XML in list){
				var opponent:OpponentItem = new OpponentItem(this.itemsContainer, super.context, item);
				opponent.addEventListener(Event.SELECT, this.handleSelect);
				
				this.items.push(opponent);
			}
			
			this.itemsContainer.next();
		}
		
		public override function close():void{
			super.close();
			this.destroyListeners();
			Tweener.addTween(this.view, {time:0.4, x:-700,y:200-200, rotation:0, transition:'easeInQuad', onComplete: this.onHideComplete});
		}
		
		private function onHideComplete():void{
			//super.container.removeChild(this.view);
		}
		
		private function createListeners():void{
			this.view.confirmButton.addEventListener(MouseEvent.CLICK, this.handleConfirm);
			this.view.closeButton.addEventListener(MouseEvent.CLICK, this.handleClose);
			this.view.refreshButton.addEventListener(MouseEvent.CLICK, this.handleRefresh);
		}
		
		private function destroyListeners():void{
			this.view.confirmButton.removeEventListener(MouseEvent.CLICK, this.handleConfirm);
			this.view.closeButton.removeEventListener(MouseEvent.CLICK, this.handleClose);
			this.view.refreshButton.removeEventListener(MouseEvent.CLICK, this.handleRefresh);
		}
		
		private function destroyItems():void{
			for each(var item:OpponentItem in this.items){
				item.removeEventListener(Event.SELECT, this.handleSelect);
			}
			this.items = new Vector.<OpponentItem>();
		}
		
		private function handleClose(event:MouseEvent):void{
			super.dispatchEvent(UICommandEvent.command('close'));
			this.destroyListeners();
		}
		
		private function handleConfirm(event:MouseEvent):void{
			this.destroyListeners();
			var params:Object = {opponent: this.selectedItem.definition.toXMLString()};
			super.dispatchEvent(UICommandEvent.command('confirm', params));
		}
		
		private function handleRefresh(event:MouseEvent):void{
			this.selectedItem = null;
			this.updateMatch();
		}
		
		private function handleSelect(event:Event):void{
			const item:OpponentItem = event.currentTarget as OpponentItem;
			if(this.selectedItem && item!=this.selectedItem){
				this.selectedItem.lightOff();
			}
			this.selectedItem = item;
		}
		
		private function updateMatch():void{
			var request:GetEnemyMatch = new GetEnemyMatch();
			request.addEventListener(Event.COMPLETE, this.handleMatch);
			request.execute();
		}
		
		private function handleMatch(event:Event):void{
			const request:GetEnemyMatch = event.target as GetEnemyMatch;
			request.removeEventListener(RemoteEvent.COMPLETE, this.handleMatch);
			
			this.drawEnemies(request.enemies);
		}
		
		private function getTextFieldByName(clip:DisplayObjectContainer, name:String):TextField{
			return clip.getChildByName(name) as TextField;
		}
	}
}
import ru.gotoandstop.adi.ITemp;
import adiwars.clips.OpponentItemClip;
import adiwars.clips.OpponentItemInfoClip;
import ru.gotoandstop.adi.core.Context;
import ru.gotoandstop.adi.ui.GameItem;
import ru.gotoandstop.adi.ui.ItemContainer;

import caurina.transitions.Tweener;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ru.gotoandstop.adi.remote.RemoteEvent;
import ru.gotoandstop.adi.remote.RemoteRequest;

internal class OpponentItem extends GameItem{
	private static var hideID:uint;
	public static function initHint(hinter:OpponentItemInfoClip):void{
		hinter.alpha = 0;
		hinter.mouseEnabled = false;
		hinter.mouseChildren = false;
		OpponentItem.hinter = hinter;
	}
	
	private static var hinter:OpponentItemInfoClip;
	private static function hint(item:OpponentItem):void{
		clearTimeout(OpponentItem.hideID);
		var offset:Point = new Point(110, 75);
		var pos:Point = item.clip.localToGlobal(offset);
		var hinter:OpponentItemInfoClip = OpponentItem.hinter;
		
		var d:XML = item.definition;
		
		var s:uint = d.@strength;
		var ag:uint = d.@agility;
		var ac:uint = d.@accuracy;
		var h:uint = d.@health;
		var b:uint = d.@battles;
		var w:uint = d.@wins;
		var name:String = d.@nick;
		var lvl:uint = d.@lvl;
		var url:String = d.@userpic;
		
		hinter.s.text = s.toString();
		hinter.ag.text = ag.toString();
		hinter.ac.text = ac.toString();
		hinter.h.text = h.toString();
		hinter.b.text = b.toString();
		hinter.w.text = w.toString();
		hinter.username.text = name;
		hinter.lvl.text = lvl.toString();
		
		var ava:DisplayObject = item.context.getRemoteImage(url);//loader2:Loader = new Loader();
		//loader2.load(new URLRequest(url));
		hinter.avatar.addChild(ava);//loader2);
		
		hinter.alpha = 1;
		OpponentItem.hideID = setTimeout(OpponentItem.hideHint, 2000);
		
		Tweener.addTween(OpponentItem.hinter, {x:pos.x, y:pos.y, time:0.3, transition:'easeInSine'});
	}
	
	private static function hideHint():void{
		Tweener.removeTweens(OpponentItem.hinter);
		Tweener.addTween(OpponentItem.hinter, {alpha:0, time:0.3, transition:'easeInSine'});
	}
	
	private var clip:OpponentItemClip;
	public var name:String;
	public var definition:XML;
	private var co:ItemContainer;
	
	private var showID:uint;
	
	public function OpponentItem(container:ItemContainer, context:Context, definition:XML){
		super(container, context);
		this.definition = definition;
		this.co = container;
		trace(definition.toXMLString())
		
		this.clip = new OpponentItemClip();
		this.clip.mouseChildren = false;
		this.clip.selection.alpha = 0;
		container.addChild(this.clip);
		this.addListeners();
		
		this.setProfile(definition.@lvl, definition.@userpic);
		this.setName(definition.@nick);
		
		this.setParams(
			definition.@strength, definition.@pstrength,
			definition.@agility, definition.@pagility,
			definition.@accuracy, definition.@paccuracy,
			definition.@health, definition.@phealth,
			
			definition.@battles, definition.@wins
		);
	}
	
	private function setName(name:String):void{
		this.clip.username.text = name;
	}
	
	private function setParams(s:uint, sp:Number, ag:uint, agp:Number, ac:uint, acp:Number, h:uint, hp:Number, b:uint, w:uint):void{
		new OpponentParamInformer(s, sp, this.clip.sLine, this.clip.strengthfield);
		new OpponentParamInformer(ag, agp, this.clip.agLine, this.clip.agilityfield);
		new OpponentParamInformer(ac, acp, this.clip.accLine, this.clip.accuracyfield);
		new OpponentParamInformer(h, hp, this.clip.hLine, this.clip.healthfield);
	}
	
	private function setProfile(lvl:uint, url:String):void{
		var user_lvl:TextField = this.clip.userbox.getChildByName('level') as TextField;
		var user_pic:MovieClip = this.clip.userbox.getChildByName('userpic') as MovieClip;
		
		user_lvl.text = lvl.toString();
		
		//var loader:Loader = new Loader();
		//loader.load(new URLRequest(url));
		var ava:DisplayObject = super.context.getRemoteImage(url);
		
		user_pic.addChild(ava);
	}
	
	private function handleClick(event:MouseEvent):void{
		this.lightOn();
		
		super.dispatchEvent(new Event(Event.SELECT));
	}
	
	private function handleOver(event:MouseEvent):void{
		this.clearPopupTimeout();
		this.showID = setTimeout(OpponentItem.hint, 1000, this);
	}
	
	private function handleOut(event:MouseEvent):void{
		this.clearPopupTimeout();
//		this.hideID = setTimeout(this.hidePop, 500);
	}
	
	private function handleRemoved(event:MouseEvent):void{
		this.removeListeners();
	}
	
	private function clearPopupTimeout():void{
		clearTimeout(this.showID);
	}
	
	private function removeListeners():void{
		this.clip.removeEventListener(MouseEvent.CLICK, this.handleClick);
		this.clip.removeEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
		this.clip.removeEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
		this.clip.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
	}
	
	private function addListeners():void{
		this.clip.addEventListener(MouseEvent.CLICK, this.handleClick);
		this.clip.addEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
		this.clip.addEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
		this.clip.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);	
	}
	
	public override function lightOn():void{
		super.lightOn();
		Tweener.addTween(this.clip.selection, {alpha:1, time:0.1, transition:'easeInSine'});
	}
	
	public override function lightOff():void{
		super.lightOff();
		Tweener.addTween(this.clip.selection, {alpha:0, time:0.6, transition:'easeInSine'});
	}
}

internal class OpponentParamInformer{
	public function OpponentParamInformer(value:uint, ratio:Number, clip:MovieClip, field:TextField){
		field.text = value.toString();
		
		var frame:uint = (ratio/100) * clip.totalFrames;
		clip.gotoAndStop(frame);
	}
}