﻿package me.scriptor.platform.ui.menu {	import caurina.transitions.Tweener;	import caurina.transitions.properties.FilterShortcuts;	import flash.display.Sprite;	import flash.events.MouseEvent;	/**	 * 	 * @author Daniel Polsen (daniel.polsen at gmail.com)	 * @playerversion Adobe Flashplayer 10 or higher	 * @langversion Actionscript 3.0	 */	public class MainMenu extends Sprite {		/**		 * Магазин		 */		public var shop : Sprite;		/**		 * Банк		 */		public var bank : Sprite;		/**		 * Арена		 */		public var arena : Sprite;		public function MainMenu() {					}		public function initialize() : void {			FilterShortcuts.init();			enableButton(shop);			enableButton(bank);			enableButton(arena);		}		private function enableButton(button : Sprite) : void {			if(button) {				if(!button.buttonMode) {					button.buttonMode = true;					button.addEventListener(MouseEvent.MOUSE_OVER, onButtonRolloverHandler);					button.addEventListener(MouseEvent.MOUSE_OUT, onButtonRolloutHandler);					button.addEventListener(MouseEvent.CLICK, onButtonRleaseHandler);				}			}		}		private function glow(button : Sprite, amount : int = 0) : void {			trace(button)			Tweener.removeTweens(button);			Tweener.addTween(button, {_Glow_blurX:amount * 10, _Glow_blurY:amount * 10, _Glow_strength:amount * 5, time:.5});		}		// --		Handlers		--		/**		 * @eventType flash.events.MouseEvent.MOUSE_OVER		 * @private наведение мыши на объект меню		 */		private function onButtonRolloverHandler(event : MouseEvent) : void {			var button : Sprite = Sprite(event.currentTarget);			glow(button, 1);		}		/**		 * @eventType flash.events.MouseEvent.MOUSE_OUT		 * @private увод мыши с объекта меню		 */		private function onButtonRolloutHandler(event : MouseEvent) : void {			var button : Sprite = Sprite(event.currentTarget);			glow(button);		}		/**		 * @eventType flash.events.MouseEvent.CLICK		 * @private клик мыши на объекте меню		 */		private function onButtonRleaseHandler(event : MouseEvent) : void {		}	}}