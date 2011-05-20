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
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.core.ListItemRendererData;
	import com.sibirjak.asdpc.treeview.core.IListDataProvider;
	import com.sibirjak.asdpc.treeview.core.ITreeNode;
	import com.sibirjak.asdpc.treeview.core.ITreeNodeRenderer;
	import com.sibirjak.asdpc.treeview.core.ListDataProvider;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererData;
	import com.sibirjak.asdpc.treeview.core.TreeNodeRendererEvent;
	import com.sibirjak.asdpc.treeview.renderer.TreeNodeRenderer;

	import org.as3commons.collections.framework.IDataProvider;
	
	use namespace asdpc_internal;

	/*
	 * Styles 
	 */
	
	/**
	 * @copy TreeViewStyles#showRoot
	 */
	[Style(name="treeView_showRoot", type="Boolean")]

	/**
	 * @copy TreeViewStyles#maxExpandAllLevel
	 */
	[Style(name="treeView_maxExpandAllLevel", type="uint", def="12")]

	/*
	 * TreeViewEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.treeview.TreeViewEvent.EXPANDED
	 */
	[Event(name="treeView_expanded", type="com.sibirjak.asdpc.treeview.TreeViewEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.treeview.TreeViewEvent.COLLAPSED
	 */
	[Event(name="treeView_collapsed", type="com.sibirjak.asdpc.treeview.TreeViewEvent")]

	/*
	 * TreeNodeEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.treeview.TreeNodeEvent.EXPANDED
	 */
	[Event(name="treeNode_expanded", type="com.sibirjak.asdpc.treeview.TreeNodeEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.treeview.TreeNodeEvent.COLLAPSED
	 */
	[Event(name="treeNode_collapsed", type="com.sibirjak.asdpc.treeview.TreeNodeEvent")]

	/**
	 * TreeView component.
	 * 
	 * @author jes 27.07.2009
	 */
	public class TreeView extends ListView implements ITreeView {
		
		/* style declarations */

		/**
		 * Central accessor to all TreeView style property definitions.
		 */
		public static var style : TreeViewStyles = new TreeViewStyles();

		/* internals */

		/**
		 * Cache for the nodes that should be expanded after the TreeView has been drawn.
		 */
		private var _nodesToExpand : Array;
		
		/* styles */

		/**
		 * Flag indicates, if the root node should be shown.
		 */
		private var _showRoot : Boolean;

		/**
		 * Max expand level for a recursive expanding.
		 */
		private var _maxExpandAllLevel : uint;
				
		/**
		 * TreeView constructor.
		 */
		public function TreeView() {
			
			setDefaultSize(300, 360);
			
			setDefaultStyles([
				style.showRoot, true,
				style.maxExpandAllLevel, 8
			]);
			
			_nodesToExpand = new Array();
		}
		
		/*
		 * ITreeView
		 */
		
		/**
		 * @inheritDoc
		 */
		public function expandNodeAt(listIndex : uint, expandAll : Boolean = false) : void {
			if (!_initialised) {
				_nodesToExpand.push([listIndex, expandAll]);
				return;
			}
			
			// wrong index
			if (listIndex >= listDataProvider.size) return;
			
			expandNodeAt_private(listIndex, expandAll, false, false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function collapseNodeAt(listIndex : uint, collapseAll : Boolean = false) : void {
			if (!_initialised) return;

			// wrong index
			if (listIndex >= listDataProvider.size) return;
			
			collapseNodeAt_private(listIndex, collapseAll, false, false);
		}

		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			_showRoot = getStyle(style.showRoot);
			_maxExpandAllLevel = getStyle(style.maxExpandAllLevel);

			super.init();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initialised() : void {
			for (var i : uint = 0; i < _nodesToExpand.length; i++) {
				expandNodeAt(_nodesToExpand[i][0], _nodesToExpand[i][1]);
			}
			_nodesToExpand = null;
			
			super.initialised(); // selects item
		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			
			if (property.indexOf("treeView_") == 0) {
				
				if (property == style.showRoot) {
					_showRoot = value;
					listDataProvider.showRootChanged();

					applyToRenderers(function(renderer : ITreeNodeRenderer) : void {
						renderer.dispatchEvent(createListItemRendererEvent(
							TreeNodeRendererEvent.LEVEL_CHANGED
						));
					});
					
					scrollToItemAt(0);
				}

				if (property == style.maxExpandAllLevel) {
					_maxExpandAllLevel = value;
				}

			} else {
				super.styleChanged(property, value);

			}
			
		}

		/*
		 * asdpc_internal
		 */
		
		/**
		 * Expands a node.
		 * 
		 * @param listIndex The list index of the node to expand.
		 * @param expandAll Flag, indicates if the node is recursively to expand.
		 */
		asdpc_internal function expandNodeAt_internal(listIndex : uint, expandAll : Boolean = false) : void {
			// renderer might be removed beforehand
			if (!getRendererAt(listIndex)) return;

			expandNodeAt_private(listIndex, expandAll, true, true);
		}

		/**
		 * Collapses a node.
		 * 
		 * @param listIndex The list index of the node to collaps.
		 * @param collapseAll Flag, indicates if the node is recursively to collaps.
		 */
		asdpc_internal function collapseNodeAt_internal(listIndex : uint, collapseAll : Boolean = false) : void {
			// renderer might be removed beforehand
			if (!getRendererAt(listIndex)) return;

			collapseNodeAt_private(listIndex, collapseAll, true, true);
		}

		/**
		 * Creates a TreeNodeRendererData for a given TreeNode.
		 * 
		 * @param treeNode The node to create the data for.
		 */
		asdpc_internal function createTreeNodeRendererData_internal(treeNode : ITreeNode) : ListItemRendererData {
			var listIndex : int = listDataProvider.getListIndexOf(treeNode);
			if (listIndex > -1) return createListItemRendererData(listIndex);
			else return null;
		}

		/**
		 * Notifies the renderer at the given position about a node state change.
		 * 
		 * <p>If the state changes due to a expand or collaps operation, we wish the
		 * renderer to immediate reflect the changes.</p>
		 * 
		 * @param listIndex The position of the node in the list.
		 */
		asdpc_internal function notifyRendererForTreeNodeStateChange_internal(listIndex : uint) : void {
			var renderer : ITreeNodeRenderer = getRendererAt(listIndex) as ITreeNodeRenderer;
			if (renderer) { // currently visible in list
				renderer.dispatchEvent(createListItemRendererEvent(
					TreeNodeRendererEvent.TREE_NODE_STATE_CHANGED
				));
			}
		}
			
		/**
		 * Notifies the renderer at the given position about a connection change.
		 * 
		 * <p>This method is called by the ListDataProvider after items have been added
		 * or removed. The node at the given position or one of its ancestors either:</p>
		 * 
		 * <ul>
		 * <li>Has been the last node of a branch and is it not any longer.</li>
		 * <li>Or has been not the last node of a branch and is it now.</li>
		 * </ul>
		 * 
		 * <p>In both cases the affected node and all of its children have to
		 * show new connections.</p>
		 * 
		 * <p>It is not necessary to perform an immediate validation.</p>
		 * 
		 * @param listIndex The position of the node in the list.
		 */
		asdpc_internal function notifyRendererForConnectionChange_internal(listIndex : uint) : void {
			var renderer : ITreeNodeRenderer = getRendererAt(listIndex) as ITreeNodeRenderer;
			if (renderer) { // currently visible in list
				renderer.dispatchEvent(createListItemRendererEvent(
					TreeNodeRendererEvent.CONNECTION_CHANGED
				));
			}
		}
		
		/**
		 * The max expand level in a recursive expansion.
		 */
		asdpc_internal function get maxExpandAllLevel_internal() : uint {
			return _maxExpandAllLevel;
		}

		/**
		 * True, if the root node is visible.
		 */
		asdpc_internal function get showRoot() : Boolean {
			return _showRoot;
		}

		/*
		 * ListView protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function createNewDataSourceAdapter() : IDataProvider {
			return new ListDataProvider(this);
		}

		/**
		 * @inheritDoc
		 */
		override protected function getParentItem(listIndex : uint) : * {
			var node : ITreeNode = listDataProvider.getNodeAt(listIndex);
			return node.level ? node.parentNode.dataSource : null;
		}

		/**
		 * @inheritDoc
		 */
		override protected function getItemIndex(listIndex : uint) : * {
			var node : ITreeNode = listDataProvider.getNodeAt(listIndex);
			return node.itemIndex;
		}

		/**
		 * @inheritDoc
		 */
		override protected function getItemKey(listIndex : uint) : * {
			var node : ITreeNode = listDataProvider.getNodeAt(listIndex);
			return node.itemKey;
		}

		/*
		 * ListViewEvent
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function getListViewEventClass() : Class {
			return TreeViewEvent;
		}

		/*
		 * ListItemEvent
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function getListItemEventClass() : Class {
			return TreeNodeEvent;
		}

		/*
		 * ListItemRendererEvent
		 */

		/**
		 * @inheritDoc
		 */
		override protected function getListItemRendererEventClass() : Class {
			return TreeNodeRendererEvent;
		}

		/*
		 * ListItemRendererData
		 */

		/**
		 * @inheritDoc
		 */
		override protected function getListItemRendererDataClass() : Class {
			return TreeNodeRendererData;
		}

		/*
		 * ListItemData
		 */

		/**
		 * @inheritDoc
		 */
		override protected function getListItemDataClass() : Class {
			return TreeNodeData;
		}

		/**
		 * @inheritDoc
		 */
		override protected function setAdditionalListItemDataProperties(data : ListItemData) : void {
			TreeNodeData(data).setTreeNode_internal(listDataProvider.getNodeAt(data.listIndex));
		}

		/*
		 * ListItemRenderer
		 */

		/**
		 * @inheritDoc
		 */
		override protected function getDefaultListItemRenderer() : Class {
			return TreeNodeRenderer;
		}
		
		/*
		 * Private
		 */
		 
		/**
		 * Expands a node.
		 */
		private function expandNodeAt_private(listIndex : uint, expandAll : Boolean, dispatchTreeNodeEvent : Boolean, refreshList : Boolean) : void {
			var treeNode : ITreeNode = listDataProvider.getNodeAt(listIndex);
			var didSomethingExpand : Boolean = treeNode.expand(expandAll);
			
			if (!didSomethingExpand) return;

			// renderer event
			
			var renderer : ITreeNodeRenderer = getRendererAt(listIndex) as ITreeNodeRenderer;
			if (renderer) { // currently visible in list
				var treeNodeRendererEvent : TreeNodeRendererEvent = createListItemRendererEvent(TreeNodeRendererEvent.EXPANDED) as TreeNodeRendererEvent;
				treeNodeRendererEvent.expandAll = expandAll;
				renderer.dispatchEvent(treeNodeRendererEvent);
			}

			// node event

			if (dispatchTreeNodeEvent) {
				var treeNodeEvent : TreeNodeEvent = createListItemEvent(TreeNodeEvent.EXPANDED, listIndex) as TreeNodeEvent;
				treeNodeEvent.expandAll = expandAll;
				dispatchEvent(treeNodeEvent);
			}
			
			// tree event

			var treeViewEvent : TreeViewEvent = createListViewEvent(TreeViewEvent.EXPANDED) as TreeViewEvent;
			treeViewEvent.listIndex = listIndex;
			treeViewEvent.expandAll = expandAll;
			dispatchEvent(treeViewEvent);
		
			/*
			 * If a node gets exanded the ListView removes all former nodes from
			 * its display immediately and schedules a refill to the next screen
			 * update. We validate here to fill the list asap to circumvent 
			 * a flicker effect.
			 * 
			 * Note, we only validate if the expand/collapse operation is a result of a
			 * user activity.
			 */
			if (refreshList) validateNow();
		}

		/**
		 * Collapses a node.
		 */
		private function collapseNodeAt_private(listIndex : uint, collapseAll : Boolean, dispatchTreeNodeEvent : Boolean, refreshList : Boolean) : void {
			var treeNode : ITreeNode = listDataProvider.getNodeAt(listIndex);
			var didSomethingCollapse : Boolean = treeNode.collapse(collapseAll);

			if (!didSomethingCollapse) return;
			
			// renderer event
			
			var renderer : ITreeNodeRenderer = getRendererAt(listIndex) as ITreeNodeRenderer;
			if (renderer) { // currently visible in list
				var treeNodeRendererEvent : TreeNodeRendererEvent = createListItemRendererEvent(TreeNodeRendererEvent.COLLAPSED) as TreeNodeRendererEvent;
				treeNodeRendererEvent.collapseAll = collapseAll;
				renderer.dispatchEvent(treeNodeRendererEvent);
			}

			// node event

			if (dispatchTreeNodeEvent) {
				var treeNodeEvent : TreeNodeEvent = createListItemEvent(TreeNodeEvent.COLLAPSED, listIndex) as TreeNodeEvent;
				treeNodeEvent.collapseAll = collapseAll;
				dispatchEvent(treeNodeEvent);
			}

			// tree event

			var treeViewEvent : TreeViewEvent = createListViewEvent(TreeViewEvent.COLLAPSED) as TreeViewEvent;
			treeViewEvent.listIndex = listIndex;
			treeViewEvent.collapseAll = collapseAll;
			dispatchEvent(treeViewEvent);

			/*
			 * If a node gets exanded the ListView removes all former nodes from
			 * its display immediately and schedules a refill to the next screen
			 * update. We validate here to fill the list asap to circumvent 
			 * a flicker effect.
			 * 
			 * Note, we only validate if the expand/collapse operation is a result of a
			 * user activity.
			 */
			if (refreshList) validateNow();

		}

		/**
		 * Casts the protected data source adapter to a IListDataProvider.
		 */
		private function get listDataProvider() : IListDataProvider {
			return _dataSourceAdapter as IListDataProvider;
		}

		
	}
}
