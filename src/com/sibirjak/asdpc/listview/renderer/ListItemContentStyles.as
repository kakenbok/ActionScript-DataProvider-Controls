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

	/**
	 * ListItemContent style properties.
	 * 
	 * @author jes 23.11.2009
	 */
	public class ListItemContentStyles {

		/**
		 * Style property defining the label function.
		 * 
		 * <p>The label function accepts a ListItemData object and returns a String value.</p>
		 * 
		 * <listing>
				function labelFunction(data : ListItemData) : String {
					return Person(data.item).name;
				}
		 * </listing>
		 */
		public const labelFunction : String = "listItemContent_labelFunction";

		/**
		 * Style property defining the default label styles.
		 * 
		 * <listing>
				listView.setStyle(ListItemContent.style.labelStyles, [
					Label.style.color, 0xFF0000,
					Label.style.bold, false,
					Label.style.size, 10
				]);
		 * </listing>
		 */
		public const labelStyles : String = "listItemContent_labelStyles";

		/**
		 * Style property defining the label styles for the roll over state.
		 * 
		 * <listing>
				listView.setStyle(ListItemContent.style.overLabelStyles, [
					Label.style.color, 0x0000FF,
					Label.style.bold, true,
					Label.style.size, 10
				]);
		 * </listing>
		 */
		public const overLabelStyles : String = "listItemContent_overLabelStyles";

		/**
		 * Style property defining the label styles for the selected state.
		 * 
		 * <listing>
				listView.setStyle(ListItemContent.style.selectedLabelStyles, [
					Label.style.color, 0x00FF00,
					Label.style.bold, true,
					Label.style.size, 12
				]);
		 * </listing>
		 */
		public const selectedLabelStyles : String = "listItemContent_selectedLabelStyles";

		/**
		 * Style property defining the appearance of a tooltip over the item.
		 * 
		 * <p>The tooltip is only shown if the text has been chopped to fit into
		 * the label dimensions.</p>
		 */
		public const toolTips : String = "listItemContent_toolTips";
	}
}
