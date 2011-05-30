package ru.gotoandstop.adi.command{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class MacroCommand implements IMacroCommand{
		private var commands:Vector.<ICommand>;
		private var current:uint;
		
		private var isWorking:Boolean;
		
		public function MacroCommand(){
			super();
			this.commands = new Vector.<ICommand>();
		}
		
		public function addCommand(command:ICommand):ICommand{
			this.commands.push(command);
			return command;
		}
		
		public function removeCommandAt(index:uint):void{
			this.commands.splice(index, 1);
		}
		
		public function getCommandIndex(command:ICommand):int{
			return this.commands.indexOf(command);
		}
		
		public function execute():void{
			if(this.isWorking) return;
			
			this.isWorking = true;
			this.current = 0;
			this.executeNext();
		}
		
		private function executeNext():void{
			var complete_executing:Boolean = (this.current >= this.commands.length);
			if(complete_executing){
				this.isWorking = false;
			}else{
				var command:ICommand = this.commands[this.current];
				if(command){
					if(command is IAsyncCommand) this.executeAsync(command as IAsyncCommand);
					else{
						command.execute();
						this.doAfterExecuting();
					}
				}else{
					this.isWorking = false;
				}
			}
		}
		
		private function doAfterExecuting():void{
			this.current ++;
			this.executeNext();			
		}
		
		private function executeAsync(command:IAsyncCommand):void{
			command.addEventListener(Event.COMPLETE, this.handleComplete);
			command.execute();
		}
		
		private function handleComplete(event:Event):void{
			const command:IAsyncCommand = event.target as IAsyncCommand;
			command.removeEventListener(Event.COMPLETE, this.handleComplete);
			this.doAfterExecuting();
		}
	}
}