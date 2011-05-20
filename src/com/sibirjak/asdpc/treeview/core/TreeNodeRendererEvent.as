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
package com.sibirjak.asdpc.treeview.core {
	import com.sibirjak.asdpc.listview.core.ListItemRendererEvent;

	/**
	 * TreeNodeRenderer event.
	 * 
	 * @author jes 13.01.2010
	 */
	public class TreeNodeRendererEvent extends ListItemRendererEvent {

		/**
		 * @copy com.sibirjak.asdpc.listview.core.ListItemRendererEvent#ROLL_OVER
		 */
		public static const ROLL_OVER : String = ListItemRendererEvent.ROLL_OVER;

		/**
		 * @copy com.sibirjak.asdpc.listview.core.ListItemRendererEvent#ROLL_OUT
		 */
		public static const ROLL_OUT : String = ListItemRendererEvent.ROLL_OUT;

		/**
		 * @copy com.sibirjak.asdpc.listview.core.ListItemRendererEvent#SELECTION_CHANGED
		 */
		public static const SELECTION_CHANGED : String = ListItemRendererEvent.SELECTION_CHANGED;
		
		/**
		 * @copy com.sibirjak.asdpc.listview.core.ListItemRendererEvent#DATA_CHANGED
		 */
		public static const DATA_CHANGED : String = ListItemRendererEvent.DATA_CHANGED;

		/**
		 * @copy com.sibirjak.asdpc.listview.core.ListItemRendererEvent#DATA_PROPERTY_CHANGED
		 */
		public static const DATA_PROPERTY_CHANGED : String = ListItemRendererEvent.DATA_PROPERTY_CHANGED;

		/**
		 * @copy com.sibirjak.asdpc.listview.core.ListItemRendererEvent#LIST_INDEX_CHANGED
		 */
		public static const LIST_INDEX_CHANGED : String = ListItemRendererEvent.LIST_INDEX_CHANGED;

		/**
		 * Event type CONNECTION_CHANGED
		 * 
		 * <p>Dispatched, if connection of a node has changed and should be refreshed.</p>
		 * 
		 * @eventType treeNodeRenderer_connectionChanged
		 */
		public static const CONNECTION_CHANGED : String = "treeNodeRenderer_connectionChanged";

		/**
		 * Event type LEVEL_CHANGED
		 * 
		 * <p>Dispatched, if the level of the item has changed. This is the case, if treeView.showRoot
		 * is toggled and all visible renderers should reflect this change by a reposition of its contents.</p>
		 * 
		 * @eventType treeNodeRenderer_levelChanged
		 */
		public static const LEVEL_CHANGED : String = "treeNodeRenderer_levelChanged";

		/**
		 * Event type TREE_NODE_STATE_CHANGED
		 * 
		 * <p>Dispatched, if the node state changed (leaf, open branch, closed branch).</p>
		 * 
		 * @eventType treeNodeRenderer_stateChanged
		 */
		public static const TREE_NODE_STATE_CHANGED : String = "treeNodeRenderer_stateChanged";

		/**
		 * Event type EXPANDED
		 * 
		 * <p>Dispatched, if the item has been expanded.</p>
		 * 
		 * @eventType treeNodeRenderer_expanded
		 */
		public static const EXPANDED : String = "treeNodeRenderer_expanded";

		/**
		 * Event type COLLAPSED
		 * 
		 * <p>Dispatched, if the item has been collapsed.</p>
		 * 
		 * @eventType treeNodeRenderer_collapsed
		 */
		public static const COLLAPSED : String = "treeNodeRenderer_collapsed";

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
		 * TreeNodeRendererEvent constructor.
		 * 
		 * @param type The event type.
		 */
		public function TreeNodeRendererEvent(type : String) {
			super(type);
		}
	}
}
