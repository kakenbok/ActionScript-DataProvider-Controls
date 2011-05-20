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
	import com.sibirjak.asdpc.core.IDisplayObjectContainer;

	/**
	 * ListItemRenderer interface.
	 * 
	 * <p>This interface declares the necessary operations a list item
	 * renderer should implement. A list item renderer can be a display
	 * object of any type such as a View or even a plain Sprite.</p>
	 * 
	 * <p>A ListItemRenderer represents the data of a particular item out of
	 * the list's data provider. For performance reasons renderers are pooled
	 * and reused. E.g. a list with a height of 200 and an item height of 20
	 * maintains only 10 renderers, even if the data provider contains more
	 * items. When scrolling the list, renderers with items that become invisible
	 * receive new data and will be repositioned to the top or end of the
	 * display list of renderers.</p>
	 * 
	 * <strong>Example</strong>
	 * 
	 * <p>The list's data provider contains 8 items. The list is configured
	 * to display 3 items (height = 90, itemheight = 30). The list is scrolled
	 * to the item at 2 (item3).</p> 
	 * 
	 * <listing>
		item1
		item2
		----------------
		item3 - Renderer1
		item4 - Renderer2
		item5 - Renderer3
		----------------
		item6
		item7
		item8
	 * </listing>
	 * 
	 * <p>The user scrolls to the item at 3 (item4). The renderer displaying
	 * the item at 2 (item3) is removed from the renderer list and parked.</p>
	 * 
	 * <listing>
		item1
		item2
		item3
		----------------
		item4 - Renderer2
		item5 - Renderer3
		item6
		----------------
		item7
		item8

		Renderer1 parked
	 * </listing>
	 * 
	 * <p>The parked renderer now receives the data for the item at 5 (item6)
	 * and gets a new position.</p>
	 * 
	 * <listing>
		item1
		item2
		item3
		----------------
		item4 - Renderer2
		item5 - Renderer3
		item6 - Renderer1
		----------------
		item7
		item8
	 * </listing>
	 * 
	 * <strong>Note to list item mouse events</strong>
	 * 
	 * <p>By default a ListView does not recognise mouse events of ListItemRenderer
	 * instances. The renderer is supposed to notify the list about such an event.
	 * This approach gives more control over events to the developer of a custom
	 * list item renderer.</p>
	 * 
	 * <listing>
		// in MyRenderer

		public function MyRenderer() {
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		}

		private function rollOverHandler(event : MouseEvent) : void {
			_listItemRendererData.notifyRollOver();
		}
		
		// in ListView

		asdpc_internal function notifyRollOverRendererAt_internal(listIndex : uint) : void {
			var renderer : IListItemRenderer = getRendererAt(listIndex);
			if (!renderer) return; // renderer might be removed beforehand
			renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.ROLL_OVER));
			dispatchEvent(createListItemEvent(ListItemEvent.ROLL_OVER, renderer.data.listIndex));
		}
	 * </listing>
	 * 
	 * @author jes 08.07.2009
	 */
	public interface IListItemRenderer extends IDisplayObjectContainer {

		/*
		 * Data related
		 */

		/**
		 * @private
		 */
		function set data(data : ListItemRendererData) : void;

		/**
		 * Sets or gets the list item renderer data.
		 * 
		 * <p>Data will be set initially or as a result of scrolling
		 * operations throughout the entire listView life cycle.</p>
		 * 
		 * <p>The concrete renderer is supposed to accept and display
		 * new data at any time.</p>
		 */
		function get data() : ListItemRendererData;
		
		/*
		 * Display related
		 */

		/**
		 * Sets the renderer dimensions.
		 * 
		 * <p>After setting the dimensions the renderer should resize
		 * its content.</p>
		 * 
		 * @param width The item width.
		 * @param height The item height.
		 */
		function setSize(width : int, height : int) : void;

		/**
		 * Sets the renderer dimensions for the selected state.
		 * 
		 * @param width The selected item width.
		 * @param height The selected item height.
		 */
		function setSelectedSize(width : int, height : int) : void;

		/**
		 * Draws the list item initially.
		 * 
		 * <p>This method is invoked only once right after the renderer
		 * instance has been created and the dimensions have been set.</p> 
		 */
		function drawListItem() : void;

	}
}
