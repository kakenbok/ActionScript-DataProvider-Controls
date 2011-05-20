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
package com.sibirjak.asdpc.treeview.testhelper {
	import org.as3commons.collections.fx.ArrayListFx;

	/**
	 * @author jes 14.10.2009
	 */
	public class DataSourceCreator {

		public static function createItemArray(key : String, numChildren : uint) : Array {
			
			/*
			 * 		Item 1
			 * 		Item 2
			 * 		Item 3
			 */

			var array : Array = new Array();
			
			for (var i : uint = 1; i <= numChildren; i++) {
				array.push(new ArrayListItem(key + " " + i));
			}
			
			return array;
			
		}

		public static function getSimpleDataSource(key : String, numChildren : uint) : ArrayListFx {
			
			/*
			 * Item Root
			 * 		Item 1
			 * 		Item 2
			 * 		Item 3
			 */

			var dataSource : ArrayListItem = new ArrayListItem(key + " Root");
			
			for (var i : uint = 1; i <= numChildren; i++) {
				dataSource.add(new ArrayListItem(key + " " + i));
			}
			
			return dataSource;
			
		}

		public static function getComplexDataSourceItem(key : String) : ArrayListFx {
			var item : ArrayListItem = new ArrayListItem(key);
			item.add(new ArrayListItem(key + " 1"));
			return item;
		}

		public static function getComplexDataSource(key : String) : ArrayListFx {
			
			/*
			 * Item Root
			 * 		Item 1
			 * 			Item 1 1
			 * 			Item 1 2
			 * 				Item 1 2 1
			 * 				Item 1 2 2
			 * 			Item 1 3
			 * 		Item 2
			 * 			Item 2 1
			 * 				Item 2 1 1
			 * 			Item 2 2
			 * 			Item 2 3
			 * 		Item 3
			 * 			Item 3 1
			 * 			Item 3 2
			 * 				Item 3 2 1
			 * 				Item 3 2 2
			 * 				Item 3 2 3
			 */

			// Item Root
			
			var dataSource : ArrayListItem = new ArrayListItem(key + " Root");

			for (var i : uint = 1; i <= 3; i++) {
				dataSource.add(new ArrayListItem(key + " " + i));
			}
			
			// Item 1

			var item1 : ArrayListItem = dataSource.first;
			for (i = 1; i <= 3; i++) {
				item1.add(new ArrayListItem(item1.name + " " + i));
			}
				
			// Item 1 2

			var item1_2 : ArrayListItem = item1.itemAt(1);
			for (i = 1; i <= 2; i++) {
				item1_2.add(new ArrayListItem(item1_2.name + " " + i));
			}
	
			// Item 2

			var item2 : ArrayListItem = dataSource.itemAt(1);
			for (i = 1; i <= 3; i++) {
				item2.add(new ArrayListItem(item2.name + " " + i));
			}
			
			// Item 2 1

			var item2_1 : ArrayListItem = item2.first;
			item2_1.add(new ArrayListItem(item2_1.name + " 1"));

			// Item 3

			var item3 : ArrayListItem = dataSource.itemAt(2);
			for (i = 1; i <= 2; i++) {
				item3.add(new ArrayListItem(item3.name + " " + i));
			}
			
			// Item 3 2

			var item3_2 : ArrayListItem = item3.itemAt(1);
			for (i = 1; i <= 3; i++) {
				item3_2.add(new ArrayListItem(item3_2.name + " " + i));
			}
			
			//trace(CollectionUtils.dumpAsString(dataSource));

			return dataSource;
			
		}

	}
}
