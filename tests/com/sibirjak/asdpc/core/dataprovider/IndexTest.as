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
package com.sibirjak.asdpc.core.dataprovider {
	import flexunit.framework.TestCase;

	/**
	 * @author jes 20.10.2009
	 */
	public class IndexTest extends TestCase {
		
		private var _arraySet : Index;

		/**
		 * test neutralization
		 */

		override public function setUp() : void {
			_arraySet = new Index();
		}

		override public function tearDown() : void {
		}
		
		/**
		 * Helper
		 */
		 
		private function validateItems(expectedItems : Array) : void {

			assertEquals(
				"Num expected items equals num items",
				expectedItems.length,
				_arraySet.size
			);
			
			for (var i : uint = 0; i < expectedItems.length; i++) {
				assertEquals(
					"Item is the item added",
					expectedItems[i],
					_arraySet.itemAt(i)
				);

				assertEquals(
					"Index of item is valid",
					i,
					_arraySet.indexOf(expectedItems[i])
				);
				
			}

			for (i = 1; i <= 10; i++) {
				
				if (expectedItems.indexOf(i) > -1) continue;
				
				assertEquals(
					"Index of " + i + " is -1 " + _arraySet.indexOf(i),
					-1,
					_arraySet.indexOf(i)
				);
			}

		}

		/**
		 * Adding
		 */
		 
		public function testAddItemsAtEnd() : void {
			
			_arraySet.addItemsAfter(undefined, [1, 2]);
			validateItems([1, 2]);
			
			_arraySet.addItemsAfter(2, [3, 4, 5]);
			validateItems([1, 2, 3, 4, 5]);

			_arraySet.addItemsAfter(5, [6]);
			validateItems([1, 2, 3, 4, 5, 6]);

		}

		public function testAddItemsAtEnd2() : void {
			
			_arraySet.addItemsAtEnd([1, 2]);
			validateItems([1, 2]);
			
			_arraySet.addItemsAtEnd([3, 4, 5]);
			validateItems([1, 2, 3, 4, 5]);

			_arraySet.addItemsAtEnd([6]);
			validateItems([1, 2, 3, 4, 5, 6]);

		}

		public function testAddItemsAtStart() : void {
			
			_arraySet.addItemsAfter(undefined, [1, 2]);
			validateItems([1, 2]);
			
			_arraySet.addItemsAfter(undefined, [3, 4, 5]);
			validateItems([3, 4, 5, 1, 2]);

			_arraySet.addItemsAfter(undefined, [6]);
			validateItems([6, 3, 4, 5, 1, 2]);

		}

		public function testAddItemsAtStart2() : void {
			
			_arraySet.addItemsAtStart([1, 2]);
			validateItems([1, 2]);
			
			_arraySet.addItemsAtStart([3, 4, 5]);
			validateItems([3, 4, 5, 1, 2]);

			_arraySet.addItemsAtStart([6]);
			validateItems([6, 3, 4, 5, 1, 2]);

		}

		public function testAddItemsInBetween() : void {
			
			_arraySet.addItemsAfter(undefined, [1, 2]);
			validateItems([1, 2]);
			
			_arraySet.addItemsAfter(1, [3, 4, 5]);
			validateItems([1, 3, 4, 5, 2]);

			_arraySet.addItemsAfter(4, [6]);
			validateItems([1, 3, 4, 6, 5, 2]);

		}

		public function testAddItemsAtMixedPosition() : void {
			
			_arraySet.addItemsAfter(undefined, [1]);
			validateItems([1]);
			
			_arraySet.addItemsAfter(1, [2, 3]);
			validateItems([1, 2, 3]);

			_arraySet.addItemsAtStart([4, 5, 6]);
			validateItems([4, 5, 6, 1, 2, 3]);

			_arraySet.addItemsAfter(3, [7]);
			validateItems([4, 5, 6, 1, 2, 3, 7]);

			_arraySet.addItemsAfter(1, [8]);
			validateItems([4, 5, 6, 1, 8, 2, 3, 7]);

			_arraySet.addItemsAfter(undefined, [9]);
			validateItems([9, 4, 5, 6, 1, 8, 2, 3, 7]);

			_arraySet.addItemsAfter(5, [10, 11]);
			validateItems([9, 4, 5, 10, 11, 6, 1, 8, 2, 3, 7]);

		}

		/**
		 * Removing
		 */

		public function testRemoveItemsAtEnd() : void {
			
			_arraySet.addItemsAfter(undefined, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			validateItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			
			_arraySet.removeItemsAfter(9, 1);
			validateItems([1, 2, 3, 4, 5, 6, 7, 8, 9]);

			_arraySet.removeItemsAfter(7, 2);
			validateItems([1, 2, 3, 4, 5, 6, 7]);

			_arraySet.removeItemsAfter(5, 4);
			validateItems([1, 2, 3, 4, 5]);

			_arraySet.removeItemsAfter(undefined, 5);
			validateItems([]);

		}

		public function testRemoveItemsAtEnd2() : void {
			
			_arraySet.addItemsAtStart([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			validateItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			
			_arraySet.removeItemsAtEnd(1);
			validateItems([1, 2, 3, 4, 5, 6, 7, 8, 9]);

			_arraySet.removeItemsAtEnd(2);
			validateItems([1, 2, 3, 4, 5, 6, 7]);

			_arraySet.removeItemsAtEnd(3);
			validateItems([1, 2, 3, 4]);

			_arraySet.removeItemsAtEnd(5);
			validateItems([]);

		}

		public function testRemoveItemsAtStart() : void {
			
			_arraySet.addItemsAfter(undefined, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			validateItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			
			_arraySet.removeItemsAfter(undefined, 1);
			validateItems([2, 3, 4, 5, 6, 7, 8, 9, 10]);

			_arraySet.removeItemsAfter(undefined, 2);
			validateItems([4, 5, 6, 7, 8, 9, 10]);

			_arraySet.removeItemsAfter(undefined, 4);
			validateItems([8, 9, 10]);

			_arraySet.removeItemsAfter(undefined, 5);
			validateItems([]);
			
		}

		public function testRemoveItemsAtStart2() : void {
			
			_arraySet.addItemsAfter(undefined, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			validateItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			
			_arraySet.removeItemsAtStart( 1);
			validateItems([2, 3, 4, 5, 6, 7, 8, 9, 10]);

			_arraySet.removeItemsAtStart( 2);
			validateItems([4, 5, 6, 7, 8, 9, 10]);

			_arraySet.removeItemsAtStart( 4);
			validateItems([8, 9, 10]);

			_arraySet.removeItemsAtStart( 5);
			validateItems([]);
			
		}

		public function testRemoveItemsInBetween() : void {
			
			_arraySet.addItemsAfter(undefined, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			validateItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
			
			_arraySet.removeItemsAfter(6, 3);
			validateItems([1, 2, 3, 4, 5, 6, 10]);

			_arraySet.removeItemsAfter(10, 3);
			validateItems([1, 2, 3, 4, 5, 6, 10]);

			_arraySet.removeItemsAfter(2, 2);
			validateItems([1, 2, 5, 6, 10]);

			_arraySet.removeItemsAfter(6, 1);
			validateItems([1, 2, 5, 6]);

			_arraySet.removeItemsAfter(1, 15);
			validateItems([1]);
			
			_arraySet.removeItemsAfter(undefined, 15);
			validateItems([]);

		}

		/**
		 * Adding and Removing
		 */

		public function testAddingAndRemoving() : void {
			
			_arraySet.addItemsAfter(undefined, [1]);
			validateItems([1]);
			
			_arraySet.removeItemsAfter(undefined, 1);
			validateItems([]);

			_arraySet.addItemsAtStart([1, 2]);
			validateItems([1, 2]);

			_arraySet.addItemsAfter(1, [3, 4, 5, 6]);
			validateItems([1, 3, 4, 5, 6, 2]);

			_arraySet.removeItemsAfter(3, 2);
			validateItems([1, 3, 6, 2]);

			_arraySet.removeItemsAfter(3, 2);
			validateItems([1, 3]);

			_arraySet.addItemsAfter(3, [4, 5, 6, 7, 8]);
			validateItems([1, 3, 4, 5, 6, 7, 8]);

			_arraySet.addItemsAfter(7, [9]);
			validateItems([1, 3, 4, 5, 6, 7, 9, 8]);

			_arraySet.removeItemsAtStart(3);
			validateItems([5, 6, 7, 9, 8]);

			_arraySet.removeItemsAfter(5, 30);
			validateItems([5]);

			_arraySet.addItemsAtEnd([1, 2, 3, 4]);
			validateItems([5, 1, 2, 3, 4]);

			_arraySet.removeItemsAfter(undefined, 30);
			validateItems([]);
		}

	}
}
