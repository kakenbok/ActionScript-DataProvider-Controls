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
package com.sibirjak.asdpc.common.interfacedemo.windows.events {

	/**
	 * @author jes 19.11.2009
	 */
	public class EventItem {
		
		public static const TYPE_LIST_VIEW : String = "listView";
		public static const TYPE_LIST_ITEM : String = "listItem";
		
		public var type : String;
		public var label : String;
		public var color : uint;
		public var bold : Boolean;
		
		private var _listItemEventColor : uint = 0x666666;
		private var _listViewEventColor : uint = 0x000000;

		public function EventItem(theType : String, theLabel : String) {
			type = theType;
			label = theLabel;
			color = type == TYPE_LIST_VIEW ? _listViewEventColor : _listItemEventColor;
			bold = type == TYPE_LIST_VIEW ? true : false;
		}
		
	}
}
