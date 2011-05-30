package adiwars.raiting{
	import adiwars.command.ICommand;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InviteCommand implements ICommand{
		private var fuuuuuu:Function;
		
		public function InviteCommand(scareFunction:Function){
			this.fuuuuuu = scareFunction;
		}
		
		public function execute():void{
			this.fuuuuuu();
		}
	}
}