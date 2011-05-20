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
	import com.sibirjak.asdpc.core.asdpc_internal;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.treeview.core.ITreeNode;

	/**
	 * Plain data object representing tree node data and tree node state.
	 * 
	 * @author jes 12.01.2010
	 */
	public class TreeNodeData extends ListItemData {

		/**
		 * The tree node adapting the data source item.
		 */
		private var _treeNode : ITreeNode;

		/**
		 * True, if the node is expanded.
		 */
		public function get isExpanded() : Boolean {
			return _treeNode.isExpanded;
		}
		
		/*
		 * ListItemData properties
		 */

		/**
		 * @inheritDoc
		 */
		override public function get itemIndex() : uint {
			return _treeNode.itemIndex;
		}

		/**
		 * @inheritDoc
		 */
		override public function get parentItem() : * {
			if (_treeNode.parentNode) {
				return _treeNode.parentNode.dataSource;
			} else {
				return null;
			}
		}

		/*
		 * asdpc_internal
		 */

		/**
		 * Sets the tree node.
		 * 
		 * @param treeNode The tree node.
		 */
		asdpc_internal function setTreeNode_internal(treeNode : ITreeNode) : void {
			_treeNode = treeNode;
		}

		/**
		 * Returns the tree node.
		 */
		asdpc_internal function get treeNode_internal() : ITreeNode {
			return _treeNode;
		}

	}
}
