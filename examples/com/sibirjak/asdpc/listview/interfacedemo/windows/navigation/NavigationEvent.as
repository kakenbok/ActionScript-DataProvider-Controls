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
package com.sibirjak.asdpc.listview.interfacedemo.windows.navigation {
	import flash.events.Event;

	/**
	 * @author jes 06.01.2010
	 */
	public class NavigationEvent extends Event {
		
		public static const SELECT : String = "select";
		public static const DESELECT : String = "deselect";
		public static const SCROLL : String = "scroll";
		
		public static const EXPAND : String = "expand";
		public static const EXPAND_ALL : String = "expand_all";
		public static const COLLAPSE : String = "collapse";
		public static const COLLAPSE_ALL : String = "collapse_all";

		public var listIndex : uint;
		
		public function NavigationEvent(type : String, theListIndex : uint) {
			super(type, true);
			
			listIndex = theListIndex;
		}
	}
}
