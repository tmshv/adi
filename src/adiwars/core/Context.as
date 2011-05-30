package adiwars.core{
	import adiwars.GoodsItem;
	import adiwars.UndefinedIcon;
	import adiwars.dialogs.Dialog;
	import adiwars.dialogs.DialogManager;
	import adiwars.states.ScreenSlider;
	import adiwars.user.Goods;
	import adiwars.user.Owner;
	import adiwars.user.OwnerModel;
	import adiwars.user.UserModel;
	import adiwars.user.items.AdiwarsLibrary;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import me.scriptor.platform.interfaces.IView;
	
	import ru.gotoandstop.resources.Resource;
	import ru.gotoandstop.resources.ResourceLibrary;
	
	/**
	 * Базовый класс контекста приложения
	 * @author Timashev Roman
	 */
	public class Context{
		public static var inst:Context;
		
		public static function create(lib:ResourceLibrary, stateContainer:Sprite, dialogContainer:Sprite):Context{
			var context:Context = new Context();
			context._lib = lib;
			context.adiwarsLibrary = new AdiwarsLibrary(lib);
			context._stateManager = new ScreenSlider(stateContainer, 700);
			context._dialogManager = new DialogManager(dialogContainer, null);
			context.opponent = new UserModel(context);
			Context.inst = context;
			
			return context;
		}
		
		public var config:Config;
		private var adiwarsLibrary:AdiwarsLibrary;
		
		private var _lib:ResourceLibrary;
		public function get library():ResourceLibrary{
			return this._lib;
		}
		
		private var _stateManager:ScreenSlider;
		public function get applicationStates():ScreenSlider{
			return this._stateManager;
		}
		
		private var _dialogManager:DialogManager;
		public function get dialogManager():DialogManager{
			return this._dialogManager;
		}
		
		public var opponent:UserModel;
		public var owner:Owner;
		
		private var _configXML:XML;
		public function get configXML():XML{
			return this._configXML;
		}
		public function setConfiguration(config:XML):void{
			this._configXML = config;
			
			var items:XMLList = config..item;
			for each(var i:XML in items){
				if(this.goods.isGoodies(i.@type)){
					this.goods.addItem(i);
				}
			}
			this.setDefaultSuite();
		}
		
		private function setDefaultSuite():void{
			var items:Vector.<GoodsItem> = this.goods.getList();
			var used:Object = new Object();
			
			for each(var item:GoodsItem in items){
				var suite_type:String = item.name.substr(0, 1);
				if(used[suite_type]) continue;
				else{
					this.owner.suite.add(item);
					used[suite_type] = item;
				}
			}
		}
		
		private var goods:Goods;		
		public function getGoodsItem(name:String):GoodsItem{
			return this.goods.getItem(name);
		}
		public function getGoodiesList():Vector.<GoodsItem>{
			return this.goods.getList();
		}
		
		public function Context(){
			this.goods = new Goods();
		}
		
		public function getResourceClip(clipClass:String):DisplayObject{
			return this.adiwarsLibrary.getResourceClip(clipClass);
		}
		
		public function getRemoteImage(url:String):DisplayObject{
			if(this.adiwarsLibrary){
				return this.adiwarsLibrary.getRemoteImage(url);
			}else{
				return new UndefinedIcon();
			}
		}
	}
}