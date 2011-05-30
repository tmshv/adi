package adiwars.battle{
	import adiwars.character.BattleCharModel;
	import adiwars.character.CharDefinition;
	import adiwars.clips.BattleBackground;
	import adiwars.clips.BattleScreen;
	import adiwars.clips.BattleUserInfo;
	import adiwars.informers.BattleInformer;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ru.gotoandstop.math.Calculate;
	
	/**
	 *
	 * @author Timashev Roman
	 */
	public class BattleStateView extends Sprite{
		private var clip:BattleScreen;
		public var informer:BattleInformer;
		
		public function get charsContainer():Sprite{
			return this.clip.point;
		}
		
		public function BattleStateView(){
			super();
			this.clip = new BattleScreen();
			super.addChild(this.clip);
			this.informer = new BattleInformer(this.clip.informer);
		}
		
		public function refreshBackground():void{
			var b:MovieClip = this.clip.background;
			b.gotoAndStop(Calculate.random(1, b.totalFrames, true));
		}
		
		public function clear():void{
			while(this.charsContainer.numChildren) this.charsContainer.removeChildAt(0);
		}
		
		public function get userEmmiter():DisplayObjectContainer{
			return this.clip.userBubbleSource;
		}
		
		public function get enemyEmmiter():DisplayObjectContainer{
			return this.clip.enemyBubbleSource;
		}
	}
}