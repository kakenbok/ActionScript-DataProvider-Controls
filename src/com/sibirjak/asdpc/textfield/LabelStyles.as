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
package com.sibirjak.asdpc.textfield {
	import com.sibirjak.asdpc.textfield.core.TextFieldBaseStyles;

	/**
	 * Label style properties.
	 * 
	 * @author jes 17.07.2009
	 */
	public class LabelStyles extends TextFieldBaseStyles {

		/**
		 * Style property defining the text fitting mode.
		 */
		public const fittingMode: String = "label_fittingMode";

		/**
		 * Style property defining the horizontal align of the text within the label dimensions.
		 */
		public const horizontalAlign: String = "label_horizontalAlign";

		/**
		 * Style property defining the vertical align of the text within the label dimensions.
		 */
		public const verticalAlign: String = "label_verticalAlign";
		
		/**
		 * Style property defining the label border type.
		 */
		public const borderType : String = "label_borderType";

	}
}
