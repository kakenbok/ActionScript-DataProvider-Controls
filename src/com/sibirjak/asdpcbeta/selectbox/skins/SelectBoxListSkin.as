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
package com.sibirjak.asdpcbeta.selectbox.skins {
	import com.sibirjak.asdpc.core.skins.BackgroundSkin;

	/**
	 * @author jes 21.12.2009
	 */
	public class SelectBoxListSkin extends BackgroundSkin {

		public static const style_backgroundLightColor : String = "colorPickerSkin_backgroundLightColor";
		public static const style_backgroundDarkColor : String = "colorPickerSkin_backgroundDarkColor";

		public static const style_borderLightColor : String = "colorPickerSkin_borderLightColor";
		public static const style_borderDarkColor : String = "colorPickerSkin_borderDarkColor";

		public function SelectBoxListSkin() {
			setDefaultStyles([
				style_backgroundLightColor, 0xFFFFFF,
				style_backgroundDarkColor, 0xFFFFFF,

				style_borderLightColor, 0xCCCCCC,
				style_borderDarkColor, 0x666666
			]);
		}

		override protected function backgroundColors() : Array {
			return [getStyle(style_backgroundLightColor), getStyle(style_backgroundDarkColor)];
		}

		override protected function borderColors() : Array {
			return [getStyle(style_borderLightColor), getStyle(style_borderDarkColor)];
		}

	}
}
