package ru.gotoandstop.adi.dialogs{
	import flash.display.DisplayObject;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface IDialogContent{
		function setDialog(dialog:IDialog):void;
		function getLayout():DisplayObject;
	}
}