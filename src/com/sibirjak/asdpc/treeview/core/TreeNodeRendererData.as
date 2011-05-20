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
	import com.sibirjak.asdpc.core.asdpc_internal;
	import com.sibirjak.asdpc.listview.core.ListItemRendererData;
	import com.sibirjak.asdpc.treeview.TreeNodeData;
	import com.sibirjak.asdpc.treeview.TreeView;
	
	use namespace asdpc_internal;

	/**
	 * Data object passed to a ITreeNodeRenderer and representing the item to render.
	 * 
	 * @author jes 27.07.2009
	 */
	public class TreeNodeRendererData extends ListItemRendererData {

		/*
		 * TreeNodeRenderer properties
		 */
		
		/**
		 * @copy ITreeNode#level
		 */
		public function get level() : int {
			return _treeNode.level;
		}

		/**
		 * @copy ITreeNode#treeNodeState
		 */
		public function get treeNodeState() : String {
			return _treeNode.treeNodeState;
		}

		/**
		 * @copy ITreeNode#isRoot
		 */
		public function get isRoot() : Boolean {
			return _treeNode.isRoot;
		}

		/**
		 * @copy ITreeNode#isFirstItemInBranch
		 */
		public function get isFirstItemInBranch() : Boolean {
			return _treeNode.isFirstItemInBranch;
		}

		/**
		 * @copy ITreeNode#isLastItemInBranch
		 */
		public function get isLastItemInBranch() : Boolean {
			return _treeNode.isLastItemInBranch;
		}

		/**
		 * The renderer data for the parent treenode.
		 */
		public function get parentTreeNodeRendererData() : TreeNodeRendererData {
			if (_treeNode.parentNode) {
				return _treeView.createTreeNodeRendererData_internal(_treeNode.parentNode) as TreeNodeRendererData;
			} else {
				return null;
			}
		}
		
		/*
		 * TreeNodeRenderer operations
		 */

		/**
		 * Notifies the treeView, that the item is to expand.
		 * 
		 * @param expandAll True, if the item should be recursively expanded.
		 */
		public function expand(expandAll : Boolean = false) : void {
			_treeView.expandNodeAt_internal(listIndex, expandAll);
		}
		
		/**
		 * Notifies the treeView, that the item is to collapse.
		 * 
		 * @param expandAll True, if the item should be recursively collapsed.
		 */
		public function collapse(collapseAll : Boolean = false) : void {
			_treeView.collapseNodeAt_internal(listIndex, collapseAll);
		}

		/*
		 * Private
		 */

		/**
		 * Casts the protected _listView into a TreeView.
		 */
		private function get _treeView() : TreeView {
			return _listView as TreeView;
		}

		/**
		 * Shortcut to the treeNode property of the internal TreeNodeData instance.
		 */
		private function get _treeNode() : ITreeNode {
			return TreeNodeData(_listItemData).treeNode_internal;
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		override public function toString() : String {
			return ("[TreeNodeRendererData] " + item);
		}
		
	}
}
