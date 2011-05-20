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
	import org.as3commons.collections.framework.IDataProvider;

	/**
	 * ListDataProvider interface.
	 * 
	 * <p>The ListDataProvider adapts the hierachical tree data source and
	 * provides a sequential IDataProvider interface.</p> 
	 * 
	 * @author jes 25.01.2010
	 */
	public interface IListDataProvider extends IDataProvider {
		
		/**
		 * A custom data source adapter factory function.
		 */
		function get dataSourceAdapterFunction() : Function;
		
		/**
		 * The level of the root node. If _showRoot
		 * is set to false, the level is -1, else 0.
		 */
		function get rootLevel() : int;

		/**
		 * The max level of auto expanding.
		 */
		function get maxExpandAllLevel() : uint;

		/**
		 * Returns the tree node at the given list position.
		 * 
		 * @param listIndex The index of the node to get.
		 * @return The node at the given position or null if there is no node.
		 */
		function getNodeAt(listIndex : uint) : ITreeNode;

		/**
		 * Returns the list position of a given tree node.
		 * 
		 * @param node The node to get the list index for.
		 * @return The list position of the given node or -1 if the node is not contained.
		 */
		function getListIndexOf(node : ITreeNode) : int;

		/**
		 * Notifies the ListDataProvider after the showRoot property has been changed.
		 */
		function showRootChanged() : void;

		/**
		 * Notifies the ListDataProvider that a node has been expanded.
		 * 
		 * @param node The expanded node.
		 */
		function nodeExpanded(node : ITreeNode) : void;

		/**
		 * Notifies the ListDataProvider that a node has been collapsed.
		 * 
		 * @param node The collapsed node.
		 */
		function nodeCollapsed(node : ITreeNode) : void;

		/**
		 * Notifies the ListDataProvider that a node state has changed.
		 * 
		 * @param node The node whose state did change.
		 */
		function treeNodeStateChanged(node : ITreeNode) : void;
		
		/**
		 * Notifies the ListDataProvider that nodes have been added after a node.
		 * 
		 * @param parentNode The parent node of the node after that new nodes have been added.
		 * @param nodeBefore The node after that new nodes have been added.
		 * @param nodes An array of all added nodes.
		 */
		function nodesAddedAfter(parentNode : ITreeNode, nodeBefore : ITreeNode, nodes : Array) : void;
		
		/**
		 * Notifies the ListDataProvider that nodes have been removed after a node.
		 * 
		 * @param parentNode The parent node of the node after that the nodes have been removed.
		 * @param nodeBefore The node after that the nodes have been removed.
		 * @param nodes An array of all removed nodes.
		 */
		function nodesRemovedAfter(parentNode : ITreeNode, nodeBefore : ITreeNode, nodes : Array) : void;

		/**
		 * Notifies the ListDataProvider that the connection structure of a node
		 * has been changed.
		 * 
		 * @param node The node whose connection has changed.
		 * @param affectsChildren True, if also the node's children have a changed connection.
		 */
		function connectionChanged(node : ITreeNode, affectsChildren : Boolean) : void;

	}
}
