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
	import flash.events.Event;

	/**
	 * ListItemRenderer event.
	 * 
	 * <p>A ListItemRendererEvent is a ListView internal event and only available
	 * to IListItemRenderers and their children. The ListItemRendererEvent is
	 * dispatched by the ListView in the scope of the renderer.</p>
	 * 
	 * <listing>
		asdpc_internal function notifyRollOverRendererAt_internal(listIndex : uint) : void {
			var renderer : IListItemRenderer = getRendererAt(listIndex);
			if (!renderer) return; // renderer might be removed beforehand
			renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.ROLL_OVER));
		}
	 * </listing>
	 * 
	 * @author jes 14.12.2009
	 */
	public class ListItemRendererEvent extends Event {

		/**
		 * Event type ROLL_OVER
		 * 
		 * <p>Dispatched, if the mouse enters the renderer area.</p>
		 * 
		 * @eventType listItemRenderer_rollOver
		 */
		public static const ROLL_OVER : String = "listItemRenderer_rollOver";

		/**
		 * Event type ROLL_OUT
		 * 
		 * <p>Dispatched, if the mouse leaves the renderer area.</p>
		 * 
		 * @eventType listItemRenderer_rollOut
		 */
		public static const ROLL_OUT : String = "listItemRenderer_rollOut";

		/**
		 * Event type SELECTION_CHANGED
		 * 
		 * <p>Dispatched, if the currently assigned item has been selected or deselected.</p>
		 * 
		 * @eventType listItemRenderer_selectionChanged
		 */
		public static const SELECTION_CHANGED : String = "listItemRenderer_selectionChanged";
		
		/**
		 * Event type DATA_CHANGED
		 * 
		 * <p>Dispatched, if the renderer was assigned a new item.</p>
		 * 
		 * @eventType listItemRenderer_dataChanged
		 */
		public static const DATA_CHANGED : String = "listItemRenderer_dataChanged";

		/**
		 * Event type DATA_PROPERTY_CHANGED
		 * 
		 * <p>Dispatched, if properties of the assigned item have changed.</p>
		 * 
		 * @eventType listItemRenderer_dataPropertyChanged
		 */
		public static const DATA_PROPERTY_CHANGED : String = "listItemRenderer_dataPropertyChanged";

		/**
		 * Event type LIST_INDEX_CHANGED
		 * 
		 * <p>Dispatched, if the current item's list index has changed.</p>
		 * 
		 * @eventType listItemRenderer_listIndexChanged
		 */
		public static const LIST_INDEX_CHANGED : String = "listItemRenderer_listIndexChanged";

		/**
		 * Event type VISIBILITY_CHANGED
		 * 
		 * <p>Dispatched, if a renderer became hidden or visible as a result of
		 * scrolling, insertion or deletion operations.</p>
		 * 
		 * @eventType listItemRenderer_visibilityChanged
		 */
		public static const VISIBILITY_CHANGED : String = "listItemRenderer_visibilityChanged";

		/**
		 * ListItemRendererEvent constructor.
		 * 
		 * @param type The event type.
		 */
		public function ListItemRendererEvent(type : String) {
			super(type);
		}

	}
}
