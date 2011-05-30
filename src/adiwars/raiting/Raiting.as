package adiwars.raiting{
	import adiwars.ITemp;
	import adiwars.clips.InviteButton;
	import adiwars.clips.RaitingClip;
	import adiwars.command.ICommand;
	import adiwars.command.Invoker;
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseController;
	import adiwars.states.ApplicationStateKey;
	import adiwars.states.MenuState;
	import adiwars.states.Screen;
	import adiwars.ui.ItemContainer;
	import adiwars.ui.PrevNextController;
	import adiwars.values.IntValue;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	import remote.RemoteEvent;
	import remote.RemoteRequest;
	
	/**
	 * 
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Raiting extends BaseController{
		private var clip:RaitingClip;
		
		private var currentPage:IntValue;
		private var pagesNumber:IntValue;
		private var controller:PrevNextController;
		
		private var bookmarks:Object;
		private var bookmark:Bookmark;
		
		private var itemsContainer:ItemContainer;
		private var current:ItemContainer;
		
		private var temps:Vector.<ITemp>;
		private var menu:MenuController;
		
		public function Raiting(clip:RaitingClip, context:Context){
			super(null, context);
			
			this.clip = clip;
			
			this.currentPage = new IntValue();
			this.pagesNumber = new IntValue();
			this.controller = new PrevNextController(this.clip.prev, this.clip.next);
			this.controller.init(this.currentPage, this.pagesNumber);
			
			this.bookmarks = new Object();
			this.createBookmark(this.clip.friendButton, Bookmark.FRIENDS, 'Рейтинг друзей');
			this.createBookmark(this.clip.allButton, Bookmark.ALL, 'Лучшие игроки');
			
			this.itemsContainer = new ItemContainer(2, 1);
			this.itemsContainer.setLayout('vertical', 80, new Point(0, 80), 'easeInBack');
			
			this.clip.point.addChild(this.itemsContainer);
		}
		
		private function clearContainer():void{
//			const container:DisplayObjectContainer = this.itemsContainer;
//			while(container.numChildren > 1){
//				container.removeChildAt(1);
//			}
		}
		
		private function createItemsList():ItemContainer{
			var items:ItemContainer = new ItemContainer(1, 10);
			items.setLayout('horizontal', 660, new Point(66), 'easeInSine');
			
			this.itemsContainer.addChild(items);
			return items;
		}
		
		private function createBookmark(clip:Sprite, type:String, title:String):Bookmark{
			var bookmark:Bookmark = new Bookmark(clip, type);
			var field:TextField = clip.getChildByName('title') as TextField;
			field.text = title;
			
			this.bookmarks[type] = bookmark;
			return bookmark;
		}
		
		public function enable():void{
			this.clip.next.addEventListener(MouseEvent.CLICK, this.handleNext);
			this.clip.prev.addEventListener(MouseEvent.CLICK, this.handlePrev);
			
			this.menu = new MenuController(this.clip.menu);
			
			this.temps = new Vector.<ITemp>();
			this.temps.push(this.menu);
			
			for each(var bookmark:Bookmark in this.bookmarks){
				bookmark.addEventListener('jaj', this.handleBookmark);
			}
			
			this.clearContainer();
			this.show(Bookmark.FRIENDS);
		}
		
		public function disable():void{
			this.clip.next.removeEventListener(MouseEvent.CLICK, this.handleNext);
			this.clip.prev.removeEventListener(MouseEvent.CLICK, this.handlePrev);
			
			for each(var temp:ITemp in this.temps){
				temp.dispose();
			}
			
			for each(var bookmark:Bookmark in this.bookmarks){
				bookmark.removeEventListener('jaj', this.handleBookmark);
			}
		}
		
		private function handleBookmark(event:Event):void{
			const bookmark:Bookmark = event.currentTarget as Bookmark;
			this.select(bookmark);
			this.show(bookmark.type);
		}
		
		private function select(bookmark:Bookmark):void{
			if(this.bookmark) this.bookmark.lightOff();
			this.bookmark = bookmark;
			this.bookmark.lightOn();
		}
		
		private function show(type:String):void{
			var list:Vector.<String> = new Vector.<String>();
			switch(type){
				case Bookmark.ALL:
					break;
				
				case Bookmark.FRIENDS:
					var friends:Vector.<String>;// = new Vector.<String>();
					friends = super.context.owner.model.friends;
					
					if(friends){
						friends.push(super.context.owner.model.userID);
					}else{
						//this.show(Bookmark.ALL);
						return;
					}
					list = friends;
					break;
			}
			
			const bookmark:Bookmark = this.bookmarks[type] as Bookmark;
			this.select(bookmark);
			
			var loader:RaitingItemLoader = new RaitingItemLoader();
			loader.addEventListener(Event.COMPLETE, this.handleComplete);
			loader.loadItems(list);
		}
		
		private function handleComplete(event:Event):void{
			const loader:RaitingItemLoader = event.target as RaitingItemLoader;
			loader.removeEventListener(Event.COMPLETE, this.handleComplete);
			
			this.current = this.createItemsList();
			this.fill(loader.loadedItems, this.current);
			this.currentPage.value = 0;
			this.pagesNumber.value = this.current.total.value;
			
			this.itemsContainer.next();
		}
		
		private function handleRequestError(event:RemoteEvent):void{
//			trace(event.response.toXMLString())
		}
		
		private function fill(list:XMLList, container:ItemContainer):void{
			var menu_screen:MenuState = super.context.applicationStates.getState(ApplicationStateKey.MENU) as MenuState;
			var battle:Screen = super.context.applicationStates.getState(ApplicationStateKey.BATTLE) as Screen;
			
			for each(var item:XML in list){
				var id:String = item.@id;
				var r:RaitingItem = new RaitingItem(item);
				
				var command1:ICommand = new ShowAchievementsDialogCommand(id, menu_screen);
				var command2:ICommand = new AttackUserCommand(r, battle, super.context.opponent);
				
				var r2:RaitingItemView = new RaitingItemView(super.context, r, this.menu, new Invoker(command1), new Invoker(command2));
				container.addChild(r2);
			}
			
			if(this.bookmark.type == Bookmark.FRIENDS){
				var inv:InviteButton = new InviteButton();
				var con:InviteController = new InviteController(inv, new Invoker(new InviteCommand(super.context.config.inviteFunction)));
				container.addChild(inv);	
			}
		}
		
		private function handleNext(event:MouseEvent):void{
			trace(this.currentPage.value, this.pagesNumber.value)
			if(this.currentPage.value < this.current.total.value){
				this.currentPage.value ++;//increase();
//				this.current.currentPage ++;
				this.current.next();
			}
		}
		
		private function handlePrev(event:MouseEvent):void{
			if(this.currentPage.value > 0){
				this.currentPage.value --;//decrease();
//				this.current.currentPage --;
				this.current.prev();
			}
		}
	}
}
import caurina.transitions.Tweener;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;

internal class Bookmark extends EventDispatcher{
	public static const ALL:String = 'all';
	public static const FRIENDS:String = 'friends';
	
	private var clip:Sprite;
	private var baseCoord:Point;
	
	public var type:String;
	
	public function Bookmark(clip:Sprite, type:String){
		this.type = type;
		
		this.baseCoord = new Point(clip.x, clip.y);
		this.clip = clip;
		this.clip.addEventListener(MouseEvent.CLICK, this.handleBookmarkClick);
		this.clip.addEventListener(MouseEvent.CLICK, this.handleBookmarkClick);
		this.lightOff();
	}
	
	private function handleBookmarkClick(event:MouseEvent):void{
		const bookmark:Sprite = event.currentTarget as Sprite;
		const parent:DisplayObjectContainer = bookmark.parent;
		
		//parent.removeChild(bookmark);
		//parent.addChild(bookmark);
		
		this.lightOn();
		
		super.dispatchEvent(new Event('jaj'));
	}
	
	public function lightOff():void{
		this.animate(1, 2);
	}
	
	public function lightOn():void{
		this.animate(0, 0, 0);
	}
	
	private function animate(value:Number, value2:int, time:Number=0.5):void{
		const dis:Sprite = this.clip.getChildByName('disabled') as Sprite;
		var pos:int = this.baseCoord.y + value2;
		
		Tweener.removeTweens(dis);
		Tweener.addTween(dis, {alpha:value, time:time, transition:'easeOutSine'});
		
		//Tweener.removeTweens(this.clip);
		//Tweener.addTween(this.clip, {y:pos, time:time, transition:'easeOutSine'});
	}
}