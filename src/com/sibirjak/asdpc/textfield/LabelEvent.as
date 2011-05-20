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
package com.sibirjak.asdpc.textfield {
	import flash.events.Event;

	/**
	 * Label event.
	 * 
	 * @author jes 24.11.2009
	 */
	public class LabelEvent extends Event {

		/**
		 * Event type INNER_SIZE_CHANGED
		 * 
		 * <p>Dispatched, if the size of the inner text field has changed.</p>
		 */
		public static const INNER_SIZE_CHANGED : String = "label_sizeChanged";
		
		/**
		 * True, if the text has been chopped in order to fit the label boundaries.
		 */
		public var chopped : Boolean;

		/**
		 * LabelEvent constructor.
		 * 
		 * @param type The event type.
		 */
		public function LabelEvent(type : String) {
			super(type);
		}
	}
}
