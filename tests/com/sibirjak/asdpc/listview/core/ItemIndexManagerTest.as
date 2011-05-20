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

	/**
	 * @author jes 11.12.2009
	 */
	public class ItemIndexManagerTest extends TestCase {

		private var _manager : ItemIndexManager;

		/**
		 * test neutralization
		 */

		override public function setUp() : void {
			_manager = new ItemIndexManager();
		}

		override public function tearDown() : void {
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

		/**
		 * Test initial state
		 */

		public function test_Instantiated() : void {
			assertTrue("Manager instantiated", _manager is ItemIndexManager);
		}

		public function test_InitiallyNoItemsBefore() : void {
			
			assertEquals(
				"No open items",
				0,
				_manager.size
			);
			
			assertTrue(
				"Manager contains the right items",
				arraysEqual([], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(0)
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(1)
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(3)
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(100)
			);
		}

		/**
		 * Test opening of items
		 */

		public function test_itemOpened() : void {
			
			assertEquals(
				"No open items",
				0,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([], _manager.toArray())
			);

			/*
			 * Open item
			 */

			_manager.addIndex(10);
			
			assertEquals(
				"1 open item",
				1,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([10], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(9)
			);
			
			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(10)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(11)
			);

			/*
			 * Open second item
			 */

			_manager.addIndex(11);

			assertEquals(
				"2 open items",
				2,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([10, 11], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(10)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(11)
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(12)
			);

			/*
			 * Open same item many times does not have impact
			 */
			
			_manager.addIndex(11);
			_manager.addIndex(11);
			_manager.addIndex(11);

			assertEquals(
				"2 open items",
				2,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([10, 11], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(10)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(11)
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(12)
			);

		}

		public function test_itemOpened2() : void {
			
			assertEquals(
				"No open items",
				0,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([], _manager.toArray())
			);

			/*
			 * Open item
			 */

			_manager.addIndex(0);
			
			assertEquals(
				"1 open item",
				1,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([0], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(0)
			);
			
			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(1)
			);
		}

		/**
		 * Test closing of items
		 */

		public function test_itemClosed() : void {
			
			_manager.addIndex(6);
			_manager.addIndex(4);
			_manager.addIndex(2);

			assertEquals(
				"3 open items",
				3,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([2, 4, 6], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(4)
			);

			assertEquals(
				"3 open items before",
				3,
				_manager.numItemsBefore(7)
			);
			
			/*
			 * Close wrong item without impact
			 */

			_manager.removeIndex(5);
			_manager.removeIndex(1);
			_manager.removeIndex(3);

			assertEquals(
				"3 open items",
				3,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([2, 4, 6], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(4)
			);

			assertEquals(
				"3 open items before",
				3,
				_manager.numItemsBefore(7)
			);

			/*
			 * Close item
			 */

			_manager.removeIndex(2);

			assertEquals(
				"2 open items",
				2,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([4, 6], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(4)
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(7)
			);

			/*
			 * Close another item
			 */

			_manager.removeIndex(6);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([4], _manager.toArray())
			);

			assertEquals(
				"1 open item",
				1,
				_manager.size
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(4)
			);

			assertEquals(
				"1 open items before",
				1,
				_manager.numItemsBefore(7)
			);

		}
		
		/*
		 * Adding of items
		 */

		public function test_itemAdded() : void {
			
			_manager.addIndex(4);
			_manager.addIndex(2);
			_manager.addIndex(6);

			assertEquals(
				"3 open items",
				3,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([2, 4, 6], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(4)
			);

			assertEquals(
				"3 open items before",
				3,
				_manager.numItemsBefore(7)
			);
			
			/*
			 * Add item
			 */

			_manager.itemsAddedAt(2, 1);
			
			assertEquals(
				"3 open items",
				3,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([3, 5, 7], _manager.toArray())
			);
			
			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(4)
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(7)
			);

			/*
			 * Add items
			 */

			_manager.itemsAddedAt(4, 2);
			
			assertEquals(
				"3 open items",
				3,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([3, 7, 9], _manager.toArray())
			);
			
			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(7)
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(9)
			);

			assertEquals(
				"3 open items before",
				3,
				_manager.numItemsBefore(10)
			);

			/*
			 * Add items
			 */

			_manager.itemsAddedAt(10, 3);
			
			assertEquals(
				"3 open items",
				3,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([3, 7, 9], _manager.toArray())
			);
			
			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(7)
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(9)
			);

			assertEquals(
				"3 open items before",
				3,
				_manager.numItemsBefore(10)
			);

			/*
			 * Add items
			 */

			_manager.itemsAddedAt(9, 3);
			
			assertEquals(
				"3 open items",
				3,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([3, 7, 12], _manager.toArray())
			);
			
			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(7)
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(9)
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(12)
			);

			assertEquals(
				"3 open items before",
				3,
				_manager.numItemsBefore(13)
			);
		}
			
		/*
		 * Adding of items
		 */

		public function test_itemRemoved() : void {
			
			_manager.addIndex(2);
			_manager.addIndex(10);
			_manager.addIndex(8);
			_manager.addIndex(6);
			_manager.addIndex(4);

			assertEquals(
				"5 open items",
				5,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([2, 4, 6, 8, 10], _manager.toArray())
			);

			assertEquals(
				"No open items before",
				0,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"3 open item before",
				3,
				_manager.numItemsBefore(7)
			);

			assertEquals(
				"4 open items before",
				4,
				_manager.numItemsBefore(10)
			);
			
			/*
			 * Remove item
			 */

			_manager.itemsRemovedAt(0, 1);

			assertEquals(
				"5 open items",
				5,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([1, 3, 5, 7, 9], _manager.toArray())
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"3 open item before",
				3,
				_manager.numItemsBefore(7)
			);

			assertEquals(
				"5 open items before",
				5,
				_manager.numItemsBefore(10)
			);

			/*
			 * Remove item
			 */

			_manager.itemsRemovedAt(0, 1);

			assertEquals(
				"5 open items",
				5,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([0, 2, 4, 6, 8], _manager.toArray())
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"4 open item before",
				4,
				_manager.numItemsBefore(7)
			);

			assertEquals(
				"5 open items before",
				5,
				_manager.numItemsBefore(10)
			);

			/*
			 * Remove item
			 */

			_manager.itemsRemovedAt(0, 3);

			assertEquals(
				"3 open items",
				3,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([1, 3, 5], _manager.toArray())
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"3 open item before",
				3,
				_manager.numItemsBefore(7)
			);


			/*
			 * Remove item
			 */

			_manager.itemsRemovedAt(3, 1);

			assertEquals(
				"2 open items",
				2,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([1, 4], _manager.toArray())
			);

			assertEquals(
				"1 open item before",
				1,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"2 open item before",
				2,
				_manager.numItemsBefore(7)
			);

			/*
			 * Open items
			 */

			_manager.addIndex(6);
			_manager.addIndex(3);
			_manager.addIndex(10);
			_manager.addIndex(0);
			_manager.addIndex(2);

			assertEquals(
				"7 open items",
				7,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([0, 1, 2, 3, 4, 6, 10], _manager.toArray())
			);

			assertEquals(
				"2 open items before",
				2,
				_manager.numItemsBefore(2)
			);

			assertEquals(
				"6 open item before",
				6,
				_manager.numItemsBefore(7)
			);

			assertEquals(
				"7 open item before",
				7,
				_manager.numItemsBefore(11)
			);

			/*
			 * Remove item
			 */

			_manager.itemsRemovedAt(5, 5);

			assertEquals(
				"6 open items",
				6,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([0, 1, 2, 3, 4, 5], _manager.toArray())
			);

			/*
			 * Remove item
			 */

			_manager.itemsRemovedAt(4, 5);

			assertEquals(
				"4 open items",
				4,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([0, 1, 2, 3], _manager.toArray())
			);

			/*
			 * Remove item
			 */

			_manager.itemsRemovedAt(1, 2);

			assertEquals(
				"2 open items",
				2,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([0, 1], _manager.toArray())
			);

			/*
			 * Remove item
			 */

			_manager.itemsRemovedAt(0, 10);

			assertEquals(
				"0 open items",
				0,
				_manager.size
			);

			assertTrue(
				"Manager contains the right items",
				arraysEqual([], _manager.toArray())
			);

		}
			

	}
}
