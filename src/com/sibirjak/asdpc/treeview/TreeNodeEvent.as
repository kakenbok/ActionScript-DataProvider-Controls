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
	import com.sibirjak.asdpc.listview.ListItemEvent;

	/**
	 * TreeNode event.
	 * 
	 * <p>This event is dispatched by the treeView in response to user
	 * interactivity.</p>
	 * 
	 * @author jes 13.01.2010
	 */
	public class TreeNodeEvent extends ListItemEvent {

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemEvent#ROLL_OVER
		 */
		public static const ROLL_OVER : String = ListItemEvent.ROLL_OVER;

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemEvent#ROLL_OUT
		 */
		public static const ROLL_OUT : String = ListItemEvent.ROLL_OUT;

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemEvent#CLICK
		 */
		public static const CLICK : String = ListItemEvent.CLICK;

		/**
		 * @copy com.sibirjak.asdpc.listview.ListItemEvent#SELECTION_CHANGED
		 */
		public static const SELECTION_CHANGED : String = ListItemEvent.SELECTION_CHANGED;

		/**
		 * Event type EXPANDED
		 * 
		 * <p>Dispatched, after the user has expanded a node.</p>
		 * 
		 * @eventType treeNode_expanded
		 */
		public static const EXPANDED : String = "treeNode_expanded";

		/**
		 * Event type COLLAPSED
		 * 
		 * <p>Dispatched, after the user has collapsed a node.</p>
		 * 
		 * @eventType treeNode_collapsed
		 */
		public static const COLLAPSED : String = "treeNode_collapsed";
		
		/**
		 * Indicates, if the node has been recursively expanded.
		 * 
		 * <p>This property is set only for the events EXPANDED, COLLAPSED</p>
		 */
		public var expandAll : Boolean;

		/**
		 * Indicates, if the node has been recursively collapsed.
		 * 
		 * <p>This property is set only for the events EXPANDED, COLLAPSED</p>
		 */
		public var collapseAll : Boolean;
		
		/**
		 * TreeNodeRendererEvent constructor.
		 * 
		 * @param type The event type.
		 */
		public function TreeNodeEvent(type : String, data : TreeNodeData) {
			super(type, data);
		}

		/**
		 * True, if the node is expanded.
		 */
		public function get isExpanded() : Boolean {
			return TreeNodeData(_data).isExpanded;
		}

	}
}
