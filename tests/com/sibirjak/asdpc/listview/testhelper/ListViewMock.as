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
	import com.sibirjak.asdpc.core.Container;
	import com.sibirjak.asdpc.core.asdpc_internal;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.core.ListItemRendererData;

	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.SortedList;
	import org.as3commons.collections.framework.ISortedList;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	use namespace asdpc_internal;

	/**
	 * @author jes 26.10.2009
	 */
	public class ListViewMock extends ListView {
		
		private var _list : ArrayList;
		private var _itemContainer : Sprite;
		
		public function ListViewMock(numItems : uint) {
			
			_list = new ArrayList();
			for (var i : uint = 0; i < numItems; i++) {
				_list.add(i);
			}
			
			dataSource = _list;
			
			_itemContainer = new Container();
		}

		/*
		 * Mocking methods
		 */
		
		asdpc_internal override function createNewListItemRenderer_internal(listIndex : uint) : IListItemRenderer {
			var renderer : IListItemRenderer = new ListItemRendererMock();
			renderer.data = createListItemRendererData(listIndex);
			
			_itemContainer.addChild(DisplayObject(renderer));
			renderer.drawListItem();

			return renderer;
		}

		asdpc_internal override function updateListItemRendererListIndex_internal(renderer : IListItemRenderer, listIndex : uint) : void {
			renderer.data.listItemData.setListIndex_internal(listIndex);
			renderer.data.listItemData.setItemIndex_internal(listIndex);
		}

		asdpc_internal override function setListItemRendererPosition_internal(renderer : IListItemRenderer, visibleIndex : uint) : void {
			var itemPosition : uint = visibleIndex * 10;
			renderer.y = itemPosition;
		}

		asdpc_internal override function removeListItemRenderer_internal(renderer : IListItemRenderer) : void {
			_itemContainer.removeChild(DisplayObject(renderer));
		}

		override protected function createListItemRendererData(listIndex : uint) : ListItemRendererData {
			var itemData : ListItemData = new ListItemData();
			itemData.setItem_internal(_list.itemAt(listIndex));
			itemData.setListIndex_internal(listIndex);

			var data : ListItemRendererData = new ListItemRendererData();
			data.setListItemData_internal(itemData);
			return data;
		}

		/*
		 * Test interface
		 */

		public function getVisibleRenderers() : Array {
			var renderers : ISortedList = new SortedList(new YComparator());
			for (var i : uint = 0; i < _itemContainer.numChildren; i++) {
				if (_itemContainer.getChildAt(i).visible) {
					renderers.add(_itemContainer.getChildAt(i));
				}
			}
			return renderers.toArray();
		}

		public function getCreatedRenderers() : Array {
			var renderers : Array = new Array();
			for (var i : uint = 0; i < _itemContainer.numChildren; i++) {
				renderers.push(_itemContainer.getChildAt(i));
			}
			return renderers;
		}
		
		public function addItemsAt(index : uint, items : Array) : void {
			_list.addAllAt(index, items);
		}

		public function removeItemsAt(index : uint, numItems : uint) : void {
			_list.removeAllAt(index, numItems);
		}

		public function clear() : void {
			_list.clear();
		}

	}
}
