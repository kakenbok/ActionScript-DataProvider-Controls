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
package com.sibirjak.asdpc.listview.core {
	import flexunit.framework.TestCase;

	import com.sibirjak.asdpc.listview.testhelper.ListViewMock;

	/**
	 * @author jes 26.10.2009
	 */
	public class ListItemRendererPoolTest extends TestCase {

		private var _listView : ListViewMock;
		private var _pool : ListItemRendererPool;

		/**
		 * test neutralization
		 */

		override public function setUp() : void {
			_listView = new ListViewMock(100);
			_pool = new ListItemRendererPool(_listView, 100, 5);
		}

		private function setUpWithParameteres(numItems : uint, poolSize : uint) : void {
			_listView = new ListViewMock(numItems);
			_pool = new ListItemRendererPool(_listView, numItems, poolSize);
		}

		override public function tearDown() : void {
		}

		/**
		 * Helpers
		 */

		private function validateVisibleRenderers(expectedItems : Array, firstListIndex : uint) : String {
			
			var visibleItems : Array = _listView.getVisibleRenderers();
			
			if (visibleItems.length != expectedItems.length) {
				return "Different number of visible renderers than expected: " + expectedItems.length + " != " + visibleItems.length;
			}
			
			var renderer : IListItemRenderer;
			
			// renderer retrieved by listView.getVisibleRenderers

			for (var i : uint = 0; i < visibleItems.length; i++) {
				
				renderer = visibleItems[i];
				
				if (expectedItems[i] != renderer.data.item) {
					return "Item does not match " + expectedItems[i] + " != " + renderer.data.item;
				}
				
				if (firstListIndex + i != renderer.data.listIndex) {
					return "List index does not match " + (firstListIndex + i) + " != " + renderer.data.listIndex;
				}

			}
			
			// renderer retrieved by getItem

			for (i = 0; i < expectedItems.length; i++) {
				
				renderer = _pool.getItemAt(firstListIndex + i);
				
				if (expectedItems[i] != renderer.data.item) {
					return "Item does not match2 " + expectedItems[i] + " != " + renderer.data.item;
				}
				
				if (firstListIndex + i != renderer.data.listIndex) {
					return "List index does not match2 " + (firstListIndex + i) + " != " + renderer.data.listIndex;
				}

			}

			// renderer retrieved by TestListItemRenderer

			var visibleRenderers : Array = _pool.getVisibleRenderers();
			
			if (visibleRenderers.length != _pool.getPoolSize()) {
				return "Pool size different than visible renderers size: " + _pool.getPoolSize() + " != " + visibleRenderers.length;
			}

			for (i = 0; i < expectedItems.length; i++) {
				
				renderer = visibleRenderers[i];
				
				if (expectedItems[i] != renderer.data.item) {
					return "Item does not match3 " + expectedItems[i] + " != " + renderer.data.item;
				}
				
				if (firstListIndex + i != renderer.data.listIndex) {
					return "List index does not match3 " + (firstListIndex + i) + " != " + renderer.data.listIndex;
				}

			}

			return null;
		}

		/**
		 * Test initial state
		 */

		public function test_Instantiated() : void {
			assertTrue("Container instantiated", _pool is ListItemRendererPool);
		}

		public function test_InitiallyVisibleRenderers() : void  {
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4], 0)
			);
		}
		
		/**
		 * Test setting size
		 */

		public function test_SetSize() : void  {
			
			setUpWithParameteres(10, 5);
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4], 0)
			);
			
			assertEquals(
				"5 renderers created",
				5,
				_listView.getCreatedRenderers().length
			);
			
			// set size to 10
			
			_pool.poolSize = 10;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			assertEquals(
				"10 renderers created",
				10,
				_listView.getCreatedRenderers().length
			);

			// set size to 7
			
			_pool.poolSize = 7;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5, 6], 0)
			);
			
			assertEquals(
				"7 renderers created",
				7,
				_listView.getCreatedRenderers().length
			);

			// set size to 0

			_pool.poolSize = 0;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);
			
			assertEquals(
				"0 renderers created",
				0,
				_listView.getCreatedRenderers().length
			);

			// set size to 4

			_pool.poolSize = 4;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3], 0)
			);
			
			assertEquals(
				"4 renderers created",
				4,
				_listView.getCreatedRenderers().length
			);

			// set size to 1

			_pool.poolSize = 1;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0], 0)
			);
			
			assertEquals(
				"1 renderer created",
				1,
				_listView.getCreatedRenderers().length
			);

			// set size to 15
			
			_pool.poolSize = 15;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			assertEquals(
				"10 renderers created",
				10,
				_listView.getCreatedRenderers().length
			);

			// set size to 9
			
			_pool.poolSize = 9;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5, 6, 7, 8], 0)
			);
			
			assertEquals(
				"9 renderers created",
				9,
				_listView.getCreatedRenderers().length
			);

			// set size to 11
			
			_pool.poolSize = 11;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			assertEquals(
				"10 renderers created",
				10,
				_listView.getCreatedRenderers().length
			);

		}

		/**
		 * Test set first visible index
		 */

		public function test_SetFirstVisibleIndex() : void {
			
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4], 0)
			);
			
			assertEquals(
				"5 renderers created",
				5,
				_listView.getCreatedRenderers().length
			);
			
			// set first visible index to 10

			_pool.firstVisibleIndex = 10;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([10, 11, 12, 13, 14], 10)
			);

			assertEquals(
				"5 renderers created",
				5,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 50

			_pool.firstVisibleIndex = 50;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([50, 51, 52, 53, 54], 50)
			);

			assertEquals(
				"5 renderers created",
				5,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 1

			_pool.firstVisibleIndex = 1;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([1, 2, 3, 4, 5], 1)
			);

			assertEquals(
				"5 renderers created",
				5,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 98

			_pool.firstVisibleIndex = 98;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([98, 99], 98)
			);

			assertEquals(
				"5 renderers created",
				5,
				_listView.getCreatedRenderers().length
			);

		}
		
		/**
		 * Test set size with changing visible index
		 */

		public function test_SetSizeAndFirstVisibleIndex() : void {
			
			setUpWithParameteres(10, 5);
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4], 0)
			);
			
			assertEquals(
				"5 renderers created",
				5,
				_listView.getCreatedRenderers().length
			);
			
			// set first visible index to 4

			_pool.firstVisibleIndex = 4;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([4, 5, 6, 7, 8], 4)
			);

			assertEquals(
				"5 renderers created",
				5,
				_listView.getCreatedRenderers().length
			);

			// set size to 10

			_pool.poolSize = 10;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([4, 5, 6, 7, 8, 9], 4)
			);

			assertEquals(
				"6 renderers created",
				6,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 2

			_pool.firstVisibleIndex = 2;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([2, 3, 4, 5, 6, 7, 8, 9], 2)
			);

			assertEquals(
				"8 renderers created",
				8,
				_listView.getCreatedRenderers().length
			);

			// set size to 4
			// set first visible index to 6

			_pool.poolSize = 4;
			_pool.firstVisibleIndex = 6;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([6, 7, 8, 9], 6)
			);

			assertEquals(
				"4 renderers created",
				4,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 4
			// set size to 6

			_pool.firstVisibleIndex = 4;
			_pool.poolSize = 6;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([4, 5, 6, 7, 8, 9], 4)
			);

			assertEquals(
				"6 renderers created",
				6,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 2
			// set size to 15

			_pool.firstVisibleIndex = 2;
			_pool.poolSize = 15;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([2, 3, 4, 5, 6, 7, 8, 9], 2)
			);

			assertEquals(
				"8 renderers created",
				8,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 0

			_pool.firstVisibleIndex = 0;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);

			assertEquals(
				"10 renderers created",
				10,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 20
			// set size to 0

			_pool.firstVisibleIndex = 20;
			_pool.poolSize = 0;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			assertEquals(
				"0 renderers created",
				0,
				_listView.getCreatedRenderers().length
			);
			
			// set size to 5

			_pool.poolSize = 5;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			assertEquals(
				"0 renderers created",
				0,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 11
			// set size to 4

			_pool.firstVisibleIndex = 11;
			_pool.poolSize = 4;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			assertEquals(
				"0 renderers created",
				0,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 10
			// set size to 2

			_pool.firstVisibleIndex = 10;
			_pool.poolSize = 2;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			assertEquals(
				"0 renderers created",
				0,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 9
			// set size to 10

			_pool.firstVisibleIndex = 9;
			_pool.poolSize = 10;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([9], 9)
			);

			assertEquals(
				"1 renderer created",
				1,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 8
			// set size to 1

			_pool.firstVisibleIndex = 8;
			_pool.poolSize = 1;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([8], 8)
			);

			assertEquals(
				"1 renderer created",
				1,
				_listView.getCreatedRenderers().length
			);

			// set first visible index to 7
			// set size to 3

			_pool.firstVisibleIndex = 7;
			_pool.poolSize = 3;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([7, 8, 9], 7)
			);

			assertEquals(
				"3 renderers created",
				3,
				_listView.getCreatedRenderers().length
			);

		}

		/**
		 * Test items added or removed
		 */
		
		public function test_ItemsAddedAt() : void {
			
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
			
			setUpWithParameteres(10, 5);
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4], 0)
			);
			
			// add two items at start
			// 11, 12, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

			_listView.addItemsAt(0, [11, 12]);
			_pool.itemsAddedAt(0, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([11, 12, 0, 1, 2], 0)
			);
			
			// add two items in between
			// 11, 13, 14, 12, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

			_listView.addItemsAt(1, [13, 14]); // 
			_pool.itemsAddedAt(1, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([11, 13, 14, 12, 0], 0)
			);

			// add two items at end
			// 11, 13, 14, 15, 16, 12, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

			_listView.addItemsAt(3, [15, 16]);
			_pool.itemsAddedAt(3, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([11, 13, 14, 15, 16], 0)
			);

			// add two items after the last item
			// 11, 13, 14, 15, 16, 12, 0, 1, 17, 18, 2, 3, 4, 5, 6, 7, 8, 9

			_listView.addItemsAt(8, [17, 18]);
			_pool.itemsAddedAt(8, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([11, 13, 14, 15, 16], 0)
			);
			
			// set size to 12
			
			_pool.poolSize = 12;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([11, 13, 14, 15, 16, 12, 0, 1, 17, 18, 2, 3], 0)
			);

			// set visible index to 4

			_pool.firstVisibleIndex = 4;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([16, 12, 0, 1, 17, 18, 2, 3, 4, 5, 6, 7], 4)
			);

			// add two items before the first item
			// 11, 19, 20, 13, 14, 15, 16, 12, 0, 1, 17, 18, 2, 3, 4, 5, 6, 7, 8, 9
			// increases first visible by 2

			_listView.addItemsAt(1, [19, 20]);
			_pool.itemsAddedAt(1, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([16, 12, 0, 1, 17, 18, 2, 3, 4, 5, 6, 7], 6)
			);

			// add one item at end of the visible area
			// 11, 19, 20, 13, 14, 15, 16, 12, 0, 1, 17, 18, 2, 3, 4, 5, 6, 7, 8, 9
			// increases first visible by 2

			_listView.addItemsAt(17, [21]);
			_pool.itemsAddedAt(17, 1);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([16, 12, 0, 1, 17, 18, 2, 3, 4, 5, 6, 21], 6)
			);

			return;

		}

		public function test_ItemsAddedAt2() : void {
			
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
			
			setUpWithParameteres(2, 5);
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1], 0)
			);
			
			// add 9 items at 2

			_listView.addItemsAt(2, [2, 3, 4, 5, 6, 7, 8, 9, 10]);
			_pool.itemsAddedAt(2, 9);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4], 0)
			);

		}
			
		/**
		 * Test items added or removed
		 */
		
		public function test_ItemsRemovedAt() : void {
			
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
			
			setUpWithParameteres(20, 10);
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0)
			);
			
			// remove two items at start
			// 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			_listView.removeItemsAt(0, 2);
			_pool.itemsRemovedAt(0, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 0)
			);

			// remove three items in between
			// 2, 3, 4, 5, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

			_listView.removeItemsAt(4, 3);
			_pool.itemsRemovedAt(4, 3);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([2, 3, 4, 5, 9, 10, 11, 12, 13, 14], 0)
			);

			// remove two items at end
			// 2, 3, 4, 5, 9, 10, 11, 12, 15, 16, 17, 18, 19

			_listView.removeItemsAt(8, 2);
			_pool.itemsRemovedAt(8, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([2, 3, 4, 5, 9, 10, 11, 12, 15, 16], 0)
			);

			// remove two items after the last item
			// 2, 3, 4, 5, 9, 10, 11, 12, 15, 16, 17

			_listView.removeItemsAt(11, 2);
			_pool.itemsRemovedAt(11, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([2, 3, 4, 5, 9, 10, 11, 12, 15, 16], 0)
			);
			
			// set size to 4
			// set first visible index to 5
			
			_pool.poolSize = 4;
			_pool.firstVisibleIndex = 5;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([10, 11, 12, 15], 5)
			);
			
			// remove two items before the first item
			// 2, 5, 9, 10, 11, 12, 15, 16, 17
			// decreases first visible by 2

			_listView.removeItemsAt(1, 2);
			_pool.itemsRemovedAt(1, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([10, 11, 12, 15], 3)
			);
			
			// remove the first visible item and its predecessor
			// 2, 5, 11, 12, 15, 16, 17
			// decreases first visible by 1

			_listView.removeItemsAt(2, 2);
			_pool.itemsRemovedAt(2, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([11, 12, 15, 16], 2)
			);

			// clear all items

			_listView.clear();
			_pool.allItemsRemoved();
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

		}
		
		public function test_ItemsRemovedAt2() : void {
			
			// 0, 1, 2, 3, 4
			
			setUpWithParameteres(5, 3);
			_pool.firstVisibleIndex = 2;
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([2, 3, 4], 2)
			);
			
			// remove the first to items
			// 2, 3, 4
			// decreases first visible by 2

			_listView.removeItemsAt(0, 2);
			_pool.itemsRemovedAt(0, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([2, 3, 4], 0)
			);

		}
			
		public function test_ItemsRemovedAt3() : void {
			
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
			
			setUpWithParameteres(10, 5);
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4], 0)
			);
			
			// remove 9 items at 2

			_listView.removeItemsAt(2, 9);
			_pool.itemsRemovedAt(2, 9);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1], 0)
			);

		}

		public function test_AddRemoveResizeAndReposition() : void {
			
			// 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
			
			setUpWithParameteres(10, 5);
			_pool.refresh();
			
			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4], 0)
			);
			
			// set first visible index to 4

			_pool.firstVisibleIndex = 4;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([4, 5, 6, 7, 8], 4)
			);

			// remove 6 items at 2
			// 0, 1, 8, 9
			// sets visible index to 2

			_listView.removeItemsAt(2, 6);
			_pool.itemsRemovedAt(2, 6);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([8, 9], 2)
			);

			// add 4 items at 4
			// 0, 1, 8, 9, 10, 11, 12, 13

			_listView.addItemsAt(4, [10, 11, 12, 13]);
			_pool.itemsAddedAt(4, 4);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([8, 9, 10, 11, 12], 2)
			);

			// set size to 2

			_pool.poolSize = 2;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([8, 9], 2)
			);

			// clear all items

			_listView.clear();
			_pool.allItemsRemoved();
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			// add 6 items at 0
			// 0, 1, 2, 3, 4, 5

			_listView.addItemsAt(0, [0, 1, 2, 3, 4, 5]);
			_pool.itemsAddedAt(0, 6);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1], 0)
			);

			// clear all items

			_listView.clear();
			_pool.allItemsRemoved();
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			// add 6 items at 0
			// 0, 1, 2, 3, 4, 5

			_listView.addItemsAt(0, [0, 1, 2, 3, 4, 5]);
			_pool.poolSize = 6;
			_pool.itemsAddedAt(0, 6);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5], 0)
			);

			// set first visible index to 5

			_pool.firstVisibleIndex = 5;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([5], 5)
			);

			// add two items at end
			// 0, 1, 2, 3, 4, 5, 6, 7

			_listView.addItemsAt(6, [6, 7]);
			_pool.itemsAddedAt(6, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([5, 6, 7], 5)
			);

			// remove the first 6 items
			// 6, 7

			_listView.removeItemsAt(0, 6);
			_pool.itemsRemovedAt(0, 6);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([6, 7], 0)
			);

			// remove the first 2 items

			_listView.removeItemsAt(0, 2);
			_pool.itemsRemovedAt(0, 2);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			// set first visible index to 4

			_pool.firstVisibleIndex = 4;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			// add 6 items at 0
			// 0, 1, 2, 3, 4, 5

			_listView.addItemsAt(0, [0, 1, 2, 3, 4, 5]);
			_pool.itemsAddedAt(0, 6);
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([], 0)
			);

			// set first visible index to 4

			_pool.firstVisibleIndex = 0;
			_pool.refresh();

			assertNull(
				"List shows the right items",
				validateVisibleRenderers([0, 1, 2, 3, 4, 5], 0)
			);

		}


	}
}
