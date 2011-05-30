package me.scriptor.platform.interfaces {
	import flash.text.StyleSheet;

	/**
	 * 
	 * @author Daniel Polsen (daniel.polsen at gmail.com)
	 * @playerversion Adobe Flashplayer 10 or higher
	 * @langversion Actionscript 3.0
	 */
	public interface IUIWindowView extends IView {
		function set title(title : String) : void;

		function set css(css : StyleSheet) : void;

		function get result() : Object;
	}
}
