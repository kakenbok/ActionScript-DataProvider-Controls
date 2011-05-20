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
package com.sibirjak.asdpc.button {
	import flash.events.Event;

	/**
	 * Button event.
	 * 
	 * @author jes 14.07.2009
	 */
	public class ButtonEvent extends Event {

		/**
		 * Event type ROLL_OVER
		 * 
		 * @eventType button_rollOver
		 */
		public static const ROLL_OVER : String = "button_rollOver";

		/**
		 * Event type ROLL_OUT
		 * 
		 * @eventType button_rollOut
		 */
		public static const ROLL_OUT : String = "button_rollOut";

		/**
		 * Event type MOUSE_DOWN
		 * 
		 * @eventType button_mouseDown
		 */
		public static const MOUSE_DOWN : String = "button_mouseDown";

		/**
		 * Event type CLICK
		 * 
		 * @eventType button_click
		 */
		public static const CLICK : String = "button_click";

		/**
		 * Event type MOUSE_UP_OUTSIDE
		 * 
		 * @eventType button_mouseUpOutside
		 */
		public static const MOUSE_UP_OUTSIDE : String = "button_mouseUpOutside";

		/**
		 * Event type SELECTION_CHANGED
		 * 
		 * @eventType button_selectionChanged
		 */
		public static const SELECTION_CHANGED : String = "button_selectionChanged";

		/**
		 * ButtonEvent constructor.
		 * 
		 * @param type The event type.
		 */
		public function ButtonEvent(type : String) {
			super(type);
		}
		
	}
}
