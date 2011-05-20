/**
 * ActionScript Data Provider Controls
 * 
 * Copyright (c) 2010 Jens Struwe, http://www.sibirjak.com/
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.sibirjak.asdpcbeta.slider.core {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	import com.sibirjak.asdpc.button.Button;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jes 09.07.2009
	 */
	public class SliderThumb extends Button {
		
		public static const EVENT_THUMB_MOVE : String = "sliderThumb_move";
		public static const EVENT_THUMB_RELEASED : String = "sliderThumb_release";

		/*
		 * Properties
		 */

		private var _diffPosition : Point;
		private var _isMoving : Boolean = false;
		private var _boundaryRect : Rectangle;
		private var _tween : GTween;

		/*
		 * Constructor
		 */

		public function SliderThumb() {
			_tween = new GTween(this, .2);
			_tween.ease = Sine.easeInOut;
			_tween.onComplete = function (tween : GTween) : void {
				dispatchEvent(new Event(EVENT_THUMB_MOVE));
				dispatchEvent(new Event(EVENT_THUMB_RELEASED));
			};
			_tween.paused = true;
		}
		
		/*
		 * Public
		 */
		
		public function set boundaryRect(boundaryRect : Rectangle) : void {
			_boundaryRect = boundaryRect;
		}

		public function get boundaryRect() : Rectangle {
			return _boundaryRect;
		}

		public function set position(position : Point) : void {
			x = position.x;
			y = position.y;
		}
		
		public function tweenToPosition(position : Point) : void {
			_tween.setValue("x", position.x);
			_tween.setValue("y", position.y);
		}

		/*
		 * View life cycle
		 */

		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}		

		/*
		 * Protected template methods
		 */

		override protected function onMouseDown() : void {
			_diffPosition = new Point(parent.mouseX - x, parent.mouseY - y);

			_isMoving = true;

			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		override protected function onClick() : void {
			_isMoving = false;
			dispatchEvent(new Event(EVENT_THUMB_RELEASED));
		}
		
		override protected function onMouseUpOutside() : void {
			_isMoving = false;
			dispatchEvent(new Event(EVENT_THUMB_RELEASED));
		}

		/*
		 * Private
		 */
		
		private function mouseMoveHandler(event : MouseEvent) : void {

			if (!_isMoving) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				return;
			}

			x = Math.round(parent.mouseX - _diffPosition.x);
			y = Math.round(parent.mouseY - _diffPosition.y);
			
			var position : Point = minMaxPosition(new Point(x, y));
			x = position.x;
			y = position.y;
			
			event.updateAfterEvent(); // update display soon

			dispatchEvent(new Event(EVENT_THUMB_MOVE));
		}
		
		private function minMaxPosition(point : Point) : Point {
			
			point.x = Math.max(_boundaryRect.x, point.x);
			point.x = Math.min(_boundaryRect.width, point.x);
			
			point.y = Math.max(_boundaryRect.y, point.y);
			point.y = Math.min(_boundaryRect.height, point.y);

			return point;
		}
		
	}
}
