package ru.gotoandstop.adi.command{
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface IMacroCommand extends ICommand{
		function addCommand(command:ICommand):ICommand;
		function removeCommandAt(index:uint):void;
		function getCommandIndex(command:ICommand):int;
	}
}