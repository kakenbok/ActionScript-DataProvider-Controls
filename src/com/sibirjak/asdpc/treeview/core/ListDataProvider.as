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
	import com.sibirjak.asdpc.core.dataprovider.DataProviderEvent;
	import com.sibirjak.asdpc.core.dataprovider.Index;
	import com.sibirjak.asdpc.treeview.TreeView;

	import org.as3commons.collections.framework.IDataProvider;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.iterators.RecursiveFilterIterator;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	use namespace asdpc_internal;

	/**
	 * List data provider for hierarchical data.
	 * 
	 * @author jes 21.10.2009
	 */
	public class ListDataProvider extends Index implements IListDataProvider, IDataProvider, IEventDispatcher {

		/**
		 * TreeView reference.
		 */
		private var _treeView : TreeView;

		/**
		 * Root node.
		 */
		private var _rootNode : ITreeNode;

		/**
		 * Internal EventDispatcher instance.
		 */
		private var _eventDispatcher : IEventDispatcher;

		/**
		 * Root level property.
		 */
		private var _rootLevel : int = 0;
		
		/**
		 * ListDataProvider constructor.
		 * 
		 * @param treeView The owning treeView.
		 */
		public function ListDataProvider(treeView : TreeView) {
			
			_treeView = treeView;
			
			_rootNode = new TreeNode(
				this,
				null,
				_treeView.dataSource,
				-1
			);
			
			if (_treeView.showRoot) {
				addItemsAtStart([_rootNode]);
				
			} else {
				_rootLevel = -1;
				_rootNode.alwaysExpanded = true;
			}
			
			init(_rootNode.getExpandedNodesRecursiveIterator());
			
			_eventDispatcher = new EventDispatcher(this);

		}
		
		/*
		 * IDataProvider
		 */
		
		/**
		 * @inheritDoc
		 */
		override public function itemAt(index : uint) : * {
			var node : ITreeNode = super.itemAt(index);
			return node.dataSource;
		}
		
		/*
		 * IDataSourceAdapter
		 */

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			_rootNode.cleanUp();
		}

		/*
		 * ListDataProvider
		 */

		/**
		 * @inheritDoc
		 */
		public function showRootChanged() : void {
			if (_treeView.showRoot) {
				_rootLevel = 0;
				_rootNode.alwaysExpanded = false;

				addItemsAtStart([_rootNode]);
				dispatchEvent(new DataProviderEvent(
					DataProviderEvent.ITEM_ADDED,
					0,
					1
				));

			} else {
				// expand first
				_rootLevel = -1;
				_rootNode.alwaysExpanded = true;

				// then remove node
				removeItemsAtStart(1);
				dispatchEvent(new DataProviderEvent(
					DataProviderEvent.ITEM_REMOVED,
					0,
					1
				));

			}
		}

		/**
		 * @inheritDoc
		 */
		public function get rootLevel() : int {
			return _rootLevel;
		}

		/**
		 * @inheritDoc
		 */
		public function get dataSourceAdapterFunction() : Function {
			return _treeView.dataSourceAdapterFunction;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxExpandAllLevel() : uint {
			return _treeView.maxExpandAllLevel_internal;
		}

		/**
		 * @inheritDoc
		 */
		public function nodeExpanded(node : ITreeNode) : void {
			if (!hasItem(node)) return; // node not at display list
			
			var iterator : IIterator = node.getExpandedNodesRecursiveIterator();
			var nodesToAdd : Array = new Array();
			while (iterator.hasNext()) {
				nodesToAdd.push(iterator.next());
			}
			
			addItemsAfter(node, nodesToAdd);

			dispatchEvent(new DataProviderEvent(
				DataProviderEvent.ITEM_ADDED,
				indexOf(node) + 1,
				nodesToAdd.length
			));
		}

		/**
		 * @inheritDoc
		 */
		public function nodeCollapsed(node : ITreeNode) : void {
			if (!hasItem(node)) return; // node not at display list
			
			var numNodesToRemove : uint = 0;
			var iterator : IIterator = getVisibleNodesRecursiveIterator(node);
			while (iterator.next()) numNodesToRemove++;
			
			removeItemsAfter(node, numNodesToRemove);

			dispatchEvent(new DataProviderEvent(
				DataProviderEvent.ITEM_REMOVED,
				indexOf(node) + 1,
				numNodesToRemove
			));
		}

		/**
		 * @inheritDoc
		 */
		public function nodesAddedAfter(parentNode : ITreeNode, nodeBefore : ITreeNode, nodes : Array) : void {
			
			if (nodeBefore) { // removed as a later child of the parent
				if (!hasItem(nodeBefore)) return; // not visible in list
				// get the last visible childNode
				iterator = getVisibleNodesRecursiveIterator(nodeBefore);
				while (iterator.hasNext()) nodeBefore = iterator.next();
			} else { // added as the first child of the parent
				if (parentNode != _rootNode && !hasItem(parentNode)) return; // not visible in list
				if (!parentNode.isExpanded) return; // not expanded
				
				nodeBefore = (!_treeView.showRoot && parentNode == _rootNode) ? null : parentNode;
			}
			
			var nodesToAdd : Array = new Array();
			var node : ITreeNode;
			var iterator : IIterator;
			for (var i : uint = 0; i < nodes.length; i++) {
				node = nodes[i];
				nodesToAdd.push(node);
				
				iterator = node.getExpandedNodesRecursiveIterator();
				while (iterator.hasNext()) {
					nodesToAdd.push(iterator.next());
				}
			}

			addItemsAfter(nodeBefore, nodesToAdd);

			dispatchEvent(new DataProviderEvent(
				DataProviderEvent.ITEM_ADDED,
				indexOf(nodeBefore) + 1,
				nodesToAdd.length
			));
		}

		/**
		 * @inheritDoc
		 */
		public function nodesRemovedAfter(parentNode : ITreeNode, nodeBefore : ITreeNode, nodes : Array) : void {
			
			var iterator : IIterator;

			if (nodeBefore) { // removed as a later child of the parent
				if (!hasItem(nodeBefore)) return; // nodeBefore not in list -> nodes to remove not in list
				// get the last visible childNode
				iterator = getVisibleNodesRecursiveIterator(nodeBefore);
				while (iterator.hasNext()) nodeBefore = iterator.next();
			} else { // removed as the first child of the parent
				if (parentNode != _rootNode && !hasItem(parentNode)) return; // not visible in list
				if (!parentNode.isExpanded) return; // not expanded
				
				nodeBefore = (!_treeView.showRoot && parentNode == _rootNode) ? null : parentNode;
			}
			
			var numNodesToRemove : uint = 0;
			var node : ITreeNode;
			for (var i : uint = 0; i < nodes.length; i++) {
				node = nodes[i];
				numNodesToRemove++;

				iterator = getVisibleNodesRecursiveIterator(node);
				while (iterator.next()) numNodesToRemove++;
			}

			removeItemsAfter(nodeBefore, numNodesToRemove);
			
			dispatchEvent(new DataProviderEvent(
				DataProviderEvent.ITEM_REMOVED,
				indexOf(nodeBefore) + 1,
				numNodesToRemove
			));
		}
		
		/**
		 * @inheritDoc
		 */
		public function treeNodeStateChanged(node : ITreeNode) : void {
			if (!hasItem(node)) return; // node not at display list
			_treeView.notifyRendererForTreeNodeStateChange_internal(indexOf(node));
		}

		/**
		 * @inheritDoc
		 */
		public function connectionChanged(node : ITreeNode, affectsChildren : Boolean) : void {
			if (!hasItem(node)) return; // node not at display list
			_treeView.notifyRendererForConnectionChange_internal(indexOf(node));
			
			if (!affectsChildren) return;

			var iterator : IIterator = getVisibleNodesRecursiveIterator(node);
			while (iterator.hasNext()) {
				node = iterator.next();

				_treeView.notifyRendererForConnectionChange_internal(indexOf(node));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getNodeAt(listIndex : uint) : ITreeNode {
			return super.itemAt(listIndex);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getListIndexOf(node : ITreeNode) : int {
			return super.indexOf(node);
		}
		
		/*
		 * IEventDispatcher
		 */
		
		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event : Event) : Boolean {
			return _eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type : String) : Boolean {
			return _eventDispatcher.hasEventListener(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type : String) : Boolean {
			return _eventDispatcher.willTrigger(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/*
		 * Test internface
		 */

		internal function get rootNode() : ITreeNode {
			return _rootNode;
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		public function toString() : String {
			return "[ListDataProvider]";
		}
			

		/*
		 * Private
		 */

		/**
		 * Returns a recursive iterator over all child nodes of a node
		 * who are currently stored in the internal visible nodes list.
		 */
		private function getVisibleNodesRecursiveIterator(node : ITreeNode) : IIterator {
			var filter : Function = function(node : TreeNode) : Boolean {
				return indexOf(node) > -1;
			};
			return new RecursiveFilterIterator(node, filter, filter);
		}
		
	}
}
