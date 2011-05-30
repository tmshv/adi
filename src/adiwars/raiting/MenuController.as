package adiwars.raiting{
	import adiwars.ITemp;
	import adiwars.RaitingItemMenuClip;
	import adiwars.clips.RaitingItemClip;
	import adiwars.command.Invoker;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class MenuController implements ITemp{
		private var clip:RaitingItemMenuClip;
		
		private var c1:Invoker;
		private var c2:Invoker;
		
		private var showID:uint;
		private var startShowTime:uint;
		
		public function MenuController(clip:RaitingItemMenuClip){
			this.clip = clip;
			this.hide();
			
			this.clip.achievements.addEventListener(MouseEvent.CLICK, this.handleAchievements);
			this.clip.attack.addEventListener(MouseEvent.CLICK, this.handleAttack);
		}
		
		public function dispose():void{
			this.clip.achievements.removeEventListener(MouseEvent.CLICK, this.handleAchievements);
			this.clip.attack.removeEventListener(MouseEvent.CLICK, this.handleAttack);
		}
		
		public function show(coords:Point, command:Invoker, command2:Invoker):void{
			//this.clip.alpha = 1;
			this.clip.visible = true;
			
			this.clip.x = coords.x;
			//this.clip.y = coords.y;
			
			//this.
			
			//this.startShowTime = getTimer();
			
			
			this.c1 = command;
			this.c2 = command2;
		}
		
		public function hide():void{
			//this.clip.alpha = 0;
			this.clip.visible = false;
		}
		
		private function handleAchievements(event:MouseEvent):void{
			this.c1.executeCommand();
		}
		
		private function handleAttack(event:MouseEvent):void{
			this.c2.executeCommand();
		}
	}
}