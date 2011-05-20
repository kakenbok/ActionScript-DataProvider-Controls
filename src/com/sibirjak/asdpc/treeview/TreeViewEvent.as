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
package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.listview.ListViewEvent;

	/**
	 * TreeView event.
	 * 
	 * @author jes 13.01.2010
	 */
	public class TreeViewEvent extends ListViewEvent {

		/**
		 * @copy com.sibirjak.asdpc.listview.ListViewEvent#ITEM_ADDED
		 */
		public static const ITEM_ADDED : String = ListViewEvent.ITEM_ADDED;

		/**
		 * @copy com.sibirjak.asdpc.listview.ListViewEvent#ITEM_REMOVED
		 */
		public static const ITEM_REMOVED : String = ListViewEvent.ITEM_REMOVED;

		/**
		 * @copy com.sibirjak.asdpc.listview.ListViewEvent#DATA_RESET
		 */
		public static const DATA_RESET : String = ListViewEvent.DATA_RESET;

		/**
		 * @copy com.sibirjak.asdpc.listview.ListViewEvent#SELECTION_CHANGED
		 */
		public static const SELECTION_CHANGED : String = ListViewEvent.SELECTION_CHANGED;

		/**
		 * @copy com.sibirjak.asdpc.listview.ListViewEvent#SCROLL
		 */
		public static const SCROLL : String = ListViewEvent.SCROLL;

		/**
		 * @copy com.sibirjak.asdpc.listview.ListViewEvent#REFRESH
		 */
		public static const REFRESH : String = ListViewEvent.REFRESH;

		/**
		 * Event type EXPANDED
		 * 
		 * <p>Dispatched after a node has been expanded, both manually or programmatically.</p>
		 * 
		 * @eventType treeView_expanded
		 */
		public static const EXPANDED : String = "treeView_expanded";

		/**
		 * Event type COLLAPSED
		 * 
		 * <p>Dispatched after a node has been collapsed, both manually or programmatically.</p>
		 * 
		 * @eventType treeView_collapsed
		 */
		public static const COLLAPSED : String = "treeView_collapsed";
		
		/**
		 * Indicates, if a node has been recursively expanded.
		 * 
		 * <p>This property is set only for the events EXPANDED, COLLAPSED</p>
		 */
		public var expandAll : Boolean;

		/**
		 * Indicates, if a node has been recursively collapsed.
		 * 
		 * <p>This property is set only for the events EXPANDED, COLLAPSED</p>
		 */
		public var collapseAll : Boolean;

		/**
		 * TreeViewEvent constructor.
		 * 
		 * @param type The event type.
		 */
		public function TreeViewEvent(type : String) {
			super(type);
		}
		
	}
}
