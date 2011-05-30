package ru.gotoandstop.adi.states{
	import ru.gotoandstop.adi.character.CharType;
	import adiwars.clips.MainMenuChewbaccaClip;
	import adiwars.clips.MainMenuLeiaClip;
	import adiwars.clips.MainMenuLukeClip;
	import adiwars.clips.MainMenuStateClip;
	import adiwars.clips.MainMenuVaderClip;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseView;
	import ru.gotoandstop.adi.raiting.Raiting;
	import ru.gotoandstop.adi.ui.UICommandEvent;
	import ru.gotoandstop.adi.user.UserInfoPanel;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	[Event(name="command", type="ru.gotoandstop.adi.ui.UICommandEvent")]
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class MenuView extends BaseView{
		private const OVERED_AMOUNT:Number = 1;
		
		private var clip:MainMenuStateClip;
		
		private var char:MenuChar;
		private var anim:MovieClip;
		
		public var raiting:Raiting;
		
		private var locker:Bitmap;
		
		public function MenuView(context:Context){
			super(null, context);
			this.init();
		}
		
		private function init():void{
			FilterShortcuts.init();
			
			this.clip = new MainMenuStateClip();
			super.addChild(clip);
			
			this.locker = new Bitmap();
			super.addChild(this.locker);
			
			super.context.owner.model.addEventListener('change', this.handleUserModelChange);
			this.updateChar();
			
			this.raiting = new Raiting(this.clip.raiting, super.context);
			
			var user:UserInfoPanel = new UserInfoPanel(this.clip.user, super.context);
			
			this.createButton(this.clip.menu.arena);
			this.createButton(this.clip.menu.bank);
			this.createButton(this.clip.menu.shop);
		}
		
		private function updateChar():void{
			if(this.char){
				this.clip.char.removeChild(this.char);
				this.destroyButton(this.char);
			}
			
			this.char = new MenuChar(super.context.owner.model.charType);
			this.char.name = 'bag';
			this.char.filters = this.clip.char.filters;
			this.clip.char.addChild(this.char);
			this.anim = this.clip.anim;
			
			this.createButton(this.char);
		}
		
		public function unlock():void{
			super.mouseChildren = true;
			Tweener.addTween(this.locker, {time:1, alpha:0, transition:'easeOuySine', onComplete:this.onTweenComplete});
		}
		
		private function onTweenComplete():void{
			this.clearLocker();
		}
		
		private function clearLocker():void{
			var bmp:BitmapData = this.locker.bitmapData;
			if(bmp){
				bmp.dispose();
			}
		}
		
		public function lock():void{
			Tweener.removeTweens(this.locker);
			
			this.locker.alpha = 1;
			var bmp:BitmapData = new BitmapData(700, 600, false);
			bmp.draw(this.clip);
			this.locker.bitmapData = bmp;
			
			bmp.applyFilter(bmp, bmp.rect, new Point(), new BlurFilter(6, 6, 2));
			//bmp.applyFilter(bmp, bmp.rect, new Point(), this.getGrayColorFilter());
			
			super.mouseChildren = false;
		}
		
		private function getGrayColorFilter():ColorMatrixFilter{
			//return new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])
			var matrix:Array = [
				1,0,0,0,50,
				0,1,0,0,50,
				0,0,1,0,50,
				0,0,0,1,0
			];
			return new ColorMatrixFilter(matrix);
			
			const value:Number = 0.99;
			return new ColorMatrixFilter([
				0, 0, value, 0, 0,
				0, 0, value, 0, 0,
				0, 0, value, 0, 0,
				0, 0, value, .95, 0
			]);
		}
		
		private function createButton(button:Sprite):void{
			button.addEventListener(MouseEvent.MOUSE_OVER, this.handleCharButtonOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, this.handleCharButtonOut);
			button.addEventListener(MouseEvent.CLICK, this.handleCharButtonClick);
		}
		
		private function destroyButton(button:Sprite):void{
			button.removeEventListener(MouseEvent.MOUSE_OVER, this.handleCharButtonOver);
			button.removeEventListener(MouseEvent.MOUSE_OUT, this.handleCharButtonOut);
			button.removeEventListener(MouseEvent.CLICK, this.handleCharButtonClick);
		}
		
		private function handleCharButtonOver(event:MouseEvent):void{
			const button:Sprite = event.currentTarget as Sprite;
			this.glow(button, this.OVERED_AMOUNT);
		}
		
		private function handleCharButtonOut(event:MouseEvent):void{
			const button:Sprite = event.currentTarget as Sprite;	
			this.glow(button);
		}
		
		private function handleCharButtonClick(event:MouseEvent):void{
			const button:Sprite = event.currentTarget as Sprite;
			this.executeCommandFrom(button);
		}
		
		private function glow(button:Sprite, amount:Number=0):void{
			var fi:GlowFilter = button.filters[0];
			trace(fi)
			//trace(fi.color.toString(16))
			
			Tweener.removeTweens(button);
			Tweener.addTween(button, {_Glow_blurX:amount * 10, _Glow_blurY:amount * 10, _Glow_strength:amount * 5, time:.5});
		}
		
		private function executeCommandFrom(button:DisplayObject):void{
			trace('command by', button.name)
			 
			super.dispatchEvent(UICommandEvent.command(button.name));
		}
		
		private function handleUserModelChange(event:Event):void{
			this.updateChar();
		}
	}
}