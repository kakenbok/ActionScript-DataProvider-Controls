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
package com.sibirjak.asdpcbeta.radiobutton.skins {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.Skin;

	/**
	 * @author jes 03.12.2009
	 */
	public class RadioButtonSkin extends Skin {

		public static const style_backgroundColor : String = "radioButtonSkin_backgroundColor";
		public static const style_backgroundAlpha : String = "radioButtonSkin_backgroundAlpha";

		public static const style_borderColor : String = "radioButtonSkin_borderColor";
		public static const style_borderAliasAlpha : String = "radioButtonSkin_borderAliasAlpha";

		public function RadioButtonSkin() {

			setDefaultStyles([
				style_backgroundColor, 0xFFFFFF,
				style_backgroundAlpha, 1,

				style_borderColor, 0xBBBBBB,
				style_borderAliasAlpha, .05,
			]);

		}

		override protected function draw() : void {

			var backgroundColor : uint = getStyle(style_backgroundColor);
			var backgroundAlpha : Number = getStyle(style_backgroundAlpha);
			var borderColor : uint = getStyle(style_borderColor);
			var borderAliasAlpha : Number = getStyle(style_borderAliasAlpha);
			
			var isDisabled : Boolean = (name == Button.DISABLED_SKIN_NAME || name == Button.SELECTED_DISABLED_SKIN_NAME);
			var borderAlpha : Number = isDisabled ? .5 : 1;

			var radius : uint = _width / 2;
			
			with (graphics) {
				
				beginFill(borderColor, borderAlpha);
				drawCircle(radius, radius, radius);
				endFill();

				beginFill(backgroundColor, backgroundAlpha);
				drawCircle(radius, radius, radius - 1);
				endFill();

				lineStyle(1, borderColor, borderAliasAlpha);
				drawCircle(radius, radius, radius - 2);
			}
			
		}

	}
}
