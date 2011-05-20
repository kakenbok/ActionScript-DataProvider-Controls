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
	 * TextInput event.
	 * 
	 * @author jes 05.11.2009
	 */
	public class TextInputEvent extends Event {
		
		/**
		 * Event type FOCUS_IN
		 * 
		 * <p>Dispatched, if the user focuses the text input.</p>
		 */
		public static const FOCUS_IN : String = "textInput_focusIn";

		/**
		 * Event type FOCUS_OUT
		 * 
		 * <p>Dispatched, if the text input has lost the focus.</p>
		 */
		public static const FOCUS_OUT : String = "textInput_focusOut";

		/**
		 * Event type CHANGED
		 * 
		 * <p>Dispatched, after the text of the inner text field has changed.</p>
		 */
		public static const CHANGED : String = "textInput_changed";

		/**
		 * Event type CANCEL.
		 * 
		 * <p>Dispatched, if the user has pressed the ESC key.</p>
		 */
		public static const CANCEL : String = "textInput_cancel";

		/**
		 * Event type SUBMIT.
		 * 
		 * <p>Dispatched, if the user has pressed the ENTER key.</p>
		 */
		public static const SUBMIT : String = "textInput_submit";
		
		/**
		 * TextInputEvent constructor.
		 * 
		 * @param type The event type.
		 */
		public function TextInputEvent(type : String) {
			super(type);
		}

	}
}
