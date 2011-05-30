package ru.gotoandstop.adi.ui{
	import ru.gotoandstop.adi.command.ICommand;
	
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SlideContainerCommand implements ICommand{
		private var method:Function;
		
		public function SlideContainerCommand(receiver:ItemContainer, moveNext:Boolean=true){
			this.method = moveNext ? receiver.next : receiver.prev;
		}
		
		public function execute():void{
			this.method();
		}
	}
}