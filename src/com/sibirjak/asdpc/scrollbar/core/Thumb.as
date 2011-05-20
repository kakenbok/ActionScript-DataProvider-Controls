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
package com.sibirjak.asdpc.scrollbar.core {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.constants.Direction;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * ScrollBar thumb.
	 * 
	 * @author jes 09.07.2009
	 */
	public class Thumb extends Button {
		
		/**
		 * Name constant defining the thumb scroll event.
		 */
		public static const EVENT_THUMB_SCROLL : String = "thumb_scroll";

		/*
		 * Properties
		 */

		/**
		 * Scrollbar direction.
		 */
		private var _direction : String;
		
		/**
		 * Minimal thumb position.
		 */
		private var _minPosition : uint;

		/**
		 * Maximal thumb position.
		 */
		private var _maxPosition : uint;
		
		/**
		 * Control variable in drag and drop.
		 */
		private var _diffPosition : Number;
		
		/**
		 * True, if the thumb is moving.
		 */
		private var _isMoving : Boolean = false;

		/**
		 * Thumb constructor.
		 */
		public function Thumb() {
		}
		
		/*
		 * Public
		 */
		
		/**
		 * Sets the scrollbar direction.
		 */
		public function set direction(direction : String) : void {
			_direction = direction;
		}

		/**
		 * Sets the minimal thumb position.
		 */
		public function set minPosition(minPosition : uint) : void {
			_minPosition = minPosition;
		}
		
		/**
		 * Sets the maximal thumb position.
		 */
		public function set maxPosition(maxPosition : uint) : void {
			_maxPosition = maxPosition;
		}

		/**
		 * @private
		 */
		public function set scroll(scroll : Number) : void {
			position = Math.round((_maxPosition - _minPosition) * scroll) + _minPosition;
		}

		/**
		 * Sets or returns the current scroll ratio.
		 * 
		 * <p>This is a value between 0 and 1.</p>
		 */
		public function get scroll() : Number {
			return (position - _minPosition) / (_maxPosition - _minPosition);
		}
		
		/**
		 * @private
		 */
		public function set position(position : uint) : void {
			if (_direction == Direction.HORIZONTAL) {
				x = position;
			} else {
				y = position;
			}
		}

		/**
		 * Sets or returns the current thumb position.
		 */
		public function get position() : uint {
			if (_direction == Direction.HORIZONTAL) {
				return x;
			} else {
				return y;
			}
		}

		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}

		/*
		 * Button protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function onMouseDown() : void {
			if (_direction == Direction.HORIZONTAL) {
				_diffPosition = parent.mouseX - x;
			} else {
				_diffPosition = parent.mouseY - y;
			}

			_isMoving = true;

			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onClick() : void {
			_isMoving = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onMouseUpOutside() : void {
			_isMoving = false;
		}

		/*
		 * Private
		 */
		
		/**
		 * Mouse move event handler.
		 */
		private function mouseMoveHandler(event : MouseEvent) : void {

			if (!_isMoving) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				return;
			}

			if (_direction == Direction.HORIZONTAL) {
				x = parent.mouseX - _diffPosition;
				x = Math.max(_minPosition, x);
				x = Math.min(_maxPosition, x);
			} else {
				y = parent.mouseY - _diffPosition;
				y = Math.max(_minPosition, y);
				y = Math.min(_maxPosition, y);
			}
			
			event.updateAfterEvent(); // update display soon

			dispatchEvent(new Event(EVENT_THUMB_SCROLL));
		}
		
	}
}
