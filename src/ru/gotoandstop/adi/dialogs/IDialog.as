package ru.gotoandstop.adi.dialogs{
	import flash.display.DisplayObject;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface IDialog{
		function get clip():DisplayObject;
		function close():void;
	}
}