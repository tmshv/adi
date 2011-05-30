package me.scriptor.platform.ui.window {
	import me.scriptor.platform.interfaces.IUIWindowView;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**
	 * @author Daniel Polsen (daniel.polsen at gmail.com)
	 * @playerversion Adobe Flashplayer 10 or higher
	 * @langversion Actionscript 3.0
	 */
	[Event(name="close", type="flash.events.Event")]
	public class WindowView extends Sprite implements IUIWindowView {
		/**
		 * Заголовок окна
		 */
		public var titlefield : TextField;
		/**
		 * Держатель контента
		 */
		public var content : Sprite;
		/**
		 * Задний фон (объект типа slice9Grid)
		 */
		public var background : Sprite;
		/**
		 * @private если <code>true</code>, значит окно создано
		 */
		private var isCreated : Boolean;
		/**
		 * Результат работы окна
		 */
		protected var resultObject : Object;

		public function WindowView(autoCreate : Boolean = true) {
			if(autoCreate) {
				create();
			}
		}

		/**
		 * создает все необходимое для работы окна окружение, если оно ранее не было создано
		 * @return void
		 * @see #dispose()
		 */
		public function create() : void {
			if(!this.isCreated) {
				createWindow();
				this.isCreated = true;
			}
		}

		/**
		 * удаляет все созданное ранее окружение
		 * @return void
		 * @see #create()
		 */
		public function dispose() : void {
			if(this.isCreated) {
				disposeWindow();
				this.isCreated = false;
			}
		}

		/**
		 * Устанавливает текст заголовка окна
		 * @param title текст заголовка окна
		 * @return void
		 */
		public function set title(title : String) : void {
			if(titlefield.htmlText == title)
				return;
			titlefield.multiline = false;
			titlefield.selectable = false;
			titlefield.htmlText = title;
		}

		/**
		 * Устанавливает каскадную таблицу стилей для заголовка окна
		 * @param css каскадная таблица стилей
		 * @return void
		 */
		public function set css(css : StyleSheet) : void {
			titlefield.styleSheet = css;
		}

		/**
		 * Возвращает экземпляр окна (визуальную его часть)
		 * @return визуал окна
		 */
		public function get instance() : DisplayObject {
			return this;
		}

		public function get result() : Object {
			return this.resultObject;
		}

		public function get type() : String {
			return "";
		}
		
		override public function get width() : Number {
			return this.background.width - 80;
		}
		
		override public function get height() : Number {
			return this.background.height - 70;
		}

		/**
		 * Вызывается при создании окна. Потомки в этом методе инициализируют все необходимые
		 * для их работы объекты
		 * @return void
		 * @see #create()
		 */
		protected function createWindow() : void {
			this.addEventListener(Event.ADDED_TO_STAGE, onActivationHandler);
			if(this.content) {
				this.content.addEventListener(Event.ADDED, onContentChangeHandler);
				this.content.addEventListener(Event.REMOVED, onContentChangeHandler);
			}
		}

		/**
		 * Вызывается при удалении окна. Потомки в этом методе реализуют очистку памяти
		 * от все созданых ими объектов
		 * @return void
		 * @see #dispose()
		 */
		protected function disposeWindow() : void {
			if(this.content) {
				this.content.removeEventListener(Event.ADDED, onContentChangeHandler);
				this.content.removeEventListener(Event.REMOVED, onContentChangeHandler);
			}
			if(this.parent) {
				this.parent.removeChild(this);
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, onActivationHandler);
		}

		/**
		 * Вызывается при активации окна (для проигрывания анимации и прочего интерактивного стаффа)
		 * @return void
		 * @see #deactivate()
		 */
		protected function activate() : void {
		}

		/**
		 * Вызывается при деактивации окна (для экономии процессорного времени)
		 * @return void
		 * @see #activate()
		 */
		protected function deactivate() : void {
		}

		/**
		 * Вызывается при изменении размеров окна
		 * @return void
		 */
		protected function onResize() : void {
		}
		
		protected function onResult() : void {
			dispatchEvent(new Event(Event.CLOSE));
		}

		// --		Handlers		--
		/**
		 * @eventType flash.events.Event.ADDED
		 * @private добавление ребенка в <code>display list</code>, объекта <code>content</code>
		 */
		private function onContentChangeHandler(event : Event) : void {
			var bounds : Rectangle = this.background.getBounds(this.background);
			var func : Function = event.type == Event.ADDED ? Math.max : Math.min;
			this.background.width = func.apply(this, [content.width + content.x * 2, bounds.width]);
			this.background.height = func.apply(this, [content.height + content.y * 2, bounds.height]);
			this.titlefield.width = this.background.width - 80;
			onResize();
		}

		/**
		 * @eventType flash.events.Event.ADDED_TO_STAGE
		 * @private добавление окна на сцену
		 */
		private function onActivationHandler(event : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onActivationHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onDeactivationHandler);
			activate();
		}

		/**
		 * @eventType flash.events.Event.REMOVED_FROM_STAGE
		 * @private удаление окна со сцены
		 */
		private function onDeactivationHandler(event : Event) : void {
			this.addEventListener(Event.ADDED_TO_STAGE, onActivationHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onDeactivationHandler);
			deactivate();
		}
	}
}
