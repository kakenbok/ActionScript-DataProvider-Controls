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
package com.sibirjak.asdpcbeta.window {
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import flash.events.Event;

	/**
	 * @author jes 25.11.2009
	 */
	public class WindowEvent extends Event {

		public static const START_DRAG : String = "window_startDrag";
		public static const STOP_DRAG : String = "window_stopDrag";

		public static const AUTO_MINIMISE_START : String = "window_auto_minimise_start";
		public static const MINIMISE_START : String = "window_minimise_start";
		public static const MINIMISED : String = "window_minimised";
		public static const RESTORE_START : String = "window_restore_start";
		public static const RESTORED : String = "window_restored";
		
		public var restorePosition : WindowPosition;
		
		public function WindowEvent(type : String) {
			super(type);
		}
	}
}
