package adiwars.states{
	import adiwars.ITemp;
	import adiwars.clips.SkillItemClip;
	import adiwars.command.ICommand;
	import adiwars.command.Invoker;
	import adiwars.core.Context;
	import adiwars.skills.HintItemController;
	import adiwars.skills.SkillItemView;
	import adiwars.skills.SkillUpCommand;
	import adiwars.ui.ItemContainer;
	import adiwars.user.SkillItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SkillsState extends Screen{
		private var view:View;
		internal override function getLayout():DisplayObject{
			return this.view;
		}
		
		private var temps:Vector.<ITemp>;
		
		public function SkillsState(context:Context){
			super(null, context, 'skill');
		}
		
		internal override function init():void{
			this.view = new View(new Point(40, 20), 90);
			
//			this.layout = new ItemContainer(0, 4);
//			this.layout.setLayout('vertical', 500, new Point(145, 120), 'easeInSine');
//			
//			for(var i:uint; i<12; i++){
//				var item:SkillItemClip = new SkillItemClip();
//				item.cacheAsBitmap = true;
//				this.layout.addChild(item);
//			}
		}
		
		public override function enable():void{
			this.temps = new Vector.<ITemp>();
			
			this.update();
			//this.layout.raiting.enable();
			super.manager.addLayout(this.view);
			//this.layout.addEventListener(UICommandEvent.COMMAND, this.handleUICommand);
			super.enable();
		}
		
		public override function disable():void{
			for each(var temp:ITemp in this.temps){
				temp.dispose();
			}
			this.temps = null;
			
			//this.layout.raiting.disable();
			if(super.manager && this.view) super.manager.removeLayout(this.view);
			//if(this.layout) this.layout.removeEventListener(UICommandEvent.COMMAND, this.handleUICommand);
			super.disable();
		}
		
		private function update():void{
			var list:Vector.<SkillItem> = super.context.owner.skills.getList();
			
			trace('fucking updating')
			trace(list)
			
			this.view.clear();
			
			const length:uint = list.length;
			for(var i:uint; i<length; i++){
				var item:SkillItem = list[i] as SkillItem;
				var command:ICommand = new SkillUpCommand(item, super.context.owner.skillPoints);
				var view:SkillItemView = new SkillItemView(super.context, item, new Invoker(command));
				var hint_controller:HintItemController = new HintItemController(item, view);
				this.temps.push(hint_controller);
				
				this.view.addChild(view);
			}
		}
		
		private function setColorTo(clip:DisplayObject, color:uint):void{
			var r:uint = color >> 16 & 0xFF;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
//			clip.transform.colorTransform = new ColorTransform(0, 0, 0, 1, r, g, b);
		}
		
//		private function setIndexTo(field:TextField, index:uint):void{
//			field.text = index.toString();
//		}
	}
}

import adiwars.clips.SkillItemHintClip;
import adiwars.skills.SkillHint;
import adiwars.ui.ItemContainer;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;

internal class View extends Sprite{
	private var step:uint;
	private var container:ItemContainer;
	
	public function View(offset:Point, step:uint){
		this.step = step;
		
		this.container = new ItemContainer(3, 4);
		this.container.setLayout('vercital', 500, new Point(125, 100), 'easeInSine');
		this.container.x = offset.x;
		this.container.y = offset.y;
		super.addChild(this.container);
	}
	
	public override function addChild(child:DisplayObject):DisplayObject{
		child.y = this.container.numChildren * this.step;
		return this.container.addChild(child);
	}
	
	public function clear():void{
		while(this.container.numChildren) this.container.removeChildAt(0);
	}
}