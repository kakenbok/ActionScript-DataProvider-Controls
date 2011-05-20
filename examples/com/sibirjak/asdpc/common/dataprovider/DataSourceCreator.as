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
package com.sibirjak.asdpc.common.dataprovider {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author jes 04.11.2009
	 */
	public class DataSourceCreator {
		
		private static var _count : uint = 1;

		public static function createItem(itemClass : Class, name : String, category : String) : IItem {
			var item : IItem = new itemClass();
			item.name = name;
			item.category = category;
			
			return item;
		}

		public static function createChildItem(parentItem : IItem) : IItem {
			var item : IItem = new (getDefinitionByName(getQualifiedClassName(parentItem)))();
			item.name = parentItem.name + "." + parentItem.i_nextChildIndex;
			return item;
		}

		public static function createList(itemClass : Class, maxNumChildren : uint) : IItem {
			var item : IItem = createItem(itemClass, _count++ + " Item", "");
			
			var numChildren : uint = Math.round(Math.random() * maxNumChildren);
			
			for (var i : int = 0; i < numChildren; i++) {
				item.i_addItemAtEnd(
					createItem(itemClass, item.name + " " + item.i_nextChildIndex, "")
				);
			}

			return item;
		}
		
		public static function createTree(itemClass : Class, depth : uint, maxNumChildren : uint = 0, parentItem : IItem = null) : IItem {
			var item : IItem = parentItem;
			if (!item) {
				item = createItem(itemClass, _count++ + " Node", "");
			}
			
			var numChildren : uint = maxNumChildren ? Math.round(Math.random() * maxNumChildren) : 5;
			var newItem : IItem;
			
			for (var i : int = 0; i < numChildren; i++) {
				
				newItem = createChildItem(item);
				item.i_addItemAtEnd(newItem);
				
				if (depth > 1) {
					createTree(itemClass, depth - 1, maxNumChildren, newItem);
				}
				
			}
			
			return item;
		}

		public static function createMixedTree(depth : uint, maxNumChildren : uint, parentItem : IItem = null) : IItem {
			
			var classes : Array = [ArrayListItem, LinkedMapItem, LinkedSetItem];
			
			var itemClass : Class = classes[Math.round(Math.random() * 2)];
			
			var item : IItem = parentItem;
			if (!item) {
				item = createItem(itemClass, _count++ + " Item", "");
			}
			
			var numChildren : uint = Math.round(Math.random() * maxNumChildren);
			var newItem : IItem;
			
			for (var i : int = 0; i < numChildren; i++) {
				
				itemClass = classes[Math.round(Math.random() * 2)];

				newItem = new itemClass();
				newItem.name = item.name + "." + item.i_nextChildIndex;
				item.i_addItemAtEnd(newItem);
				
				if (depth > 1) {
					createMixedTree(depth - 1, maxNumChildren, newItem);
				}
				
			}
			
			return item;
		}

	}
}
