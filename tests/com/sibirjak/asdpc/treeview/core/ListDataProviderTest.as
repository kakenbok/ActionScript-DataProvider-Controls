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

	import org.as3commons.collections.fx.ArrayListFx;

	/**
	 * @author jes 14.10.2009
	 */
	public class ListDataProviderTest extends TestCase {
		
		private var _listDataProvider : ListDataProvider;
		private var _rootNode : TreeNode;

		/**
		 * test neutralization
		 */

		override public function setUp() : void {
			_listDataProvider = new ListDataProvider(new TreeViewMock());
			_rootNode = _listDataProvider.rootNode as TreeNode;
		}

		private function setUpWithDataSource(dataSource : *) : void {
			var treeView : TreeViewMock = new TreeViewMock();
			treeView.dataSource = dataSource;

			_listDataProvider = new ListDataProvider(treeView);
			_rootNode = _listDataProvider.rootNode as TreeNode;
			_rootNode.expand();
		}

		override public function tearDown() : void {
		}

		/**
		 * test helper
		 */
		 
		private function validateItems(expectedItems : Array) : void {
			
			for (var i : uint = 0; i < _listDataProvider.size; i++) {
				assertEquals(
					"Item is the item added",
					expectedItems[i],
					ArrayListItem(_listDataProvider.itemAt(i)).name
				);
			}

			assertEquals(
				"Num expected items equals num items",
				expectedItems.length,
				_listDataProvider.size
			);
		}
		
		protected function dump() : void {
			trace("\n----"+_rootNode.toArray().join("\n----"));
		}

		protected function dump2() : void {
			for (var i : uint = 0; i < _listDataProvider.size; i++) {
				trace("----"+_listDataProvider.itemAt(i));
			}
		}

		/**
		 * Test initial state
		 */

		public function testInstantiated() : void {
			assertTrue("DP instantiated", _listDataProvider is ListDataProvider);
		}
	
		/**
		 * Test setting data source
		 */

		public function testSetSimpleDataSource() : void {
			setUpWithDataSource(DataSourceCreator.getSimpleDataSource("Test", 3));
			
			assertEquals(
				"DP has now 4 items - root and 3 children",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

		}

		public function testSetComplexDataSource() : void {
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);
			
			assertEquals(
				"DP has now 4 items - root and 3 children",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

		}

		public function testResetDataSource() : void {
			setUpWithDataSource(DataSourceCreator.getSimpleDataSource("Test1", 3));
			setUpWithDataSource(DataSourceCreator.getSimpleDataSource("Test2", 1));
			
			assertEquals(
				"DP has now 2 items",
				2,
				_listDataProvider.size
			);

			validateItems([
				"Test2 Root",
					"Test2 1"
			]);
		}

		/**
		 * Test adding of items
		 */

		public function testAddItemAtStart() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			setUpWithDataSource(dataSource);
			
			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);

			dataSource.addFirst(new ArrayListItem("Test 4"));
			
			assertEquals(
				"DP has now 5 items",
				5,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 4",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

			dataSource.addFirst(new ArrayListItem("Test 5"));
			dataSource.addFirst(new ArrayListItem("Test 6"));
			
			validateItems([
				"Test Root",
					"Test 6",
					"Test 5",
					"Test 4",
					"Test 1",
					"Test 2",
					"Test 3"
			]);
		}

		public function testAddItemsAtStart() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			setUpWithDataSource(dataSource);
			
			dataSource.addAllAt(0, [
				new ArrayListItem("Test 4"),
				new ArrayListItem("Test 5")
			]);
			
			assertEquals(
				"DP has now 6 items",
				6,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 4",
					"Test 5",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

			dataSource.addAllAt(0, [
				new ArrayListItem("Test 6"),
				new ArrayListItem("Test 7")
			]);
			
			validateItems([
				"Test Root",
					"Test 6",
					"Test 7",
					"Test 4",
					"Test 5",
					"Test 1",
					"Test 2",
					"Test 3"
			]);
		}

		public function testAddItemAtEnd() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			setUpWithDataSource(dataSource);
			
			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);

			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

			dataSource.addLast(new ArrayListItem("Test 4"));
			
			assertEquals(
				"DP has now 5 items",
				5,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3",
					"Test 4"
			]);

			dataSource.addLast(new ArrayListItem("Test 5"));
			dataSource.addLast(new ArrayListItem("Test 6"));
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3",
					"Test 4",
					"Test 5",
					"Test 6"
			]);
		}

		public function testAddItemsAtEnd() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			setUpWithDataSource(dataSource);
			
			dataSource.addAllAt(3, [
				new ArrayListItem("Test 4"),
				new ArrayListItem("Test 5")
			]);
			
			assertEquals(
				"DP has now 6 items",
				6,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3",
					"Test 4",
					"Test 5"
			]);

			dataSource.addAllAt(5, [
				new ArrayListItem("Test 6"),
				new ArrayListItem("Test 7")
			]);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3",
					"Test 4",
					"Test 5",
					"Test 6",
					"Test 7"
			]);
		}

		public function testAddItemInBetween() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			setUpWithDataSource(dataSource);
			
			dataSource.addAt(1, new ArrayListItem("Test 4"));
			
			assertEquals(
				"DP has now 5 items",
				5,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 4",
					"Test 2",
					"Test 3"
			]);

			dataSource.addAt(2, new ArrayListItem("Test 5"));
			dataSource.addAt(2, new ArrayListItem("Test 6"));
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 4",
					"Test 6",
					"Test 5",
					"Test 2",
					"Test 3"
			]);

		}
		
		public function testAddItemsInBetween() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			setUpWithDataSource(dataSource);
			
			dataSource.addAllAt(1, [
				new ArrayListItem("Test 4"),
				new ArrayListItem("Test 5")
			]);
			
			assertEquals(
				"DP has now 6 items",
				6,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 4",
					"Test 5",
					"Test 2",
					"Test 3"
			]);

			dataSource.addAllAt(2, [
				new ArrayListItem("Test 6"),
				new ArrayListItem("Test 7")
			]);
			
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 4",
					"Test 6",
					"Test 7",
					"Test 5",
					"Test 2",
					"Test 3"
			]);

		}
		
		public function testAddItemToCollapsedItem() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			
			setUpWithDataSource(dataSource);

			/*
			 * Collapse Root
			 */
			
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);
			
			/*
			 * Add Item at end
			 */

			dataSource.addLast(new ArrayListItem("Test 4"));

			/*
			 * Expand Root
			 */

			_rootNode.expand();

			assertEquals(
				"DP has now 5 items",
				5,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3",
					"Test 4"
			]);
		}

		public function testAddItemToHiddenItem() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			
			setUpWithDataSource(dataSource);

			/*
			 * Collapse Root
			 */
			
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);
			
			/*
			 * Add single Item below Item 1 and expand Item 1
			 */

			var item1 : TreeNode = _rootNode.first;
			ArrayListFx(item1.dataSource).add(new ArrayListItem("Test 1 1"));
			
			/*
			 * Expand Root
			 */

			_rootNode.expand(true);

			assertEquals(
				"DP has now 5 items",
				5,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
					"Test 2",
					"Test 3"
			]);

			/*
			 * Collapse Root
			 */
			
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);
			
			/*
			 * Add complex Item below Item 1 and expand Item 1
			 */

			var item2 : ArrayListItem = ArrayListFx(_rootNode.dataSource).itemAt(1);
			item2.add(DataSourceCreator.getComplexDataSourceItem("Test 2 1"));
			
			/*
			 * Expand Root
			 */

			_rootNode.expand(true);

			assertEquals(
				"DP has now 7 items",
				7,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
					"Test 3"
			]);
		}

		public function testAddToComplexDataSource() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);
			
			_rootNode.expand(true);

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);
			
			// Add between Test 1 1 and Test 1 2
			
			var item1 : ArrayListFx = ArrayListFx(_rootNode.dataSource).first;
			item1.addAt(1, new ArrayListItem("Test 1 1 b"));

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 1 b",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			// Add between Test 1 2 and Test 1 3

			item1.addAt(3, new ArrayListItem("Test 1 2 b"));

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 1 b",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 2 b",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			// Add after Test 3

			ArrayListFx(_rootNode.dataSource).addAt(3, new ArrayListItem("Test 4"));

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 1 b",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 2 b",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3",
					"Test 4"
			]);

		}

		/**
		 * Test remove items
		 */

		public function testRemoveItemAtStart() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			setUpWithDataSource(dataSource);
			
			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);

			dataSource.removeFirst();
			
			assertEquals(
				"DP has now 3 items",
				3,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 2",
					"Test 3"
			]);

			dataSource.removeFirst();
			
			validateItems([
				"Test Root",
					"Test 3"
			]);

			dataSource.removeFirst();

			validateItems([
				"Test Root"
			]);
		}

		public function testRemoveItemsAtStart() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 7);
			setUpWithDataSource(dataSource);
			
			dataSource.removeAllAt(0, 2);
			
			assertEquals(
				"DP has now 6 items",
				6,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 3",
					"Test 4",
					"Test 5",
					"Test 6",
					"Test 7"
			]);

			dataSource.removeAllAt(0, 2);
			
			validateItems([
				"Test Root",
					"Test 5",
					"Test 6",
					"Test 7"
			]);

			dataSource.removeAllAt(0, 3);
			
			validateItems([
				"Test Root"
			]);

		}

		public function testRemoveItemAtEnd() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			setUpWithDataSource(dataSource);
			
			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);

			dataSource.removeLast();
			
			assertEquals(
				"DP has now 3 items",
				3,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2"
			]);

			dataSource.removeLast();
			
			validateItems([
				"Test Root",
					"Test 1"
			]);

			dataSource.removeLast();

			validateItems([
				"Test Root"
			]);
		}

		public function testRemoveItemsAtEnd() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 7);
			setUpWithDataSource(dataSource);
			
			dataSource.removeAllAt(5, 2);
			
			assertEquals(
				"DP has now 6 items",
				6,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3",
					"Test 4",
					"Test 5"
			]);

			dataSource.removeAllAt(3, 2);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

			dataSource.removeAllAt(0, 3);
			
			validateItems([
				"Test Root"
			]);

		}

		public function testRemoveItemInBetween() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 4);
			setUpWithDataSource(dataSource);
			
			assertEquals(
				"DP has now 5 items",
				5,
				_listDataProvider.size
			);

			dataSource.removeAt(2);
			
			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 4"
			]);

			dataSource.removeAt(1);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 4"
			]);

			dataSource.removeAt(0);
			dataSource.removeAt(0);

			validateItems([
				"Test Root"
			]);
		}

		public function testRemoveItemsInBetween() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 7);
			setUpWithDataSource(dataSource);
			
			dataSource.removeAllAt(2, 2);
			
			assertEquals(
				"DP has now 6 items",
				6,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 5",
					"Test 6",
					"Test 7"
			]);

			dataSource.removeAllAt(1, 3);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 7"
			]);

			dataSource.removeAllAt(0, 2);
			
			validateItems([
				"Test Root"
			]);

		}

		public function testRemoveItemFromCollapsedItem() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			
			setUpWithDataSource(dataSource);

			/*
			 * Collapse Root
			 */
			
			_rootNode.collapse(true);

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);
			
			/*
			 * Add Item at end
			 */

			dataSource.removeAt(1);

			/*
			 * Expand Root
			 */

			_rootNode.expand();

			assertEquals(
				"DP has now 3 items",
				3,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 3"
			]);
		}

		public function testRemoveItemFromHiddenItem() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			
			setUpWithDataSource(dataSource);
			
			var item1 : ArrayListItem = ArrayListItem(_rootNode.dataSource).first;
			item1.add(new ArrayListItem("Test 1 1"));
			item1.add(new ArrayListItem("Test 1 2"));

			/*
			 * ExpandAll Root
			 */

			_rootNode.expand(true);

			assertEquals(
				"DP has now 6 items",
				6,
				_listDataProvider.size
			);

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
					"Test 2",
					"Test 3"
			]);

			/*
			 * Collapse Root
			 */
			
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);
			
			/*
			 * Remove first item from Item 1
			 */

			item1.removeFirst();
			
			/*
			 * Expand Root
			 */

			_rootNode.expand(true);

			assertEquals(
				"DP has now 5 items",
				5,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 2",
					"Test 2",
					"Test 3"
			]);

			/*
			 * Collapse Root
			 */
			
			_rootNode.collapse(true);

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);
			
			/*
			 * Remove first item from Item 1
			 */

			item1.removeFirst();
			
			/*
			 * Expand Root
			 */

			_rootNode.expand(true);

			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

		}

		public function testRemoveFromComplexDataSource() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);
			
			_rootNode.expand(true);

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);
			
			// remove item Test 1 3
			
			var item1 : ArrayListFx = ArrayListFx(_rootNode.dataSource).first;
			item1.removeAt(2);

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			// remove item Test 2
			
			ArrayListFx(_rootNode.dataSource).removeAt(1);

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			// remove item Test 3 2 1

			var item3 : ArrayListFx = ArrayListFx(_rootNode.dataSource).itemAt(1);
			var item3_2 : ArrayListFx = item3.itemAt(1);
			item3_2.removeAt(0);

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			// remove item Test 3 2 2
			// remove item Test 3 2 3

			item3_2.removeAt(0);
			item3_2.removeAt(0);

			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
					"Test 3",
						"Test 3 1",
						"Test 3 2"
			]);

		}
		
		public function testClearRoot() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getSimpleDataSource("Test", 3);
			
			setUpWithDataSource(dataSource);
			
			_rootNode.expand(true);

			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

			/*
			 * Clear Root
			 */

			ArrayListFx(_rootNode.dataSource).clear();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);

			validateItems([
				"Test Root"
			]);
			
			assertFalse(
				"Root collapsed",
				_rootNode.isExpanded
			);

			/*
			 * Add to Root
			 */

			dataSource.add(new ArrayListItem("Test 1"));
			
			assertFalse(
				"Root still collapsed",
				_rootNode.isExpanded
			);

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);

			validateItems([
				"Test Root"
			]);

			/*
			 * Expand Root
			 */

			_rootNode.expand(true);

			assertEquals(
				"DP has now 2 items",
				2,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1"
			]);

		}

		public function testClearChildItem() : void {
			
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);
			
			_rootNode.expand(true);
			
			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);


			/*
			 * Clear Item 1
			 */

			var item1 : TreeNode = _rootNode.first;
			ArrayListFx(item1.dataSource).clear();

			assertEquals(
				"DP has now 13 items",
				13,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * Add to Item 1
			 */

			ArrayListFx(item1.dataSource).addAllAt(0, [
				new ArrayListItem("Test 1 1"),
				new ArrayListItem("Test 1 2")
			]);
			
			/*
			 * Expand Root
			 */

			_rootNode.expand(true);

			assertEquals(
				"DP has now 15 items",
				15,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

		}

		/**
		 * Test expand collapse
		 */
		 
		public function testExpandCollapse() : void {
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);
			
			assertEquals(
				"Tree is the right one",
				"Test Root",
				ArrayListItem(_rootNode.dataSource).name
			);

			/*
			 * Collapse all
			 */
			
			_rootNode.collapse(true);

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			/*
			 * Expand all
			 */

			_rootNode.expand(true);
			
			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * Collapse and expand Root
			 */
			 
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			_rootNode.expand();

			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * Collapse Test 1
			 */

			var test1 : TreeNode = _rootNode.first;
			
			assertEquals(
				"Tree is the right one",
				"Test 1",
				ArrayListItem(test1.dataSource).name
			);
			
			test1.collapse();

			assertEquals(
				"DP has now 13 items",
				13,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * Collapse Test 3 2
			 */

			var test3 : TreeNode = _rootNode.itemAt(2);
			var test3_2 : TreeNode = test3.itemAt(1);
			
			assertEquals(
				"Tree is the right one",
				"Test 3 2",
				ArrayListItem(test3_2.dataSource).name
			);
			
			test3_2.collapse();

			assertEquals(
				"DP has now 10 items",
				10,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2"
			]);

			/*
			 * Collapse Test 2
			 */

			var test2 : TreeNode = _rootNode.itemAt(1);
			
			assertEquals(
				"Tree is the right one",
				"Test 2",
				ArrayListItem(test2.dataSource).name
			);
			
			test2.collapse();

			assertEquals(
				"DP has now 6 items",
				6,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3",
						"Test 3 1",
						"Test 3 2"
			]);

			/*
			 * Expand Test 2
			 */

			test2.expand();

			assertEquals(
				"DP has now 10 items",
				10,
				_listDataProvider.size
			);

			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2"
			]);

			/*
			 * Collapse and expand Root
			 */
			 
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			_rootNode.expand();

			assertEquals(
				"DP has now 10 items",
				10,
				_listDataProvider.size
			);

			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2"
			]);

			/*
			 * Collapse and expandAll Root
			 */
			 
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			_rootNode.expand(true);

			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * Collapse Test 1, collapse and expand Root
			 */
			 
			test1.collapse();
			_rootNode.collapse();
			_rootNode.expand();

			assertEquals(
				"DP has now 13 items",
				13,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * CollapseAll, expand Root
			 */

			_rootNode.collapse(true);

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);

			validateItems([
				"Test Root"
			]);

			_rootNode.expand();

			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

			/*
			 * ExpandAll Test 2
			 */

			test2.expand(true);

			assertEquals(
				"DP has now 8 items",
				8,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3"
			]);

			/*
			 * CollapseAll and expand Test 2
			 */

			test2.collapse(true);

			assertEquals(
				"DP has now 4 items",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

			test2.expand();

			assertEquals(
				"DP has now 7 items",
				7,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3"
			]);

			/*
			 * Expand Test 1, expand Test 1 2
			 */

			test1.expand();
			var test1_2 : TreeNode = test1.itemAt(1);
			test1_2.expand();
			
			assertEquals(
				"DP has now 12 items",
				12,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3"
			]);
		}

		public function testExpandCollapseHiddenItems() : void {
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);
			
			_rootNode.collapse(true);
			_rootNode.expand(true);
			
			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);
			
			/*
			 * Collapse Root
			 */
	
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			/*
			 * Collapse Test 1 2
			 */
			
			var test1 : TreeNode = _rootNode.first;
			var test1_2 : TreeNode = test1.itemAt(1);
			test1_2.collapse();
			
			/*
			 * Expand Root
			 */

			_rootNode.expand();
			
			assertEquals(
				"DP has now 16 items",
				16,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * Collapse Root
			 */
	
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			/*
			 * Expand Test 1 2
			 */
			
			test1_2.expand();

			/*
			 * Expand Root
			 */

			_rootNode.expand();

			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);
			
			/*
			 * Collapse Root
			 */
	
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			/*
			 * CollapseAll Test 1
			 */
			
			test1.collapse(true);
			
			/*
			 * Expand Root
			 */

			_rootNode.expand();

			assertEquals(
				"DP has now 13 items",
				13,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * Collapse Root
			 */
	
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			/*
			 * ExpandAll Test 1
			 */
			
			test1.expand(true);
			
			/*
			 * Expand Root
			 */

			_rootNode.expand();

			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

		}


		public function testExpandCollapseHiddenItems2() : void {
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);

			assertEquals(
				"DP has now 4 items - root and 3 children",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);
			
			/*
			 * Collapse Root
			 */
	
			
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);
			
			/*
			 * ExpandAll Test 1
			 */
			
			var test1 : TreeNode = _rootNode.first;
			test1.expand(true);
			
			/*
			 * Expand Root
			 */

			_rootNode.expand();

			assertEquals(
				"DP has now 9 items",
				9,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
					"Test 3"
			]);

		}

		public function testExpandAllExpandedItem() : void {
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);

			assertEquals(
				"DP has now 4 items - root and 3 children",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);
			
			/*
			 * ExpandAll Root
			 */
		
			
			_rootNode.expand(true);
			
			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

		}

		public function testCollapsAllCollapsedItem() : void {
			var dataSource : ArrayListFx = DataSourceCreator.getComplexDataSource("Test");
			
			setUpWithDataSource(dataSource);

			assertEquals(
				"DP has now 4 items - root and 3 children",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);
			
			/*
			 * ExpandAll Root
			 */
		
			
			_rootNode.expand(true);
			
			assertEquals(
				"DP has now 18 items",
				18,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
						"Test 1 1",
						"Test 1 2",
							"Test 1 2 1",
							"Test 1 2 2",
						"Test 1 3",
					"Test 2",
						"Test 2 1",
							"Test 2 1 1",
						"Test 2 2",
						"Test 2 3",
					"Test 3",
						"Test 3 1",
						"Test 3 2",
							"Test 3 2 1",
							"Test 3 2 2",
							"Test 3 2 3"
			]);

			/*
			 * Collapse Root
			 */
	
			_rootNode.collapse();

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);
			
			/*
			 * CollapseAll Root
			 */

			_rootNode.collapse(true);

			assertEquals(
				"DP has now 1 item",
				1,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root"
			]);

			/*
			 * Expand Root
			 */

			_rootNode.expand();

			assertEquals(
				"DP has now 4 items - root and 3 children",
				4,
				_listDataProvider.size
			);
			
			validateItems([
				"Test Root",
					"Test 1",
					"Test 2",
					"Test 3"
			]);

		}

	}
}
