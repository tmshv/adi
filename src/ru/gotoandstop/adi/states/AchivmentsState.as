package ru.gotoandstop.adi.states{
	import adiwars.clips.AchivmentItemClip;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.ui.ItemContainer;
	import ru.gotoandstop.adi.ui.SlideContainerCommand;
	import ru.gotoandstop.adi.ui.SliderButtonsController;
	import ru.gotoandstop.adi.user.AchieveItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class AchivmentsState extends Screen{
		private var view:View;
		internal override function getLayout():DisplayObject{
			return this.view;
		}
		
		public function AchivmentsState(context:Context){
			super(null, context, 'achiv');
		}
		
		internal override function init():void{
			this.view = new View(85);
		}
		
		public override function enable():void{
			this.view.clear();
			this.update();
			//this.layout.raiting.enable();
			super.manager.addLayout(this.view);
			//this.layout.addEventListener(UICommandEvent.COMMAND, this.handleUICommand);
			
			var next:SlideContainerCommand = new SlideContainerCommand(this.view.container);
			var prev:SlideContainerCommand = new SlideContainerCommand(this.view.container, false);
			var buttons:SliderButtonsController = new SliderButtonsController(new Invoker(next), new Invoker(prev));
			this.view.configureSlideButtons(buttons);
			
			super.enable();
		}
		
		public override function disable():void{
			//this.layout.raiting.disable();
			if(super.manager && this.view) super.manager.removeLayout(this.view);
			//if(this.layout) this.layout.removeEventListener(UICommandEvent.COMMAND, this.handleUICommand);
			super.disable();
		}
		
		private function update():void{
			var list:Vector.<AchieveItem> = super.context.owner.achievements.getList();
			
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
			icon_container.addChild(super.context.getResourceClip(item.image));
			
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
}
import adiwars.clips.AchievementsClip;
import ru.gotoandstop.adi.ui.ItemContainer;
import ru.gotoandstop.adi.ui.PrevNextController;
import ru.gotoandstop.adi.ui.SliderButtonsController;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.text.TextField;

internal class View extends Sprite{
	private var step:uint;
	public var container:ItemContainer;
	private var controller:PrevNextController;
	private var clip:AchievementsClip;
	
	public function View(step:uint){
		this.step = step;
		
		this.clip = new AchievementsClip();
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