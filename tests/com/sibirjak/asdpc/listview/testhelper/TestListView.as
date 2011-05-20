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
package com.sibirjak.asdpc.listview.testhelper {
	import com.sibirjak.asdpc.listview.ListView;

	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.ISortedList;

	import flash.display.Sprite;

	/**
	 * @author jes 28.10.2009
	 */
	public class TestListView extends ListView {

		private function get _itemContainer() : Sprite {
			return getChildAt(1) as Sprite;
		}

		public function getVisibleItems() : Array {
			var renderers : ISortedList = new SortedList(new YComparator());
			for (var i : uint = 0; i < _itemContainer.numChildren; i++) {
				if (_itemContainer.getChildAt(i).visible) {
					renderers.add(_itemContainer.getChildAt(i));
				}
			}
			return renderers.toArray();
		}

		override public function scrollToItemAt(listIndex : uint) : void {
			super.scrollToItemAt(listIndex);
			validate();
		}

		override protected function styleChanged(property : String, value : *) : void {
			super.styleChanged(property, value);
			validate();
		}

		public function validate() : void {
			validateNow(); // calls update
		}

	}
}
