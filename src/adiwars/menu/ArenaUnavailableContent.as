package adiwars.menu{
	import adiwars.ITemp;
	import adiwars.clips.ArenaUnavailableDialogContent;
	import adiwars.dialogs.IDialog;
	import adiwars.dialogs.IDialogContent;
	import adiwars.informers.ShowButtonController;
	import adiwars.values.BooleanValue;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import ru.gotoandstop.utils.Convert;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ArenaUnavailableContent extends Sprite implements IDialogContent{
		private var field:TextField;
		private var timer:Timer;
		private var dialog:IDialog;
		private var btn:ITemp;
		private var show:BooleanValue;
		
		private var expirationDate:Date;
		
		public function ArenaUnavailableContent(time:uint){
			super();
			
			this.expirationDate = new Date();
			this.expirationDate.seconds += time;
			this.expirationDate.seconds += 1;
			
			var clip:ArenaUnavailableDialogContent = new ArenaUnavailableDialogContent();
			this.field = clip.time;
			super.addChild(clip);
			
			this.show = new BooleanValue();
			this.btn = new ShowButtonController(clip.toArenaButton, this.show);
			
			this.timer = new Timer(900);
			this.timer.addEventListener(TimerEvent.TIMER, this.handleTimer);
			this.timer.start();
			
			this.drawTime();
		}
		
		private function handleTimer(event:TimerEvent):void{
			var time:Date = this.getTime();
			
			var m:Boolean = Boolean(time.minutes);
			var s:Boolean = Boolean(time.seconds);
			
			this.drawTime(time);
			
			if(!m && !s){
				this.doThingsAfterTimer();
			}
		}
		
		private function drawTime(time:Date=null):void{
			if(!time) time = this.getTime();
			
			var m:uint = time.minutes;
			var mm:String = Convert.numberToString(m, 10, 2);
			
			var s:uint = time.seconds;
			var ss:String = Convert.numberToString(s, 10, 2);
			
			var text:String = 'mm:ss';
			text = text.replace(/mm/, mm);
			text = text.replace(/ss/, ss);
			
			this.field.text = text;
		}
		
		private function getTime():Date{
			var current:Date = new Date();
			var delay:uint = this.expirationDate.getTime() - current.getTime();
			var time:Date = new Date(delay);
			return time;
		}
		
		private function doThingsAfterTimer():void{
			this.timer.stop();
			this.timer.removeEventListener(TimerEvent.TIMER, this.handleTimer);
			
			this.btn.dispose();
			
			setTimeout(this.dialog.close, 500);
		}
		
		public function setDialog(dialog:IDialog):void{
			this.dialog = dialog;
		}
		
		public function getLayout():DisplayObject{
			return this;
		}
	}
}