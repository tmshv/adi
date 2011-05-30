package adiwars.skills{
	import adiwars.ITemp;
	import adiwars.clips.SkillItemClip;
	import adiwars.command.Invoker;
	import adiwars.core.Context;
	import adiwars.user.SkillItem;
	import adiwars.values.IntValue;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SkillItemView extends Sprite{
		private var item:SkillItem;
		private var context:Context;
		
		private var informers:Vector.<ITemp>;
		private var level:IntValue;
		
		public function SkillItemView(context:Context, item:SkillItem, skillUp:Invoker){
			super();
			this.item = item;
			this.context = context;
			this.init(skillUp);
		}
		
		private function init(skillUp:Invoker):void{
			//this.context.owner.skillPoints.addEventListener(Event.CHANGE, this.handleSkillPoints);
			this.informers = new Vector.<ITemp>();
			
			var clip:SkillItemClip = new SkillItemClip();
			//clip.mouseChildren = false;
			clip.cacheAsBitmap = true;
			
			this.level = new IntValue();
			this.addInformer(new LevelInformer(clip.level, this.level));
			this.addInformer(new AvatarInformer(clip.point, this.level));
			this.addInformer(new UpButtonController(clip.upLevelButton, this.level, this.context.owner.skillPoints, skillUp));
			
			var ava:DisplayObject = this.context.getResourceClip(this.item.image);
			if(ava) clip.point.addChild(ava);
			
			super.addChild(clip);
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
			
			this.level.value = this.item.level;
			this.item.addEventListener(Event.CHANGE, this.handleItemChange);
		}
		
		private function addInformer(informer:ITemp):void{
			this.informers.push(informer);
		}
		
		private function handleRemoved(event:Event):void{
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemoved);
			for each(var informer:ITemp in this.informers){
				informer.dispose();
			}
		}
		
		private function handleItemChange(event:Event):void{
			this.level.value = this.item.level;
		}
	}
}

import adiwars.ITemp;
import adiwars.clips.SkillItemLevelInformer;
import adiwars.command.Invoker;
import adiwars.values.IntValue;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;

internal class UpButtonController implements ITemp{
	private var clip:InteractiveObject;
	private var points:IntValue;
	private var level:IntValue;
	private var exe:Invoker;
	
	public function UpButtonController(clip:InteractiveObject, level:IntValue, points:IntValue, skillUp:Invoker){
		this.exe = skillUp;
		this.clip = clip;
		this.level = level;
		this.points = points;
		
		this.clip.addEventListener(MouseEvent.CLICK, this.handleUpClick);
		
		this.points.addEventListener(Event.CHANGE, this.handleValueChange);
		this.level.addEventListener(Event.CHANGE, this.handleValueChange);
		this.update();
	}
	
	public function dispose():void{
		this.clip.removeEventListener(MouseEvent.CLICK, this.handleUpClick);
		this.points.removeEventListener(Event.CHANGE, this.handleValueChange);
		this.level.removeEventListener(Event.CHANGE, this.handleValueChange);
	}
	
	private function handleUpClick(event:MouseEvent):void{
		this.exe.executeCommand();
	}
	
	private function handleValueChange(event:Event):void{
		this.update();
	}
	
	private function update():void{
		var need_to_up:Boolean = this.level.value < 3;
		var enable:Boolean = this.points.value && need_to_up;
		if(enable){
			this.clip.visible = true;
		}else{
			this.clip.visible = false;
		}
	}
}

internal class LevelInformer implements ITemp{
	private var clip:SkillItemLevelInformer;
	private var target:IntValue;
	
	public function LevelInformer(clip:SkillItemLevelInformer, target:IntValue){
		this.clip = clip;
		this.target = target;
		target.addEventListener(Event.CHANGE, this.handleChange);
		this.update(target.value);
	}
	
	public function dispose():void{
		
	}
	
	private function handleChange(event:Event):void{
		this.update(this.target.value);
	}
	
	private function update(value:uint):void{
		if(value == 0){
			this.clip.visible = false;
		}else{
			this.clip.visible = true;
			this.clip.field.text = value.toString();
		}
	}
}

internal class AvatarInformer implements ITemp{
	private var clip:DisplayObject;
	private var target:IntValue;
	
	public function AvatarInformer(clip:DisplayObject, target:IntValue){
		this.clip = clip;
		this.target = target;
		target.addEventListener(Event.CHANGE, this.handleChange);
		this.update(target.value);
	}
	
	public function dispose():void{
		
	}
	
	private function handleChange(event:Event):void{
		this.update(this.target.value);
	}
	
	private function update(value:uint):void{
		if(value == 0){
			this.displayNotLearned();
		}else{
			this.displayDefault();
		}
	}
	
	private function displayNotLearned():void{
		this.clip.filters = [this.getGrayColorFilter()];
	}
	
	private function displayDefault():void{
		this.clip.filters = [];
	}
	
	private function getGrayColorFilter():ColorMatrixFilter{
		const value:Number = 0.6;
		return new ColorMatrixFilter([
			0, 0, value, 0, 0,
			0, 0, value, 0, 0,
			0, 0, value, 0, 0,
			0, 0, value, .65, 0
		]);
	}
}