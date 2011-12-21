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
package com.sibirjak.asdpc.listview {

	import flexunit.framework.TestCase;

	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;
	import com.sibirjak.asdpc.listview.testhelper.ListViewEventListener;
	import com.sibirjak.asdpc.listview.testhelper.TestListView;

	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.fx.ArrayListFx;

	/**
	 * @author jes 28.10.2009
	 */
	public class ListViewTest extends TestCase {
		
		private var _listView : TestListView;
		private var _added : Boolean;
		
		/**
		 * test neutralization
		 */

		override public function setUp() : void {
			_listView = new TestListView();

			_listView.setSize(300, 200);
			_listView.setStyle(ListView.style.itemSize, 20);

			_listView.setStyle(
				ListItemContent.style.labelFunction,
				function(data : ListItemData) : String {
					return data.item;
				}
			);
			
			_listView.dataSource = createDataSource(20);
			
			_added = false;
		}
		
		private function addToStage(testFunction : Function) : void {
			TestStageProxy.stage.addChild(_listView);
			_added = true;
		}

		override public function tearDown() : void {
			TestStageProxy.stage.removeChild(_listView);
		}
		
		/**
		 * Test helpers
		 */

		private function createDataSource(numItems : uint) : * {
			var dataSource : ArrayListFx = new ArrayListFx();
			for (var i : uint = 0; i < numItems; i++) {
				dataSource.add(i);
			}
			return dataSource;
		}

		private function validateVisibleItems(expectedItems : Array, firstListIndex : uint) : String {
			
			var visibleItems : Array = _listView.getVisibleItems();
			
//			trace ("visibleItems " + visibleItems);
			
			if (visibleItems.length != expectedItems.length) {
				return "Different number of visible renderers than expected: " + expectedItems.length + " != " + visibleItems.length;
			}
			
			var renderer : IListItemRenderer;
			
			for (var i : uint = 0; i < visibleItems.length; i++) {
				
				renderer = visibleItems[i];
				
				if (expectedItems[i] != renderer.data.item) {
					return "Item does not match " + expectedItems[i] + " != " + renderer.data.item;
				}
				
				if (firstListIndex + i != renderer.data.listIndex) {
					return "List index does not match " + (firstListIndex + i) + " != " + renderer.data.listIndex;
				}

			}

			return null;
		}

		/**
		 * Test initial state
		 */

		public function test_Instantiated() : void {
			if (!_added) {addToStage(test_Instantiated);return;}

			assertTrue("ListView instantiated", _listView is ListView);
		}

		public function test_InitialListItems() : void {
			if (!_added) {addToStage(test_InitialListItems);return;}

			assertEquals(
				"List contains 20 items",
				20,
				_listView.numItems
			);

			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
		}

		/**
		 * Test scrolling
		 */

		public function test_ScrollToItemAt() : void {
			
			if (!_added) {addToStage(test_ScrollToItemAt);return;}

			// at 0
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);

			// in between

			_listView.scrollToItemAt(5);

			assertEquals(
				"First visible index is right",
				5,
				_listView.firstVisibleIndex
			);

			assertNull(
				"List shows the right items",
				validateVisibleItems([5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 5)
			);

			// in between

			_listView.scrollToItemAt(3);

			assertEquals(
				"First visible index is right",
				3,
				_listView.firstVisibleIndex
			);

			assertNull(
				"List shows the right items",
				validateVisibleItems([3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 3)
			);

			// scroll over the right border

			_listView.scrollToItemAt(15);

			assertEquals(
				"First visible index is right",
				10,
				_listView.firstVisibleIndex
			);

			assertNull(
				"List shows the right items",
				validateVisibleItems([10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 10)
			);

			_listView.scrollToItemAt(0);

			// at 0

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);

			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);

			// at the end

			_listView.scrollToItemAt(10);

			assertEquals(
				"First visible index is right",
				10,
				_listView.firstVisibleIndex
			);

			assertNull(
				"List shows the right items",
				validateVisibleItems([10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 10)
			);
			
		}
		
		/**
		 * Test list item size
		 */

		public function test_SetitemSize() : void {
			
			if (!_added) {addToStage(test_SetitemSize);return;}

			// at 0
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			// set size to 40 -> 5 items per page
			
			_listView.setStyle(ListView.style.itemSize, 40);

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4], 0)
			);

			// scroll to 4

			_listView.scrollToItemAt(4);

			assertEquals(
				"First visible index is right",
				4,
				_listView.firstVisibleIndex
			);

			assertNull(
				"List shows the right items",
				validateVisibleItems([4, 5, 6, 7, 8], 4)
			);

			// set size to 25 -> 8 items per page
			
			_listView.setStyle(ListView.style.itemSize, 25);
			
			assertEquals(
				"First visible index is right",
				4,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([4, 5, 6, 7, 8, 9, 10, 11], 4)
			);

			// set size to 5 -> 40 items per page
			// should automatically scroll to the first item

			_listView.setStyle(ListView.style.itemSize, 5);

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 0)
			);

			// set size to 50 -> 4 items per page
			
			_listView.setStyle(ListView.style.itemSize, 50);

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3], 0)
			);

			// scroll to 10

			_listView.scrollToItemAt(10);

			assertEquals(
				"First visible index is right",
				10,
				_listView.firstVisibleIndex
			);

			assertNull(
				"List shows the right items",
				validateVisibleItems([10, 11, 12, 13], 10)
			);

			// resize to 300x100 -> 2 items per page
			
			_listView.setSize(300, 100);
			_listView.validateNow();

			assertEquals(
				"First visible index is right",
				10,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([10, 11], 10)
			);

			// set size to 40 -> 2,5 items per page
			
			_listView.setStyle(ListView.style.itemSize, 40);

			assertEquals(
				"First visible index is right",
				10,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([10, 11, 12], 10)
			);

			// set size to 99 -> 1,01 items per page
			
			_listView.setStyle(ListView.style.itemSize, 99);

			assertEquals(
				"First visible index is right",
				10,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([10, 11], 10)
			);

			// set size to 101 -> 0,99 items per page
			
			_listView.setStyle(ListView.style.itemSize, 101);

			assertEquals(
				"First visible index is right",
				10,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([10], 10)
			);

			// set size to 8 -> 12,5 items per page
			// moves first index to the left that all items
			// can be shown
			// index 8 shows the last item entirely
			
			_listView.setStyle(ListView.style.itemSize, 8);

			assertEquals(
				"First visible index is right",
				8,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 8)
			);

			// scroll to 7
			// shows the last item only half

			_listView.scrollToItemAt(7);

			assertEquals(
				"First visible index is right",
				7,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 7)
			);

			// scroll to 8
			// shows the last item entirely

			_listView.scrollToItemAt(8);

			assertEquals(
				"First visible index is right",
				8,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 8)
			);

			// scroll to 9
			// index stays at 8

			_listView.scrollToItemAt(9);

			assertEquals(
				"First visible index is right",
				8,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 8)
			);
		}

		/**
		 * Test adding and removing items
		 */

		public function test_AddItems() : void {
			if (!_added) {addToStage(test_AddItems);return;}

			// at 0
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			// add 2 items before the visible range
			// moves first index to the right
			
			ArrayList(_listView.dataSource).addAllAt(0, [21, 22]);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				2,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 2)
			);

			// add 2 items within the visible range

			ArrayList(_listView.dataSource).addAllAt(4, [23, 24]);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				2,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 23, 24, 2, 3, 4, 5, 6, 7], 2)
			);

			// add 2 items at the end of the visible range

			ArrayList(_listView.dataSource).addAllAt(10, [25, 26]);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				2,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 23, 24, 2, 3, 4, 5, 25, 26], 2)
			);

			// add 2 items after the visible range

			ArrayList(_listView.dataSource).addAllAt(20, [27, 28]);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				2,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 23, 24, 2, 3, 4, 5, 25, 26], 2)
			);

			// add 2 items right before the end of the visible range

			ArrayList(_listView.dataSource).addAllAt(11, [29, 30]);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				2,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 23, 24, 2, 3, 4, 5, 25, 29], 2)
			);
		}
			
		public function test_SetMixedProperties() : void {
			if (!_added) {addToStage(test_SetMixedProperties);return;}

			// at 0
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			_listView.scrollToItemAt(4);
			
			assertEquals(
				"First visible index is right",
				4,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 4)
			);

			assertEquals(
				"List size is right",
				20,
				_listView.numItems
			);

			// remove 2 item at start
			// 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).removeAllAt(0, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				2,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 2)
			);

			assertEquals(
				"List size is right",
				18,
				_listView.numItems
			);

			// add 2 times items at start
			// 24, 25, 20, 21, 22, 23, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).addAllAt(0, [20, 21, 22, 23]);
			ArrayList(_listView.dataSource).addAllAt(0, [24, 25]);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				8,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 8)
			);

			assertEquals(
				"List size is right",
				24,
				_listView.numItems
			);

			// add and remove items at start
			// 30, 31, 24, 25, 20, 21, 22, 23, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).addAllAt(0, [28, 29, 30, 31]);
			ArrayList(_listView.dataSource).removeAllAt(0, 2);

			_listView.validate();
			
			assertEquals(
				"List size is right",
				26,
				_listView.numItems
			);

			assertEquals(
				"First visible index is right",
				10,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 10)
			);

			// add and remove items at start and change item size
			// 34, 35, 30, 31, 24, 25, 20, 21, 22, 23, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).addAllAt(0, [32, 33, 34, 35]);
			ArrayList(_listView.dataSource).removeAllAt(0, 2);

			// set item size to 40 => 5 items visible
			_listView.setStyle(ListView.style.itemSize, 40);

			_listView.validate();
			
			assertEquals(
				"List size is right",
				28,
				_listView.numItems
			);

			assertEquals(
				"First visible index is right",
				12,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([4, 5, 6, 7, 8], 12)
			);

		}

		public function test_RemoveItemsBeforeAndBetweenTheVisibleRange() : void {
			if (!_added) {addToStage(test_RemoveItemsBeforeAndBetweenTheVisibleRange);return;}

			// at 0
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			_listView.scrollToItemAt(6);
			
			assertEquals(
				"First visible index is right",
				6,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 6)
			);

			assertEquals(
				"List size is right",
				20,
				_listView.numItems
			);

			// remove 2 items from begin of the visible range
			// 0, 1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).removeAllAt(6, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				6,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 6)
			);

			// remove 4 items at position 4 (before and between visible range
			// 0, 1, 2, 3, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).removeAllAt(4, 4);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				4,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 4)
			);

		}

		public function test_RemoveItems() : void {
			if (!_added) {addToStage(test_RemoveItems);return;}

			// at 0
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);

			// remove 2 items at start
			// 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).removeAllAt(0, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 0)
			);

			// remove 2 items in between
			// 2, 3, 4, 5, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).removeAllAt(4, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([2, 3, 4, 5, 8, 9, 10, 11, 12, 13], 0)
			);

			// remove 2 items at the end
			// 2, 3, 4, 5, 8, 9, 10, 11, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).removeAllAt(8, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([2, 3, 4, 5, 8, 9, 10, 11, 14, 15], 0)
			);

			// remove 2 items after the end
			// 2, 3, 4, 5, 8, 9, 10, 11, 14, 15, 16, 17

			ArrayList(_listView.dataSource).removeAllAt(12, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([2, 3, 4, 5, 8, 9, 10, 11, 14, 15], 0)
			);

			// remove 2 items right before the end
			// 2, 3, 4, 5, 8, 9, 10, 11, 14, 17

			ArrayList(_listView.dataSource).removeAllAt(9, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([2, 3, 4, 5, 8, 9, 10, 11, 14, 17], 0)
			);

			// set size to 40 - 5 items visible
			// scroll to 5, first item will be 9
			// 2, 3, 4, 5, 8, 9, 10, 11, 14, 17
			
			_listView.setStyle(ListView.style.itemSize, 40);
			_listView.scrollToItemAt(5);

			assertEquals(
				"First visible index is right",
				5,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([9, 10, 11, 14, 17], 5)
			);

			// remove 2 items before the visible range
			// moves the index
			// 2, 5, 8, 9, 10, 11, 14, 17

			ArrayList(_listView.dataSource).removeAllAt(1, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				3,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([9, 10, 11, 14, 17], 3)
			);

			// remove 1 item right before and 1 visible item
			// 2, 5, 10, 11, 14, 17

			ArrayList(_listView.dataSource).removeAllAt(2, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				1,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([5, 10, 11, 14, 17], 1)
			);

			// remove 1 item right before and 1 visible item
			// 10, 11, 14, 17

			ArrayList(_listView.dataSource).removeAllAt(0, 2);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([10, 11, 14, 17], 0)
			);

			// remove all items
			// 10, 11, 14, 17

			ArrayList(_listView.dataSource).removeAllAt(0, 100);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				-1,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([], 0)
			);

			// set item size to 50 -> 4 items per page
			// add 10 items
			
			_listView.setStyle(ListView.style.itemSize, 50);
			ArrayList(_listView.dataSource).addAllAt(0, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3], 0)
			);
			
			// scroll to 4
			
			_listView.scrollToItemAt(4);

			assertEquals(
				"First visible index is right",
				4,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([4, 5, 6, 7], 4)
			);

			// remove first visible item
			// 0, 1, 2, 3, 5, 6, 7, 8, 9

			ArrayList(_listView.dataSource).removeAllAt(4, 1);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				4,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([5, 6, 7, 8], 4)
			);

			// remove first visible item
			// 0, 1, 2, 3, 6, 7, 8, 9

			ArrayList(_listView.dataSource).removeAllAt(4, 1);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				4,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([6, 7, 8, 9], 4)
			);

			// remove first visible item
			// 0, 1, 2, 3, 7, 8, 9

			ArrayList(_listView.dataSource).removeAllAt(4, 1);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				3,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([3, 7, 8, 9], 3)
			);

			// set item size to 80 -> 2,5 items per page

			_listView.setStyle(ListView.style.itemSize, 80);

			assertEquals(
				"First visible index is right",
				3,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([3, 7, 8], 3)
			);
			
			// scroll to 5
			// last item entirely visible
			
			_listView.scrollToItemAt(5);

			assertEquals(
				"First visible index is right",
				5,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([8, 9], 5)
			);

			// remove first visible item
			// 0, 1, 2, 3, 7, 9

			ArrayList(_listView.dataSource).removeAllAt(5, 1);
			_listView.validate();

			assertEquals(
				"First visible index is right",
				4,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([7, 9], 4)
			);

			// scroll to 2
			// last item half visible
			
			_listView.scrollToItemAt(2);

			assertEquals(
				"First visible index is right",
				2,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([2, 3, 7], 2)
			);

			// remove first two items
			// 2, 3, 7, 9
			// last item half visible

			ArrayList(_listView.dataSource).removeAllAt(0, 2);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([2, 3, 7], 0)
			);

			// remove first item
			// 3, 7, 9
			// last item half visible

			ArrayList(_listView.dataSource).removeAllAt(0, 1);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([3, 7, 9], 0)
			);

			// remove first item
			// 7, 9
			// last item entirely visible

			ArrayList(_listView.dataSource).removeAllAt(0, 1);
			_listView.validate();
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([7, 9], 0)
			);

		}
			
		public function test_ClearItems() : void {
			if (!_added) {addToStage(test_ClearItems);return;}

			// at 0
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			// clear

			ArrayList(_listView.dataSource).clear();
			_listView.validate();

			assertEquals(
				"First visible index is right",
				-1,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([], 0)
			);

			// set item size to 50 -> 4 items per page
			// add 10 items
			// scroll to 5
			
			_listView.setStyle(ListView.style.itemSize, 50);
			ArrayList(_listView.dataSource).addAllAt(0, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
			_listView.scrollToItemAt(5);
			
			assertEquals(
				"First visible index is right",
				5,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([5, 6, 7, 8], 5)
			);

			// clear

			ArrayList(_listView.dataSource).clear();
			_listView.validate();

			assertEquals(
				"First visible index is right",
				-1,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([], 0)
			);

		}

		public function test_ReplaceDataSource() : void {
			if (!_added) {addToStage(test_ReplaceDataSource);return;}

			// set item size to 50 -> 4 items per page
			// scroll to 5

			_listView.setStyle(ListView.style.itemSize, 50);
			_listView.scrollToItemAt(5);

			// at 0
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			assertEquals(
				"List contains 20 items",
				20,
				_listView.numItems
			);

			assertEquals(
				"First visible index is right",
				5,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([5, 6, 7, 8], 5)
			);
			
			// replace data source
			
			_listView.dataSource = createDataSource(5);
			_listView.validate();
			
			assertEquals(
				"List contains 5 items",
				5,
				_listView.numItems
			);

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3], 0)
			);

		}
			
		public function test_ReplaceDataSourceSource() : void {
			if (!_added) {addToStage(test_ReplaceDataSourceSource);return;}

			// set item size to 50 -> 4 items per page
			// scroll to 5

			_listView.setStyle(ListView.style.itemSize, 50);
			_listView.scrollToItemAt(5);

			// at 0
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			assertEquals(
				"List contains 20 items",
				20,
				_listView.numItems
			);

			assertEquals(
				"First visible index is right",
				5,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([5, 6, 7, 8], 5)
			);
			
			// replace data source
			
			ArrayList(_listView.dataSource).array = ["a", "b", "c", "d", "e", "f"];
			_listView.validate();
			
			assertEquals(
				"List contains 6 items",
				6,
				_listView.numItems
			);

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems(["a", "b", "c", "d"], 0)
			);

			// scroll to 1
	
			_listView.scrollToItemAt(1);

			assertEquals(
				"First visible index is right",
				1,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems(["b", "c", "d", "e"], 1)
			);

		}
	
	
		/**
		 * Test click item
		 */

