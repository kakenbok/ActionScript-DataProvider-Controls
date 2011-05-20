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
package com.sibirjak.asdpcbeta.slider.skins {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.skins.BackgroundSkin;

	/**
	 * @author jes 01.12.2009
	 */
	public class SliderTrackSkin extends BackgroundSkin {

		public static const style_backgroundLightColor : String = "sliderTrackSkin_backgroundLightColor";
		public static const style_backgroundDarkColor : String = "sliderTrackSkin_backgroundDarkColor";
		public static const style_borderColor : String = "sliderTrackSkin_borderColor";


		public function SliderTrackSkin() {
			setDefaultStyles([
				style_backgroundLightColor, 0xEEEEEE,
				style_backgroundDarkColor, 0xCCCCCC,
				style_borderColor, 0xCCCCCC
			]);
		}

		override protected function backgroundColors() : Array {
			if (name == Button.DISABLED_SKIN_NAME) {
				return [getStyle(style_backgroundLightColor)];
			} else {
				return [getStyle(style_backgroundLightColor), getStyle(style_backgroundDarkColor)];
			}
			
		}

		override protected function borderColors() : Array {
			return [getStyle(style_borderColor), getStyle(style_borderColor)];
		}

		override protected function cornerRadius() : uint {
			return 0;
		}

	}
}
