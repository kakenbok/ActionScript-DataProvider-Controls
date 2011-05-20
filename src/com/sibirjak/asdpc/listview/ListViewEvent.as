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
package com.sibirjak.asdpc.listview {
	import flash.events.Event;

	/**
	 * ListView event.
	 * 
	 * @author jes 13.08.2009
	 */
	public class ListViewEvent extends Event {

		/**
		 * Event type ITEM_ADDED
		 * 
		 * <p>Dispatched if items have been added to the list.</p>
		 * 
		 * @eventType listView_itemAdded
		 */
		public static const ITEM_ADDED : String = "listView_itemAdded";

		/**
		 * Event type ITEM_REMOVED
		 * 
		 * <p>Dispatched if items have been removed from the list.</p>
		 * 
		 * @eventType listView_itemRemoved
		 */
		public static const ITEM_REMOVED : String = "listView_itemRemoved";

		/**
		 * Event type DATA_RESET
		 * 
		 * <p>Dispatched after the list data source has been changed drastically.
		 * This is the case, if the data source has been changed drastically
		 * (not to handle by singular add or remove operations) or a new data
		 * source has been set.</p>
		 * 
		 * @eventType listView_dataReset
		 */
		public static const DATA_RESET : String = "listView_dataReset";

		/**
		 * Event type SELECTION_CHANGED
		 * 
		 * <p>Dispatched if an item has been selected or deselected, both manually
		 * or programmatically.</p>
		 * 
		 * @eventType listView_selectionChanged
		 */
		public static const SELECTION_CHANGED : String = "listView_selectionChanged";

		/**
		 * Event type SCROLL
		 * 
		 * <p>Dispatched if the user scrolls the list by mouse. The new first visible index
		 * can be obtained via listView.firstVisibleIndex. Programmatic scrolling can be watched
		 * listening to REFRESH.</p>
		 * 
		 * @eventType listView_scroll
		 */
		public static const SCROLL : String = "listView_scroll";

		/**
		 * Event type REFRESH
		 * 
		 * <p>Dispatched every time the list is refreshed. The list is always refreshed,
		 * if items have been added or removed or the scroll position changes or the list
		 * or list item dimensions change. This event can be used to track the scroll
		 * position of the list, if changed programmatically.</p>
		 * 
		 * @eventType listView_refresh
		 */
		public static const REFRESH : String = "listView_refresh";

		/**
		 * The list index of a insertion or removal operation.
		 * 
		 * <p>Only set for the events ITEM_ADDED, ITEM_REMOVED.</p>
		 */
		public var listIndex : int = -1;

		/**
		 * The number of items removed or added.
		 * 
		 * <p>Only set for the events ITEM_ADDED, ITEM_REMOVED.</p>
		 */
		public var numItems : uint;
		
		/**
		 * ListViewEvent constructor.
		 * 
		 * @param type The event type.
		 */
		public function ListViewEvent(type : String) {
			super(type);
		}
		
	}
}
