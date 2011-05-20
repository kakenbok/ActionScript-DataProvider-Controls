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
package com.sibirjak.asdpc.listview.renderer {
	import com.sibirjak.asdpc.core.IDisplayObjectContainer;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;

	/**
	 * ListItemContent interface.
	 * 
	 * <p>The content area of a default ListItemRenderer is encapsulated into
	 * a display object of type IListItemContent, wich makes it very easy to
	 * set up custom content renderers by keeping the main ListItemRenderer
	 * functionality.</p>
	 * 
	 * <p>This interface declares the necessary operations a content
	 * renderer should implement. A content renderer can be a display
	 * object of any type such as a View or even a plain Sprite.</p>
	 * 
	 * @author jes 23.11.2009
	 */
	public interface IListItemContent extends IDisplayObjectContainer {
		
		/**
		 * Sets the containing list item renderer.
		 * 
		 * <p>If the ListItemRenderer is set, the content renderer may
		 * listen to the ListItemRenderer events to be notified for and
		 * reflect item state changes.</p>
		 * 
		 * <listing>
			public function set listItemRenderer(listItemRenderer : IListItemRenderer) : void {
				_listItemRenderer = listItemRenderer;
				_listItemRenderer.addEventListener(ListItemRendererEvent.SELECTION_CHANGED, selectionChangedHandler);
			}
	
			private function selectionChangedHandler(event : ListItemRendererEvent) : void {
				if (_listItemRenderer.data.selected) {
					_label.setStyle(Label.style.underline, true);
				} else {
					_label.setStyle(Label.style.underline, false);
				}
			}
		 * </listing>
		 */
		function set listItemRenderer(listItemRenderer : IListItemRenderer) : void;

		/**
		 * Sets the content dimensions.
		 * 
		 * <p>After setting the dimensions the content renderer should
		 * resize all of its content.</p>
		 * 
		 * @param width The content width.
		 * @param height The content height.
		 */
		function setSize(width : int, height : int) : void;

		/**
		 * Draws the content initially.
		 * 
		 * <p>This method is invoked only once right after the renderer
		 * instance has been created and the dimensions have been set.</p> 
		 */
		function drawContent() : void;

	}
}
