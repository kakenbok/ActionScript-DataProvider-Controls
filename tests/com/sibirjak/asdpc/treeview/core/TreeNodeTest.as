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
	import flexunit.framework.TestCase;

	import com.sibirjak.asdpc.treeview.testhelper.ArrayListItem;
	import com.sibirjak.asdpc.treeview.testhelper.DataSourceCreator;
	import com.sibirjak.asdpc.treeview.testhelper.TreeViewMock;

	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.utils.CollectionUtils;

	/**
	 * @author jes 15.10.2009
	 */
	public class TreeNodeTest extends TestCase {

		private var _treeNode : TreeNode;

		/**
		 * test neutralization
		 */

		override public function setUp() : void {
			
			var treeView : TreeViewMock = new TreeViewMock();
			treeView.dataSource = DataSourceCreator.getComplexDataSource("Tree");

			var listDataProvider : ListDataProvider = new ListDataProvider(treeView);
			_treeNode = listDataProvider.rootNode as TreeNode;
			_treeNode.expand();

			// initial state will be:
			
			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3",
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

		}


		override public function tearDown() : void {
		}
		
		/**
		 * test helper
		 */
		 
		private function initialiseAllChildrenAndExpandRoot() : void {
			_treeNode.expand(true);
			_treeNode.collapse(true);
			_treeNode.expand();
		}
		
		private function validateItems(expectedItems : Array) : String {
			var iterator : IIterator = _treeNode.getRecursiveIterator();
			
			var i : uint = 0;
			var node : TreeNode;
			while (iterator.hasNext()) {
				node = iterator.next();
				if (expectedItems[i] != ArrayListItem(node.dataSource).name) {
					return "Item is the item added: " + expectedItems[i] + " != " + ArrayListItem(node.dataSource).name;
				}
				
				i++;
			}
			
			if (expectedItems.length != i) {
				return "Num expected items equals num items: " + i + " != " + expectedItems.length;
			}
			
			return null;

		}
		
		private function validateVisibleItems(expectedItems : Array) : String {
			
			if (!_treeNode.isExpanded) {
				if (expectedItems.length) {
					return "Tree not expanded but visible items are expected " + expectedItems;
				}
				return null;
			}
			
			var iterator : IIterator = _treeNode.getExpandedNodesRecursiveIterator();
			var i : uint = 0;
			var node : TreeNode;
			while (iterator.hasNext()) {
				node = iterator.next();
				
				if (expectedItems[i] != ArrayListItem(node.dataSource).name) {
					return "Item is not the item added " + expectedItems[i] + " != " + ArrayListItem(node.dataSource).name;
				}
				
				if (node.isExpanded) {
					
					if (!node.isBranch) {
						return "Item expanded but not a branch node " + node;
					}
				}

				i++;
			}
			
			if (expectedItems.length != i) {
				return "Num expected items equals num items: " + i + " != " + expectedItems.length;
			}
			
			return validateDataSourceIndex();
		}
		
		private function validateDataSourceIndex() : String {
			var i : uint = 0;
			var iterator : IIterator = _treeNode.iterator();
			var node : TreeNode;
			while (iterator.hasNext()) {
				node = iterator.next();
				if (i != node.itemIndex) {
					return "Tree with right dataSourceIndex: " + i + " !=" + node.itemIndex;
				}
				i++;
			}
			
			return null;
		}
		
		protected function dump() : void {
			trace(CollectionUtils.dumpAsString(_treeNode));
		}

		/**
		 * Tree initial state
		 */

		public function _testInstantiated() : void {
			assertTrue("Tree instantiated", _treeNode is TreeNode);
		}
	
		public function testTreesInitialState() : void {
			
			initialiseAllChildrenAndExpandRoot();
			
			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);
		}

		/**
		 * Tree expand/collapse
		 */

		public function _testExpandCollapse() : void {
			
			initialiseAllChildrenAndExpandRoot();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			/*
			 * Expand Tree 1
			 */

			var tree1 : TreeNode = _treeNode.first;
			tree1.expand();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
					"Tree 1 1",
					"Tree 1 2",
					"Tree 1 3",
				"Tree 2",
				"Tree 3"
				])
			);

			/*
			 * Expand Tree 1 2
			 */

			var tree1_2 : TreeNode = tree1.itemAt(1);
			tree1_2.expand();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
					"Tree 1 1",
					"Tree 1 2",
						"Tree 1 2 1",
						"Tree 1 2 2",
					"Tree 1 3",
				"Tree 2",
				"Tree 3"
				])
			);

			/*
			 * Collaps Tree 1
			 */

			tree1.collapse();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
				"Tree 2",
				"Tree 3"
				])
			);

			/*
			 * Collaps Tree 1 2
			 */

			tree1_2.collapse();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
				"Tree 2",
				"Tree 3"
				])
			);

			/*
			 * Expand Tree 1
			 */

			tree1.expand();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
					"Tree 1 1",
					"Tree 1 2",
					"Tree 1 3",
				"Tree 2",
				"Tree 3"
				])
			);

			/*
			 * ExpandAll _treeNode
			 */
			
			_treeNode.expand(true);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
					"Tree 1 1",
					"Tree 1 2",
						"Tree 1 2 1",
						"Tree 1 2 2",
					"Tree 1 3",
				"Tree 2",
					"Tree 2 1",
						"Tree 2 1 1",
					"Tree 2 2",
					"Tree 2 3",
				"Tree 3",
					"Tree 3 1",
					"Tree 3 2",
						"Tree 3 2 1",
						"Tree 3 2 2",
						"Tree 3 2 3"
				])
			);

			/*
			 * Collapse Tree 1
			 */

			tree1.collapse();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
				"Tree 2",
					"Tree 2 1",
						"Tree 2 1 1",
					"Tree 2 2",
					"Tree 2 3",
				"Tree 3",
					"Tree 3 1",
					"Tree 3 2",
						"Tree 3 2 1",
						"Tree 3 2 2",
						"Tree 3 2 3"
				])
			);

			/*
			 * Collaps Tree 1 2
			 */

			tree1_2.collapse();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
				"Tree 2",
					"Tree 2 1",
						"Tree 2 1 1",
					"Tree 2 2",
					"Tree 2 3",
				"Tree 3",
					"Tree 3 1",
					"Tree 3 2",
						"Tree 3 2 1",
						"Tree 3 2 2",
						"Tree 3 2 3"
				])
			);

			/*
			 * Expand Tree 1
			 */

			tree1.expand();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
					"Tree 1 1",
					"Tree 1 2",
					"Tree 1 3",
				"Tree 2",
					"Tree 2 1",
						"Tree 2 1 1",
					"Tree 2 2",
					"Tree 2 3",
				"Tree 3",
					"Tree 3 1",
					"Tree 3 2",
						"Tree 3 2 1",
						"Tree 3 2 2",
						"Tree 3 2 3"
				])
			);

			/*
			 * CollapseAll root, expand root
			 */
			 
			_treeNode.collapse(true);
			_treeNode.expand();

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				"Tree 1",
				"Tree 2",
				"Tree 3"
				])
			);
		}
		
		public function _testExpandCollapse2() : void {
			
			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			/*
			 * Expand Tree 1
			 */

			var tree1 : TreeNode = _treeNode.first;
			tree1.expand();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			/*
			 * Expand Tree 1 2
			 */

			var tree1_2 : TreeNode = tree1.itemAt(1);
			tree1_2.expand();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			/*
			 * ExpandAll Tree 3
			 */

			var tree3 : TreeNode = _treeNode.itemAt(2);
			tree3.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

		}
		
		public function _testTreeCollapsedWhenEmpty() : void {
			
			//initialiseAllChildrenAndExpandRoot();
			
			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertTrue("Tree is expanded", _treeNode.isExpanded);
			
			/*
			 * remove first item
			 */
			
			ArrayListItem(_treeNode.dataSource).removeFirst();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 2",
					"Tree 3"
				])
			);

			assertTrue("Tree is expanded", _treeNode.isExpanded);

			/*
			 * remove first item
			 */
			
			ArrayListItem(_treeNode.dataSource).removeFirst();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 3"
				])
			);

			assertTrue("Tree is expanded", _treeNode.isExpanded);

			/*
			 * remove first item
			 */
			
			ArrayListItem(_treeNode.dataSource).removeFirst();

			assertNull(
				"Tree contains the right items",
					validateItems([
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			assertFalse("Tree is collapsed", _treeNode.isExpanded);

			/*
			 * Add complex item to Tree
			 */
			 
			ArrayListItem(_treeNode.dataSource).add(DataSourceCreator.getComplexDataSourceItem("Tree 1"));

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			assertFalse("Tree is collapsed", _treeNode.isExpanded);

		}

		public function _testTreeCollapsedWhenEmpty2() : void {
			
			//initialiseAllChildrenAndExpandRoot();
			
			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertTrue("Tree is expanded", _treeNode.isExpanded);
			
			/*
			 * Remove all items
			 */
			
			ArrayListItem(_treeNode.dataSource).clear();

			assertNull(
				"Tree contains the right items",
				validateItems([
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			assertFalse("Tree is collapsed", _treeNode.isExpanded);

			/*
			 * Add complex item to Tree
			 */
			 
			ArrayListItem(_treeNode.dataSource).add(DataSourceCreator.getComplexDataSourceItem("Tree 1"));

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			assertFalse("Tree is collapsed", _treeNode.isExpanded);

		}

		/**
		 * Add or remove items
		 */

		// container not initialised, children not initialised
		public function _testAddItemToNotInitialisedDataSource() : void {
			
			_treeNode.collapse();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			/*
			 * Add item below Item 1 1
			 */

			var tree1 : TreeNode = _treeNode.first;

			assertEquals("Tree1 still empty", 0, tree1.size); 

			var item1_1 : ArrayListItem = ArrayListItem(tree1.dataSource).first;
			item1_1.add(new ArrayListItem("Tree 1 1 1"));

			_treeNode.expand();
			tree1.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
							"Tree 1 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
							"Tree 1 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

		}
		
		// container initialised, children not initialised
		public function _testAddItemToNotInitialisedDataSource2() : void {
			
			_treeNode.collapse();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			/*
			 * Add item below Item 1 1
			 */

			var tree1 : TreeNode = _treeNode.first;
			
			assertEquals("Tree1 still empty", 0, tree1.size); 

			ArrayListItem(tree1.dataSource).add(new ArrayListItem("Tree 1 4"));

			_treeNode.expand();
			tree1.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
						"Tree 1 4",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
						"Tree 1 4",
					"Tree 2",
					"Tree 3"
				])
			);

		}
		
		public function _testReplacingItems() : void {
			
			initialiseAllChildrenAndExpandRoot();
			
			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			/*
			 * Replace roots items
			 */
			 
			ArrayListItem(_treeNode.dataSource).array = DataSourceCreator.createItemArray("NewTree", 3);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"NewTree 1",
					"NewTree 2",
					"NewTree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"NewTree 1",
					"NewTree 2",
					"NewTree 3"
				])
			);
		}

		public function _testReplacingItems2() : void {
			
			initialiseAllChildrenAndExpandRoot();
			
			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			/*
			 * Replace Tree 2
			 */
			 
			var tree2 : TreeNode = _treeNode.itemAt(1);

			ArrayListItem(tree2.dataSource).array = DataSourceCreator.createItemArray("NewTree", 3);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"NewTree 1",
						"NewTree 2",
						"NewTree 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);
			
			_treeNode.expand(true);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"NewTree 1",
						"NewTree 2",
						"NewTree 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

		}

		public function _testAddingItemsSetsRightDataSourceIndex() : void {
			
			_treeNode.collapse();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);
			
			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);
			
			/*
			 * Add item at end
			 */
			 
			ArrayListItem(_treeNode.dataSource).add(DataSourceCreator.getComplexDataSourceItem("Tree 4"));

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3",
					"Tree 4"
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Add item at start
			 */
			 
			ArrayListItem(_treeNode.dataSource).addFirst(DataSourceCreator.getComplexDataSourceItem("Tree 5"));

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 5",
					"Tree 1",
					"Tree 2",
					"Tree 3",
					"Tree 4"
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Add item in between
			 */
			 
			ArrayListItem(_treeNode.dataSource).addAt(3, DataSourceCreator.getComplexDataSourceItem("Tree 6"));

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 5",
					"Tree 1",
					"Tree 2",
					"Tree 6",
					"Tree 3",
					"Tree 4"
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Add items at end
			 */
			 
			ArrayListItem(_treeNode.dataSource).addAllAt(6, [
				DataSourceCreator.getComplexDataSourceItem("Tree 7"),
				DataSourceCreator.getComplexDataSourceItem("Tree 8"),
				]);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 5",
					"Tree 1",
					"Tree 2",
					"Tree 6",
					"Tree 3",
					"Tree 4",
					"Tree 7",
					"Tree 8"
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Add items at start
			 */
			 
			ArrayListItem(_treeNode.dataSource).addAllAt(0, [
				DataSourceCreator.getComplexDataSourceItem("Tree 9"),
				DataSourceCreator.getComplexDataSourceItem("Tree 10"),
				]);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 9",
					"Tree 10",
					"Tree 5",
					"Tree 1",
					"Tree 2",
					"Tree 6",
					"Tree 3",
					"Tree 4",
					"Tree 7",
					"Tree 8"
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Add items in between
			 */
			 
			ArrayListItem(_treeNode.dataSource).addAllAt(5, [
				DataSourceCreator.getComplexDataSourceItem("Tree 11"),
				DataSourceCreator.getComplexDataSourceItem("Tree 12"),
				]);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 9",
					"Tree 10",
					"Tree 5",
					"Tree 1",
					"Tree 2",
					"Tree 11",
					"Tree 12",
					"Tree 6",
					"Tree 3",
					"Tree 4",
					"Tree 7",
					"Tree 8"
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

		}

		public function _testRemovingItemsSetsRightDataSourceIndex() : void {
			
			_treeNode.collapse();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);
			
			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);
			
			/*
			 * Add items at end
			 */
			 
			ArrayListItem(_treeNode.dataSource).addAllAt(5, [
				DataSourceCreator.getComplexDataSourceItem("Tree 4"),
				DataSourceCreator.getComplexDataSourceItem("Tree 5"),
				DataSourceCreator.getComplexDataSourceItem("Tree 6"),
				DataSourceCreator.getComplexDataSourceItem("Tree 7"),
				DataSourceCreator.getComplexDataSourceItem("Tree 8"),
				DataSourceCreator.getComplexDataSourceItem("Tree 9"),
				DataSourceCreator.getComplexDataSourceItem("Tree 10"),
				DataSourceCreator.getComplexDataSourceItem("Tree 11"),
				DataSourceCreator.getComplexDataSourceItem("Tree 12"),
			]);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3",
					"Tree 4",
					"Tree 5",
					"Tree 6",
					"Tree 7",
					"Tree 8",
					"Tree 9",
					"Tree 10",
					"Tree 11",
					"Tree 12"
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Remove item at end
			 */
			 
			ArrayListItem(_treeNode.dataSource).removeLast();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3",
					"Tree 4",
					"Tree 5",
					"Tree 6",
					"Tree 7",
					"Tree 8",
					"Tree 9",
					"Tree 10",
					"Tree 11",
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Remove item at start
			 */
			 
			ArrayListItem(_treeNode.dataSource).removeFirst();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 2",
					"Tree 3",
					"Tree 4",
					"Tree 5",
					"Tree 6",
					"Tree 7",
					"Tree 8",
					"Tree 9",
					"Tree 10",
					"Tree 11",
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Remove item in between
			 */
			 
			ArrayListItem(_treeNode.dataSource).removeAt(5);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 2",
					"Tree 3",
					"Tree 4",
					"Tree 5",
					"Tree 6",
					"Tree 8",
					"Tree 9",
					"Tree 10",
					"Tree 11",
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Remove items at Start
			 */
			 
			ArrayListItem(_treeNode.dataSource).removeAllAt(0, 2);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 4",
					"Tree 5",
					"Tree 6",
					"Tree 8",
					"Tree 9",
					"Tree 10",
					"Tree 11",
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

			/*
			 * Remove items at end
			 */
			 
			ArrayListItem(_treeNode.dataSource).removeAllAt(5, 2);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 4",
					"Tree 5",
					"Tree 6",
					"Tree 8",
					"Tree 9",
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);


			/*
			 * Remove items in between
			 */
			 
			ArrayListItem(_treeNode.dataSource).removeAllAt(2, 2);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 4",
					"Tree 5",
					"Tree 9",
				])
			);

			assertNull(
				"data source index is valid",
				validateDataSourceIndex()
			);

		}

		// container not initialised, children not initialised
		public function _testRemoveItemFromNotInitialisedDataSource() : void {
			
			_treeNode.collapse();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			/*
			 * Remove item from Item 1 2
			 */

			var tree1 : TreeNode = _treeNode.first;

			assertEquals("Tree1 still empty", 0, tree1.size); 

			var item1_2 : ArrayListItem = ArrayListItem(tree1.dataSource).itemAt(1);
			item1_2.removeFirst();

			_treeNode.expand();
			tree1.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

		}

		// container initialised, children not initialised
		public function _testRemoveItemFromNotInitialisedDataSource2() : void {
			
			_treeNode.collapse();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			/*
			 * Remove item from Item 1
			 */

			var tree1 : TreeNode = _treeNode.first;

			assertEquals("Tree1 still empty", 0, tree1.size); 

			ArrayListItem(tree1.dataSource).removeFirst();

			_treeNode.expand();
			tree1.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

		}

		public function _testAddItemToInvisibleTree() : void {
			
			_treeNode.expand(true);
			_treeNode.collapse(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			/*
			 * Add item to Tree 1
			 */

			var tree1 : TreeNode = _treeNode.first;
			ArrayListItem(tree1.dataSource).add(new ArrayListItem("Tree 1 4"));

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
						"Tree 1 4",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			/*
			 * Add item to Tree 1 4
			 */

			var tree1_4 : TreeNode = tree1.itemAt(3);
			ArrayListItem(tree1_4.dataSource).add(new ArrayListItem("Tree 1 4 1"));

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
						"Tree 1 4", // new, no children initialised
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			/*
			 * Expand Tree 1 4
			 */

			tree1_4.expand();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
						"Tree 1 4",
							"Tree 1 4 1", // new
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			/*
			 * ExpandAll Tree
			 */

			_treeNode.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
						"Tree 1 4",
							"Tree 1 4 1", // new
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
						"Tree 1 4",
							"Tree 1 4 1", // new
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

		}

		public function _testRemoveItemFromInvisibleTree() : void {
			
			_treeNode.expand(true);
			_treeNode.collapse(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 1",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			/*
			 * Remove item from Tree 1 2
			 */

			var tree1 : TreeNode = _treeNode.first;
			var tree1_2 : TreeNode = tree1.itemAt(1);
			ArrayListItem(tree1_2.dataSource).removeFirst();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			/*
			 * Remove item from Tree 1 4
			 */

			var tree2 : TreeNode = _treeNode.itemAt(1);
			ArrayListItem(tree2.dataSource).removeFirst();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			/*
			 * ExpandAll Tree
			 */

			_treeNode.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
							"Tree 1 2 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

		}
		
		/**
		 * Clear collection
		 */
		 
		public function _testClearCollection() : void {
			
			_treeNode.collapse();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			/*
			 * Clear Item 1 2
			 */

			var tree1 : TreeNode = _treeNode.first;

			assertFalse("Tree1 is collapsed", tree1.isExpanded);

			var item1_2 : ArrayListItem = ArrayListItem(tree1.dataSource).itemAt(1);
			item1_2.clear();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			assertFalse("Tree1 is collapsed", tree1.isExpanded);

			/*
			 * ExpandAll Tree 1
			 */

			_treeNode.expand();
			tree1.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3"
				])
			);

			/**
			 * ExpandAll and collapseAll Tree
			 */

			_treeNode.expand(true);
			_treeNode.collapse(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
						"Tree 1 3",
					"Tree 2",
						"Tree 2 1",
							"Tree 2 1 1",
						"Tree 2 2",
						"Tree 2 3",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			/*
			 * Clear Tree 2
			 */

			var tree2 : TreeNode = _treeNode.itemAt(1);

			assertFalse("Tree2 is collapsed", tree1.isExpanded);

			ArrayListItem(tree2.dataSource).clear();

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

			assertFalse("Tree2 is collapsed", tree2.isExpanded);

			/*
			 * ExpandAll Tree
			 */

			_treeNode.expand(true);

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
					"Tree 1",
						"Tree 1 1",
						"Tree 1 2",
						"Tree 1 3",
					"Tree 2",
					"Tree 3",
						"Tree 3 1",
						"Tree 3 2",
							"Tree 3 2 1",
							"Tree 3 2 2",
							"Tree 3 2 3"
				])
			);

			/*
			 * Clear Tree
			 */

			assertTrue("Tree is expanded", _treeNode.isExpanded);

			ArrayListItem(_treeNode.dataSource).clear();

			assertNull(
				"Tree contains the right items",
				validateItems([
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);
			
			assertFalse("Tree is collapsed", _treeNode.isExpanded);

			/*
			 * Add complex item to Tree
			 */
			 
			ArrayListItem(_treeNode.dataSource).add(DataSourceCreator.getComplexDataSourceItem("Tree 1"));

			assertNull(
				"Tree contains the right items",
				validateItems([
					"Tree 1"
				])
			);

			assertNull(
				"Tree shows the right items",
				validateVisibleItems([
				])
			);

		}

	}
}