//		private function checkClickEvent(
//			listener : ListViewEventListener,
//			listIndex : int,
//			item : *
//		) : String {
//			
//			var event : ListItemEvent = listener.pullEvent();
//			
//			if (!event) return "No click event dispatched";
//			
//			if (event.type != ListItemEvent.SELECTION_CHANGED) {
//				return "List event is not SELECTION_CHANGED but should be. Was: " + event.type;
//			}
//			
//			if (event.listIndex != listIndex) {
//				return "List index does not match expected:" + listIndex + " was:" + event.listIndex;
//			}
//
//			if (event.item != item) {
//				return "List item does not match expected:" + item + " was:" + event.item;
//			}
//			
//			event = listener.pullEvent();
//			
//			if (!event) return "No selection event dispatched";
//			
//			if (event.type != ListItemEvent.CLICK) {
//				return "List event is not CLICK but should be. Was: " + event.type;
//			}
//
//			if (event.listIndex != listIndex) {
//				return "List index does not match expected:" + listIndex + " was:" + event.listIndex;
//			}
//
//			if (event.item != item) {
//				return "List item does not match expected:" + item + " was:" + event.item;
//			}
//
//			return null;
//		}

//		public function test_clickItemAt() : void {
//			if (!_added) {addToStage(test_clickItemAt);return;}
//			
//			var listener : ListViewEventListener = new ListViewEventListener(_listView);
//			assertNull("No event dispatched ", listener.pullEvent());
//			
//
//			// at 0
//			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
//			
//			assertEquals(
//				"First visible index is right",
//				0,
//				_listView.firstVisibleIndex
//			);
//			
//			assertNull(
//				"List shows the right items",
//				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
//			);
//			
//			// click item at 0
//			
//			assertNull("No event dispatched ", listener.pullEvent());
//
//			_listView.itemClickedAt(0);
//
//			assertNull(
//				"Click event dispatched",
//				checkClickEvent(listener, 0, 0)
//			);
//
//
//			// click item at 4
//			
//			assertNull("No event dispatched ", listener.pullEvent());
//
//			_listView.itemClickedAt(4);
//
//			assertNull(
//				"Click event dispatched",
//				checkClickEvent(listener, 4, 4)
//			);
//
//			// click item at 19
//			
//			assertNull("No event dispatched ", listener.pullEvent());
//
//			_listView.itemClickedAt(19);
//
//			assertNull(
//				"Click event dispatched",
//				checkClickEvent(listener, 19, 19)
//			);
//			// click item at 20
//			
//			_listView.itemClickedAt(20);
//
//			assertNull(
//				"No event dispatched",
//				listener.pullEvent()
//			);
//
//		}	
			
		/**
		 * Test select item
		 */

		private function checkSelectionEvent(
			listener : ListViewEventListener,
			selected : Boolean,
			listIndex : int = -2
		) : String {
			
			var event : ListViewEvent = listener.pullEvent();
			
			if (!event) return "No event dispatched";
			
			if (selected && _listView.selectedIndex != listIndex) return "Selected expected but item not selected";
			
			if (!selected && _listView.selectedIndex > -1) return "Deselected expected but item still selected";
			
			return null;
		}
		
		public function test_SelectItemAt() : void {
			if (!_added) {addToStage(test_SelectItemAt);return;}
			
			var listener : ListViewEventListener = new ListViewEventListener(_listView);
			assertNull("No event dispatched ", listener.pullEvent());

			// at 0
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	
			
			// select item at 4
			
			_listView.selectItemAt(4);

			assertEquals(
				"Selected index is right",
				4,
				_listView.selectedIndex
			);

			assertEquals(
				"Selected item is right",
				4,
				_listView.selectedItemData.item
			);
			
			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 4)
			);

			// select item at 13
			
			_listView.selectItemAt(13);

			assertEquals(
				"Selected index is right",
				13,
				_listView.selectedIndex
			);

			assertEquals(
				"Selected item is right",
				13,
				_listView.selectedItemData.item
			);

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 13)
			);

			// deselect item at 13
			
			_listView.deselectItemAt(13);

			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);

			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, false)
			);

			// select item at 4
			
			_listView.selectItemAt(4);

			assertEquals(
				"Selected index is right",
				4,
				_listView.selectedIndex
			);

			assertEquals(
				"Selected item is right",
				4,
				_listView.selectedItemData.item
			);

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 4)
			);

			// deselect item at 4
			
			_listView.deselectItemAt(4);

			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, false)
			);

			// select item at 8
			
			_listView.selectItemAt(8);

			assertEquals(
				"Selected index is right",
				8,
				_listView.selectedIndex
			);
			
			assertEquals(
				"Selected item is right",
				8,
				_listView.selectedItemData.item
			);

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 8)
			);

			// remove selected item at 8
			// 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).removeAllAt(8, 1);
			_listView.validate();
			
			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, false)
			);

			// select last item at 18
			
			_listView.selectItemAt(18);

			assertEquals(
				"Selected index is right",
				18,
				_listView.selectedIndex
			);

			assertEquals(
				"Selected item is right",
				19,
				_listView.selectedItemData.item
			);

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 18)
			);

			// remove last item at 18
			// 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18

			ArrayList(_listView.dataSource).removeAllAt(18, 1);
			_listView.validate();
			
			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, false)
			);

			// select item at 0
			
			_listView.selectItemAt(0);

			assertEquals(
				"Selected index is right",
				0,
				_listView.selectedIndex
			);

			assertEquals(
				"Selected item is right",
				0,
				_listView.selectedItemData.item
			);

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 0)
			);

			// remove first item
			// 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18

			ArrayList(_listView.dataSource).removeAllAt(0, 1);
			_listView.validate();
			
			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, false)
			);

			// remove 4 items at start
			// 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18

			ArrayList(_listView.dataSource).removeAllAt(0, 4);
			_listView.validate();
			
			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// select item at 8
			
			_listView.selectItemAt(8);

			assertEquals(
				"Selected index is right",
				8,
				_listView.selectedIndex
			);
			
			assertEquals(
				"Selected item is right",
				14,
				_listView.selectedItemData.item
			);

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 8)
			);

			// add 2 items before the selected index
			// 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 20, 21, 16, 17, 18
			
			ArrayList(_listView.dataSource).addAllAt(10, [20, 21]);
			_listView.validate();

			assertEquals(
				"Selected index is right",
				8,
				_listView.selectedIndex
			);
			
			assertEquals(
				"Selected item is right",
				14,
				_listView.selectedItemData.item
			);

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// remove the selected item, predecessor and successor
			// 5, 6, 7, 9, 10, 11, 21, 16, 17, 18
			
			ArrayList(_listView.dataSource).removeAllAt(6, 5);
			_listView.validate();

			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, false)
			);

			// remove the selected item and successors
			// 5, 6, 7, 9, 10, 11
			
			ArrayList(_listView.dataSource).removeAllAt(6, 4);
			_listView.validate();

			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// select item at 3
			
			_listView.selectItemAt(3);

			assertEquals(
				"Selected index is right",
				3,
				_listView.selectedIndex
			);
			
			assertEquals(
				"Selected item is right",
				9,
				_listView.selectedItemData.item
			);

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 3)
			);

			// replace data source
			
			_listView.dataSource = createDataSource(5);
			_listView.validate();
			
			assertEquals(
				"List contains 5 items",
				5,
				_listView.numItems
			);

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4], 0)
			);

			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);
			
			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, false)
			);

			// select wrong index
			
			_listView.selectItemAt(20);

			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// deselect again wrong item
			
			_listView.deselectItemAt(0);

			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// select item at 3
			
			_listView.selectItemAt(3);

			assertEquals(
				"Selected index is right",
				3,
				_listView.selectedIndex
			);
			
			assertEquals(
				"Selected item is right",
				3,
				_listView.selectedItemData.item
			);

			assertNull(
				"Selection event dispatched",
				checkSelectionEvent(listener, true, 3)
			);

			// select item at 3 again
			
			_listView.selectItemAt(3);

			assertEquals(
				"Selected index is right",
				3,
				_listView.selectedIndex
			);
			
			assertEquals(
				"Selected item is right",
				3,
				_listView.selectedItemData.item
			);

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

		}
			
		private function checkMultiselectSelectionEvent(
			listener : ListViewEventListener,
			listIndices : Array = null
		) : String {
			
			var event : ListViewEvent = listener.pullEvent();
			
			if (!event) return "No event dispatched";
			
			if (!arraysEqual(listIndices, _listView.selectedIndices)) return "Selected items not as expected";
			
			return null;
		}
		
		/**
		 * Testhelper
		 */

		private function arraysEqual(array1 : Array, array2 : Array) : Boolean {
			var i : int = array1.length;
			if (i != array2.length) {
				return false;
			}
			while (i--) {
				if (array1[i] !== array2[i]) {
					return false;
				}
			}
			return true;
		}

		public function test_SelectItemAtWithMultiselect() : void {
			if (!_added) {addToStage(test_SelectItemAtWithMultiselect);return;}
			
			_listView.multiselect = true;
			
			var listener : ListViewEventListener = new ListViewEventListener(_listView);
			assertNull("No event dispatched ", listener.pullEvent());

			// at 0
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			assertEquals(
				"Selected index is right",
				-1,
				_listView.selectedIndex
			);
			
			assertNull(
				"Selected item is null",
				_listView.selectedItemData
			);	
			
			// select item at 4
			
			_listView.selectItemAt(4);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [4])
			);

			// select item at 13
			
			_listView.selectItemAt(13);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [4, 13])
			);

			// deselect item at 13
			
			_listView.deselectItemAt(13);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [4])
			);

			// select item at 4
			
			_listView.selectItemAt(4);

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// deselect item at 4
			
			_listView.deselectItemAt(4);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [])
			);

			// select item at 8
			
			_listView.selectItemAt(8);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [8])
			);

			// remove selected item at 8
			// 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			ArrayList(_listView.dataSource).removeAllAt(8, 1);
			_listView.validate();
			
			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [])
			);

			// select last item at 18
			
			_listView.selectItemAt(18);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [18])
			);

			// remove last item at 18
			// 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18

			ArrayList(_listView.dataSource).removeAllAt(18, 1);
			_listView.validate();
			
			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [])
			);

			// select item at 0
			
			_listView.selectItemAt(0);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [0])
			);

			// remove first item
			// 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18

			ArrayList(_listView.dataSource).removeAllAt(0, 1);
			_listView.validate();
			
			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [])
			);

			// remove 4 items at start
			// 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18

			ArrayList(_listView.dataSource).removeAllAt(0, 4);
			_listView.validate();
			
			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// select item at 8
			
			_listView.selectItemAt(8);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [8])
			);

			// add 2 items before the selected index
			// 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 20, 21, 16, 17, 18
			
			ArrayList(_listView.dataSource).addAllAt(10, [20, 21]);
			_listView.validate();

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// remove the selected item, predecessor and successor
			// 5, 6, 7, 9, 10, 11, 21, 16, 17, 18
			
			ArrayList(_listView.dataSource).removeAllAt(6, 5);
			_listView.validate();

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [])
			);

			// remove the selected item and successors
			// 5, 6, 7, 9, 10, 11
			
			ArrayList(_listView.dataSource).removeAllAt(6, 4);
			_listView.validate();

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// select item at 3
			
			_listView.selectItemAt(3);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [3])
			);

			// replace data source
			
			_listView.dataSource = createDataSource(5);
			_listView.validate();
			
			assertEquals(
				"List contains 5 items",
				5,
				_listView.numItems
			);

			assertEquals(
				"First visible index is right",
				0,
				_listView.firstVisibleIndex
			);
			
			assertNull(
				"List shows the right items",
				validateVisibleItems([0, 1, 2, 3, 4], 0)
			);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [])
			);

			// select wrong index
			
			_listView.selectItemAt(20);

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// deselect again wrong item
			
			_listView.deselectItemAt(0);

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

			// select item at 3
			
			_listView.selectItemAt(3);

			assertNull(
				"Selection event dispatched",
				checkMultiselectSelectionEvent(listener, [3])
			);

			// select item at 3 again
			
			_listView.selectItemAt(3);

			assertNull(
				"No selection event dispatched",
				listener.pullEvent()
			);

		}


	}
}
