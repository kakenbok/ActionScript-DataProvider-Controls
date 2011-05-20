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
package com.sibirjak.asdpc.listview.renderer.skins {
	import com.sibirjak.asdpc.core.skins.BackgroundSkin;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ListItemBackgroundSkin#style_backgroundColors
	 */
	[Style(name="listItemBackgroundSkin_backgroundColors", type="Array", arrayType="uint", format="Color")]

	/**
	 * @copy ListItemBackgroundSkin#style_border
	 */
	[Style(name="listItemBackgroundSkin_border", type="Boolean")]

	/**
	 * @copy ListItemBackgroundSkin#style_borderColor
	 */
	[Style(name="listItemBackgroundSkin_borderColor", type="uint", format="Color")]

	/**
	 * Background skin of a ListItemRenderer.
	 * 
	 * @author jes 21.12.2009
	 */
	public class ListItemBackgroundSkin extends BackgroundSkin {
		
		/**
		 * Style property defining the background colors.
		 */
		public static const style_backgroundColors : String = "listItemBackgroundSkin_backgroundColors";

		/**
		 * Style property defining the border visibility.
		 */
		public static const style_border : String = "listItemBackgroundSkin_border";

		/**
		 * Style property defining the border color.
		 */
		public static const style_borderColor : String = "listItemBackgroundSkin_borderColor";
		
		/**
		 * ListItemBackgroundSkin constructor.
		 */
		public function ListItemBackgroundSkin() {
			setDefaultStyles([
				style_backgroundColors, [0xFFFFFF,0xFFFFFF],
				style_border, true,
				style_borderColor, 0xEEEEEE
			]);
		}

		/**
		 * @inheritDoc
		 */
		override protected function cornerRadius() : uint {
			return 0;
		}

		/**
		 * @inheritDoc
		 */
		override protected function backgroundRotation() : Number {
			return 90;
		}

		/**
		 * @inheritDoc
		 */
		override protected function backgroundColors() : Array {
			return getStyle(style_backgroundColors);
		}

		/**
		 * @inheritDoc
		 */
		override protected function border() : Boolean {
			return getStyle(style_border);
		}

		/**
		 * @inheritDoc
		 */
		override protected function borderSides() : uint {
			return BackgroundSkin.BOTTOM_BORDER;
		}

		/**
		 * @inheritDoc
		 */
		override protected function borderColors() : Array {
			return [getStyle(style_borderColor)];
		}

	}
}
