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
	import com.sibirjak.asdpc.core.dataprovider.DataSourceAdapterFactory;
	import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;
	import com.sibirjak.asdpc.core.dataprovider.IMapAdapter;
	import com.sibirjak.asdpc.treeview.constants.TreeNodeState;

	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IDataProvider;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.iterators.RecursiveFilterIterator;
	import org.as3commons.collections.iterators.RecursiveIterator;

	import flash.events.IEventDispatcher;
	
	use namespace asdpc_internal;

	/**
	 * TreeNode
	 * 
	 * @author jes 20.10.2009
	 */
	public class TreeNode extends ArrayList implements ITreeNode {
		
		/**
		 * Reference to the treeView list data provider.
		 */
		private var _listDataProvider : IListDataProvider;

		/**
		 * Adapter to the nodes data source.
		 */
		private var _dataSourceAdapter : IDataProvider;

		/**
		 * Parent node reference.
		 */
		private var _parentNode : TreeNode;

		/**
		 * Flag to indicate that children of a node should be ignored
		 * due to a recursion.
		 */
		private var _skipChildren : Boolean;

		/**
		 * Position of the item in parent nodes data source.
		 */
		private var _itemIndex : int;

		/**
		 * Flag, indicates, if a node cannot be collapsed.
		 * 
		 * <p>This can be only the root node if _showRoot is set to false.</p>
		 */
		private var _alwaysExpanded : Boolean;

		/**
		 * Expanded flag.
		 */
		private var _isExpanded : Boolean;

		/**
		 * Children initialised flag.
		 */
		private var _childrenInitialised : Boolean = false;

		/**
		 * TreeNode constructor.
		 * 
		 * @param listDataProvider The treeView's list data provider.
		 * @param parentNode The parent node.
		 * @param dataSource The data item of the node.
		 * @param dataSourceIndex The position of the item within the parent node's data source.
		 */
		public function TreeNode(
			listDataProvider : IListDataProvider,
			parentNode : TreeNode,
			dataSource : *,
			dataSourceIndex : int
		) {
			_listDataProvider = listDataProvider;
			_parentNode = parentNode;
			_itemIndex = dataSourceIndex;
			
			// test if the node is a child of itself
			var parent : ITreeNode = parentNode;
			while (parent) {
				if (parent.dataSource == dataSource) {
					_skipChildren = true;
					return;
				}
				parent = parent.parentNode;
			}
			
			_dataSourceAdapter = DataSourceAdapterFactory.getAdapter(dataSource, listDataProvider.dataSourceAdapterFunction);

			if (_dataSourceAdapter is IEventDispatcher) {
				IEventDispatcher(_dataSourceAdapter).addEventListener(
					DataProviderEvent.DATA_PROVIDER_CHANGED, dataProviderChangedHandler
				);
			}

		}
		
		/*
		 * ITreeNode
		 */

		/**
		 * @inheritDoc
		 */
		public function get dataSource() : * {
			if (_dataSourceAdapter is IDataSourceAdapter) {
				return IDataSourceAdapter(_dataSourceAdapter).dataSource;
			}
			
			return _dataSourceAdapter;
		}

		/**
		 * @inheritDoc
		 */
		public function get parentNode() : ITreeNode {
			return _parentNode;
		}

		/**
		 * @inheritDoc
		 */
		public function get treeNodeState() : String {
			if (isBranch) {
				if (_isExpanded) {
					return TreeNodeState.BRANCH_OPEN;
				} else {
					return TreeNodeState.BRANCH_CLOSED;
				}
			} else {
				return TreeNodeState.LEAF;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isRoot() : Boolean {
			return _parentNode == null;
		}

		/**
		 * @inheritDoc
		 */
		public function get isBranch() : Boolean {
			return !_skipChildren && _dataSourceAdapter.size;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isFirstItemInBranch() : Boolean {
			if (_parentNode) {
				return _parentNode.first == this;
			} else {
				return true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get isLastItemInBranch() : Boolean {
			if (_parentNode) {
				return _parentNode.last == this;
			} else {
				return true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get level() : int {
			return _parentNode ? _parentNode.level + 1 : _listDataProvider.rootLevel;
		}

		/**
		 * @inheritDoc
		 */
		public function get isExpanded() : Boolean {
			return _isExpanded;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get itemIndex() : uint {
			return _itemIndex;
		}

		/**
		 * @inheritDoc
		 */
		public function get itemKey() : * {
			if (_parentNode) {
				if (_parentNode._dataSourceAdapter is IMapAdapter) {
					return IMapAdapter(_parentNode._dataSourceAdapter).getKeyAt(_itemIndex);
				}
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function set alwaysExpanded(alwaysExpanded : Boolean) : void {
			_alwaysExpanded = alwaysExpanded;

			if (_alwaysExpanded) {
				expand();
			}
		}
			
		/**
		 * @inheritDoc
		 */
		public function expand(expandAll : Boolean = false, expandToLevel : int = -1) : Boolean {
			
			// Never expand leaf nodes.
			if (!isBranch) return false;
			
			// calculate max expand all level
			if (expandAll) {
				if (expandToLevel == -1) expandToLevel = _listDataProvider.maxExpandAllLevel;
				if (!expandToLevel) return false;
			}
			
			// Already expanded.
			if (_isExpanded) {
				
				// not not expand if max level is reached
				if (expandAll) {
					
					var nodeExpanded : Boolean;
					var hasExpandedNode : Boolean;
					
					var node : TreeNode;
					var iterator : IIterator = iterator();
					while (iterator.hasNext()) {
						node = iterator.next();
						nodeExpanded = node.expand(true, expandToLevel - 1);
						if (nodeExpanded) hasExpandedNode = true;
					}
					
					return hasExpandedNode;
				}
				
				return false;

			}

			/*
			 * Mark all items to be expanded.
			 * Initialise items if not yet done.
			 */
			
			if (expandAll) {
				initAndExpandAllChildrenRecursively(expandToLevel);
				
			} else {
				if (!_childrenInitialised) {
					initChildren();
				}
			}
			
			_isExpanded = true;

			/*
			 * Add now visible items to the list.
			 * Notify expansion change.
			 */
			
			_listDataProvider.nodeExpanded(this);
			_listDataProvider.treeNodeStateChanged(this);
			
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function collapse(collapseAll : Boolean = false) : Boolean {
			// Cannot be collapsed
			if (_alwaysExpanded) return false;
			
			// Never collaps leaf nodes.
			if (!isBranch) return false;

			// Already collapsed.
			if (!_isExpanded && !collapseAll) return false;

			/*
			 * Mark all items to be collapsed after we have calculated
			 * the number of items to remove from the list.
			 */

			if (collapseAll) {
				var hasSomethingCollapsed : Boolean;
				var node : TreeNode;
				var iterator : IIterator = getRecursiveIterator();
				while (iterator.hasNext()) {
					node = iterator.next();
					if (node.isExpanded) {
						node._isExpanded = false;
						hasSomethingCollapsed = true;
					}
				}
				
				// if an already collapsed node has been collapsed recursively,
				// we do not have any list change and can stop here.
				if (!_isExpanded) {
					return hasSomethingCollapsed;
				}
			}

			_isExpanded = false;

			/*
			 * Remove formerly visible children from the list.
			 * Notify expansion change.
			 */

			_listDataProvider.nodeCollapsed(this);
			_listDataProvider.treeNodeStateChanged(this);
			
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRecursiveIterator() : IIterator {
			return new RecursiveIterator(this);
		}

		/**
		 * @inheritDoc
		 */
		public function getExpandedNodesRecursiveIterator() : IIterator {
			var filter : Function = function(node : TreeNode) : Boolean {
				return node.isExpanded;
			};
			return new RecursiveFilterIterator(this, null, filter);
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		public function toString() : String {
			return "[TreeNode] itemIndex:" + _itemIndex + " src:" + dataSource;
		}
		
		/*
		 * Private
		 */
		
		/**
		 * Cleans up all event listener references recursively.
		 */
		public function cleanUp() : void {
			// Clean up children.
			cleanUpChildren();
			
			// Clean up node.
			// We dont have a data source adapter if the node is a child
			// of itself
			if (_dataSourceAdapter) {
				if (_dataSourceAdapter is IEventDispatcher) {
					IEventDispatcher(_dataSourceAdapter).removeEventListener(
						DataProviderEvent.DATA_PROVIDER_CHANGED,
						dataProviderChangedHandler
					);
				}
				if (_dataSourceAdapter is IDataSourceAdapter) {
					IDataSourceAdapter(_dataSourceAdapter).cleanUp();
				}
			}
		}

		/**
		 * Cleans up all child items recursively.
		 */
		private function cleanUpChildren() : void {
			var node : TreeNode;
			var iterator : IIterator = iterator();
			while (iterator.hasNext()) {
				node = iterator.next();
				node.cleanUp();
			}
		}

		/**
		 * Initialises all direct children.
		 */
		private function initChildren() : void {
			if (_skipChildren) return;
			
			var node : TreeNode;
			for (var i : uint = 0; i < _dataSourceAdapter.size; i++) {
				node = new TreeNode(
					_listDataProvider,
					this,
					_dataSourceAdapter.itemAt(i),
					i
				);
				add(node);
			}
			_childrenInitialised = true;
		}

		/**
		 * Initialises and expands all children recursively.
		 */
		private function initAndExpandAllChildrenRecursively(expandToLevel : uint) : void {
			if (_skipChildren) return;
			
			var node : TreeNode;
			if (_childrenInitialised) {
				// if 1 then simply return since the node should be only marked as expanded
				// without further processing children.
				if (expandToLevel < 2) return;
				
				var iterator : IIterator = iterator();
				while (iterator.hasNext()) {
					node = iterator.next();
					if (node.isBranch) node._isExpanded = true;
					node.initAndExpandAllChildrenRecursively(expandToLevel - 1);
				}
			} else {
				if (!expandToLevel) return;
			
				initChildren();
				initAndExpandAllChildrenRecursively(expandToLevel);
			}
		}

		/**
		 * Handles changes of the data source.
		 */
		private function dataProviderChangedHandler(event : DataProviderEvent) : void {
			
			var node : TreeNode;
			var i : uint;
			var listNodeBefore : TreeNode;
			
			switch (event.kind) {

				case DataProviderEvent.ITEM_ADDED:
				
					/*
					 * Add new child trees if children already have
					 * been initialised.
					 */

					if (_childrenInitialised) {
						
						/*
						 * Create and add children to the adapter tree.
						 * Update data source index.
						 */ 
	
						var listNodesToAdd : Array = new Array();
						
						for (i = event.index; i < event.index + event.numItems; i++) {
							node = new TreeNode(
								_listDataProvider,
								this,
								_dataSourceAdapter.itemAt(i),
								i
							);
							addAt(i, node);

							listNodesToAdd.push(node);
						}
	
						for (i = event.index + event.numItems; i < size; i++) {
							node = itemAt(i);
							node._itemIndex += event.numItems;
						}
						
						/*
						 * Add visible items
						 */

						if (event.index > 0) {
							listNodeBefore = itemAt(event.index - 1);
						}

						_listDataProvider.nodesAddedAfter(this, listNodeBefore, listNodesToAdd);
						
						/*
						 * Update connections
						 */

						// Update predecessors connections, if added to the end.
						
						if (event.index > 0 && event.index == size - 1) {
							node = itemAt(event.index - 1);
							_listDataProvider.connectionChanged(node, true);
						}

						// Update successors connection if added to the very top of the tree.
						// level == -1 is true, if _showRoot = false and this == rootNode

						if (level == -1 && event.index == 0 && event.numItems < _dataSourceAdapter.size) {
							node = itemAt(event.numItems);
							_listDataProvider.connectionChanged(node, false);
						}

					}

					/*
					 * Check for a directory icon change.
					 * Adding an item to a visible but collapsed node
					 * changes directory icon from leaf to branch.
					 */

					if (_dataSourceAdapter.size == event.numItems) { 
						_listDataProvider.treeNodeStateChanged(this);
					}

					break;

				case DataProviderEvent.ITEM_REMOVED:
				
					if (_childrenInitialised) {
						
						/*
						 * Cleanup and remove affected tree items and their children
						 * if children already have been initialised.
						 * Update data source index of succeeding items.
						 */

						for (i = event.index; i < event.index + event.numItems; i++) {
							node = itemAt(i);
							node.cleanUp();
						}

						var listNodesToRemove : Array = removeAllAt(event.index, event.numItems);
						
						for (i = event.index; i < size; i++) {
							node = itemAt(i);
							node._itemIndex -= event.numItems;
						}

						/*
						 * Remove visible items
						 */

						if (event.index > 0) {
							listNodeBefore = itemAt(event.index - 1);
						}

						_listDataProvider.nodesRemovedAfter(this, listNodeBefore, listNodesToRemove);
						
						/*
						 * Update connections
						 */

						// Update predecessors connections, if removed from the end.

						if (event.index > 0 && event.index == size) {
							node = itemAt(event.index - 1);
							_listDataProvider.connectionChanged(node, true);
						}

						// Update successors connections, if removed at the very top of the tree.
						// level == -1 is true, if _showRoot = false and this == rootNode

						if (level == -1 && event.index == 0) {
							node = itemAt(0);
							_listDataProvider.connectionChanged(node, false);
						}

					}

					/*
					 * Mark to be collapsed and update icon,
					 * if the item has become a leaf node.
					 */
					 
					if (!_dataSourceAdapter.size) {
						if (!_alwaysExpanded && _isExpanded) _isExpanded = false;
						_listDataProvider.treeNodeStateChanged(this);
					}
					
					break;

				case DataProviderEvent.RESET:
				
					if (_childrenInitialised) {

						/*
						 * Clean up and remove children.
						 */

						cleanUpChildren();
						
						listNodesToRemove = toArray();

						clear();
						
						_listDataProvider.nodesRemovedAfter(this, null, listNodesToRemove);

						/*
						 * Reinitialise children.
						 */

						if (_dataSourceAdapter.size) {
						
							initChildren();
	
							_listDataProvider.nodesAddedAfter(this, null, toArray());
						}

					}

					/*
					 * Mark to be collapsed and update icon,
					 * if the item has become a leaf node.
					 */
					 
					if (!_dataSourceAdapter.size) {
						if (!_alwaysExpanded && _isExpanded) _isExpanded = false;
						_listDataProvider.treeNodeStateChanged(this);
					}

					break;

			}
		}
		
	}
}
