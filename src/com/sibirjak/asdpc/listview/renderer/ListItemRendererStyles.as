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
	 * ListItemRenderer style properties.
	 * 
	 * @author jes 10.11.2009
	 */
	public class ListItemRendererStyles {

		/* General */

		/**
		 * Style property defining the content renderer.
		 */
		public const contentRenderer : String = "listItemRenderer_contentRenderer";

		/**
		 * Style property defining the content renderer additional visible in the selected state.
		 */
		public const selectedItemContentRenderer : String = "listItemRenderer_selectedItemContentRenderer";

		/* Icon */

		/**
		 * Style property defining the indent of the content.
		 */
		public const indent : String = "listItemRenderer_indent";

		/**
		 * Style property defining the icon visibility.
		 */
		public const icon : String = "listItemRenderer_icon";

		/**
		 * Style property defining the space between icon and content.
		 */
		public const iconPadding : String = "listItemRenderer_iconPadding";

		/* Background */

		/**
		 * Style property defining the background visibility.
		 */
		public const background : String = "listItemRenderer_background";

		/**
		 * Style property defining the background type.
		 */
		public const backgroundType : String = "listItemRenderer_backgroundType";

		/**
		 * Style property defining the background colors for items at an even position.
		 */
		public const evenIndexBackgroundColors : String = "listItemRenderer_evenIndexBackgroundColors";

		/**
		 * Style property defining the background colors for items at an odd position.
		 */
		public const oddIndexBackgroundColors : String = "listItemRenderer_oddIndexBackgroundColors";

		/**
		 * Style property defining the background colors in the roll over state.
		 */
		public const overBackgroundColors : String = "listItemRenderer_overBackgroundColors";

		/**
		 * Style property defining the background colors in the selected state.
		 */
		public const selectedBackgroundColors : String = "listItemRenderer_selectedBackgroundColors";

		/* Separator */

		/**
		 * Style property defining the separator visibility.
		 */
		public const separator : String = "listItemRenderer_separator";

		/**
		 * Style property defining the separator color.
		 */
		public const separatorColor : String = "listItemRenderer_separatorColor";
		
		/* Selection */

		/**
		 * Style property defining the selection mode.
		 */
		public const clickSelection : String = "listItemRenderer_clickSelection";

		/**
		 * Style property defining the deselection mode.
		 */
		public const ctrlKeyDeselection : String = "listItemRenderer_ctrlKeyDeselection";

	}
}
