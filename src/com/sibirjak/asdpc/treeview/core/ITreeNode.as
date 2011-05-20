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
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;

	/**
	 * TreeNode public interface.
	 * 
	 * @author jes 19.10.2009
	 */
	public interface ITreeNode extends IIterable {

		/**
		 * The recursion depth of the node. Calculates
		 * its value by adding 1 to the each parent level.
		 * Returns _rootLevel, if no parent exists (root node).
		 */
		function get level() : int;
		
		/**
		 * True, if the node is the root node.
		 */
		function get isRoot() : Boolean;
		
		/**
		 * True, if the node contains children.
		 */
		function get isBranch() : Boolean;
		
		/**
		 * True, if the node has no previous sibling.
		 */
		function get isFirstItemInBranch() : Boolean

		/**
		 * True, if the node has no next sibling.
		 */
		function get isLastItemInBranch() : Boolean

		/**
		 * True, if the node contains children and is expanded.
		 */
		function get isExpanded() : Boolean;
		
		/**
		 * The parent node or null, if called for the root node.
		 */
		function get parentNode() : ITreeNode;

		/**
		 * The associated data source of the node.
		 */
		function get dataSource() : *;
		
		/**
		 * The index position of the item within its containing collection.
		 */
		function get itemIndex() : uint;

		/**
		 * The key with that the item was added to its IMap container.
		 */
		function get itemKey() : *;

		/**
		 * The current state of the node.
		 */
		function get treeNodeState() : String

		/**
		 * Sets a node to be always expanded. This is e.g. the root
		 * node if _showRoot is set to false.
		 */
		function set alwaysExpanded(alwaysExpanded : Boolean) : void

		/**
		 * Expands the node.
		 * 
		 * <p>If expandToLevel is set to -1, the node will be expanded
		 * up to the top most level.</p>
		 * 
		 * @param expandAll True, if the node should be expanded recursively.
		 * @param expandToLevel The maximum expand level if expandAll is set to true.
		 * @return True, if the node or any child node has been expanded.
		 */
		function expand(expandAll : Boolean = false, expandToLevel : int = -1) : Boolean;
		
		/**
		 * Collapses the node.
		 * 
		 * @param collapseAll True, if the node should be collapsed recursively.
		 * @return True, if the node or any child node has been collapsed.
		 */
		function collapse(collapseAll : Boolean = false) : Boolean;

		/**
		 * Returns a recursive iterator over all initialised children.
		 * 
		 * @return An iterator over all initialised child nodes.
		 */
		function getRecursiveIterator() : IIterator;

		/**
		 * Returns a recursive iterator over all child nodes, which
		 * are reachable following the parent.expanded property.
		 * 
		 * @return An iterator over all child nodes that should be visible in list.
		 */
		function getExpandedNodesRecursiveIterator() : IIterator;
		
		/**
		 * Cleans up all event listener references recursively.
		 */
		function cleanUp() : void;
		
	}
}
