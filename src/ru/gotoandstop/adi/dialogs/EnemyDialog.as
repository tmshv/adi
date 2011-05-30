package ru.gotoandstop.adi.dialogs{
	import adiwars.clips.EnemyDialogClip;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.ui.SlideContainerCommand;
	import ru.gotoandstop.adi.ui.SliderButtonsController;
	import ru.gotoandstop.adi.ui.UICommandEvent;
	
	import caurina.transitions.Tweener;
	
	import flash.events.MouseEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class EnemyDialog extends Dialog{
		private var view:View;
		private var controller:EnemyController;
		
		public function EnemyDialog(userID:String, context:Context){
			super(context);
			
			this.view = new View(85);
			this.view.cacheAsBitmap = true;
			this.view.x -= 700;
			
			super.container.addChild(this.view);
			this.createListeners();
			Tweener.addTween(this.view, {time:0.8, x:0, transition:'easeOutElastic'});
			
			this.controller = new EnemyController(userID, this.view);
			
			var next:SlideContainerCommand = new SlideContainerCommand(this.view.container);
			var prev:SlideContainerCommand = new SlideContainerCommand(this.view.container, false);
			var buttons:SliderButtonsController = new SliderButtonsController(new Invoker(next), new Invoker(prev));
			this.view.configureSlideButtons(buttons);
		}
		
		public override function close():void{
			super.close();
			this.destroyListeners();
			Tweener.addTween(this.view, {time:0.4, x:-700, rotation:0, transition:'easeInQuad', onComplete: this.onHideComplete});
		}
		
		private function onHideComplete():void{
			super.container.removeChild(this.view);
		}
		
		private function createListeners():void{
			this.view.clip.closeButton.addEventListener(MouseEvent.CLICK, this.handleConfirm);
		}
		
		private function destroyListeners():void{
			this.view.clip.closeButton.removeEventListener(MouseEvent.CLICK, this.handleConfirm);
		}
		
		private function handleConfirm(event:MouseEvent):void{
			this.destroyListeners();
			super.dispatchEvent(UICommandEvent.command('confirm'));
		}
	}
}

import adiwars.clips.AchievementsClip;
import adiwars.clips.AchivmentItemClip;
import adiwars.clips.EnemyDialogClip;
import ru.gotoandstop.adi.core.Context;
import ru.gotoandstop.adi.ui.ItemContainer;
import ru.gotoandstop.adi.ui.PrevNextController;
import ru.gotoandstop.adi.ui.SliderButtonsController;
import ru.gotoandstop.adi.user.AchieveItem;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.text.TextField;

import ru.gotoandstop.adi.remote.RemoteEvent;
import ru.gotoandstop.adi.remote.RemoteRequest;

internal class View extends Sprite{
	private var step:uint;
	public var container:ItemContainer;
	private var controller:PrevNextController;
	public var clip:EnemyDialogClip;
	
	public function View(step:uint){
		this.step = step;
		
		this.clip = new EnemyDialogClip();
		super.addChild(this.clip);
		
		this.container = new ItemContainer(4, 1);
		this.container.setLayout('vertical', 85*4, new Point(0, 85), 'easeInSine');
		this.clip.point.addChild(this.container);
	}
	
	public function configureSlideButtons(controller:SliderButtonsController):void{
		controller.init(this.clip.downButton, this.clip.upButton, new TextField());
		this.controller = new PrevNextController(this.clip.upButton, this.clip.downButton);
		this.controller.init(this.container.current, this.container.total);
	}
	
	public override function addChild(child:DisplayObject):DisplayObject{
		child.y = this.container.numChildren * this.step;
		return this.container.addChild(child);
	}
	
	public function clear():void{
		while(this.container.numChildren) this.container.removeChildAt(0);
	}
}

internal class EnemyController{
	public var view:View;
	
	public function EnemyController(userID:String, view:View){
		this.view = view;
		var re:RemoteRequest = this.createRequest();
		re.getAchievements(userID);
	}
	
	private function createRequest():RemoteRequest{
		var request:RemoteRequest = new RemoteRequest();
		request.addEventListener(RemoteEvent.COMPLETE, this.handleRequest);
		request.addEventListener(RemoteEvent.ERROR, this.handleRequestError);
		
		return request;
	}
	
	private function destroyRequest(request:RemoteRequest):void{
		request.removeEventListener(RemoteEvent.COMPLETE, this.handleRequest);
		request.removeEventListener(RemoteEvent.ERROR, this.handleRequestError);
	}
	
	/**
	 * @param event
	 */
	private function handleRequest(event:RemoteEvent):void{
		const request:RemoteRequest = event.target as RemoteRequest;
		this.destroyRequest(request);
		
		var list:Vector.<AchieveItem> = new Vector.<AchieveItem>();
		var items:XMLList = event.response..item;
		for each(var item:XML in items){
			list.push(AchieveItem.createByXML(item));
		}
		this.update(list);
		//view.fill();
	}
	
	/**
	 * @param event
	 */
	private function handleRequestError(event:RemoteEvent):void{
		const request:RemoteRequest = event.target as RemoteRequest;
		this.destroyRequest(request);
	}
	
	private function update(list:Vector.<AchieveItem>):void{
		const length:uint = list.length;
		for(var i:uint; i<length; i++){
			var item:AchivmentItemClip = this.createItem(list[i]);
			this.view.addChild(item);
		}
	}
	
	private function createItem(item:AchieveItem):AchivmentItemClip{
		var clip:AchivmentItemClip = new AchivmentItemClip();
		clip.cacheAsBitmap = true;
		clip.description.text = item.description;
		
		//this.setColorTo(clip.icon.getChildByName('color'), item.color);
		var icon_container:DisplayObjectContainer = clip.icon.getChildByName('point') as DisplayObjectContainer;
		icon_container.addChild(Context.inst.getResourceClip(item.image));
		
		for(var i:uint; i<item.level; i++){
			var lvl:DisplayObjectContainer = clip.getChildByName('level'+(i+1)) as DisplayObjectContainer;
			
			this.setIndexTo(lvl.getChildByName('title') as TextField, i+1);
			this.setColorTo(lvl.getChildByName('color'), item.color);
		}
		
		return clip;
	}
	
	private function setColorTo(clip:DisplayObject, color:uint):void{
		var r:uint = color >> 16 & 0xFF;
		var g:uint = color >> 8 & 0xFF;
		var b:uint = color & 0xFF;
		clip.transform.colorTransform = new ColorTransform(0, 0, 0, 1, r, g, b);
	}
	
	private function setIndexTo(field:TextField, index:uint):void{
		field.text = index.toString();
	}
}