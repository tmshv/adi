package adiwars.ui{
	import adiwars.values.IntValue;
	import adiwars.values.IntValue2;
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Контейнер айтемов, умеет слайдить на указанное расстояние вверх-вниз, вправо-влево
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ItemContainer extends Sprite{
		/**
		 * Вертикальный/горизонтальный лейаут (и анимация) 
		 */
		private var isH:Boolean;
		
		private var rows:uint;
		private var columns:uint;
		private var cellNumber:uint;
		
		private var slideOffset:int;
		
		public var saved:int;
		
		private var offset:Point;
		
		/**
		 * Используемая при слайде анимация 
		 */
		private var tween:String;
		
		public var total:IntValue;
		public var current:IntValue;
		
		private var multy:uint;
		
		/**
		 * По всей видимости придется убрать этот функционал 
		 */
		private var removePreviousOnTweenComplete:Boolean;
		
		public function ItemContainer(rows:uint, columns:uint, removePreviousOnTweenComplete:Boolean=false){
			super();
			this.rows = rows;
			this.columns = columns;
			this.cellNumber = rows * columns;
			this.removePreviousOnTweenComplete = removePreviousOnTweenComplete;
			
			this.current = new IntValue();
			this.total = new IntValue();
		}
		
		public function save():void{
			this.saved = this.current.value;
		}
		
		public function upChild(child:DisplayObject):void{
			var upper:DisplayObject = super.getChildAt(super.numChildren-1);			
			super.swapChildren(child, upper);
		}
		
		/**
		 * Устаанвливает параметры, для визуальных всяких шняг 
		 * @param layout
		 * @param slideOffset
		 * @param offset
		 * @param tween
		 * 
		 */
		public function setLayout(layout:String, slideOffset:int, offset:Point, tween:String):void{
			this.isH = layout == 'horizontal';
			this.slideOffset = slideOffset;
			this.offset = offset;
			this.tween = tween;
		}
		
		public override function addChild(child:DisplayObject):DisplayObject{
			var pos:Point = this.cellIndex(super.numChildren);
			pos.x *= this.offset.x;
			pos.y *= this.offset.y;
			
			child.x = pos.x;
			child.y = pos.y;
			
			var pn:uint = Math.max(this.total.value, (super.numChildren / this.cellNumber));
			this.total.value = pn;//this.pagesNumber);
			return super.addChild(child);
		}
		
		/**
		 * Проскролить вперед 
		 */
		public function next():void{
			this.multy --;
			this.current.value ++;
			this.slide();
		}
		
		/**
		 * Проскрлить назад
		 */
		public function prev():void{
			this.multy ++;
			this.current.value --;
			this.slide();
		}
		
		/**
		 * Выполнить анимацию
		 */
		private function slide():void{
			var position:Point = this.isH ? new Point(this.calcCoord(), super.y) : new Point(super.x, this.calcCoord());
			Tweener.addTween(this, {x:position.x, y:position.y, time:0.5, transition:tween, onComplete:this.onTweenComplete});
		}
		
		private function onTweenComplete():void{
			if(this.removePreviousOnTweenComplete){
				
			}
		}
		
		private function cellIndex(index:uint):Point{
			var length:uint = this.isH ? this.rows : this.columns;
			
			var r:uint = Math.floor(index / length);
			var c:uint = index - (r * length);
			
			if(this.isH) return new Point(r, c);
			else return new Point(c, r);
		}
		
		private function calcCoord():int{
			var offset:Number = this.isH ? this.offset.x : this.offset.y;
			return (this.multy * slideOffset);
		}
	}
}