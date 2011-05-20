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
package com.sibirjak.asdpcbeta.checkbox.skins {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.Skin;

	import flash.display.Shape;

	/**
	 * @author jes 02.12.2009
	 */
	public class CheckBoxIconSkin extends Skin {

		public static const style_color : String = "checkBoxIconSkin_color";
		public static const style_size : String = "checkBoxIconSkin_size";

		public function CheckBoxIconSkin() {

			setDefaultStyles([
				style_color, 0x666666,
				style_size, 6
			]);
		}

		override protected function draw() : void {
			
			var isDown : Boolean = (name == Button.DOWN_ICON_SKIN_NAME || name == Button.SELECTED_DOWN_ICON_SKIN_NAME);
			var isDisabled : Boolean = (name == Button.DISABLED_ICON_SKIN_NAME || name == Button.SELECTED_DISABLED_ICON_SKIN_NAME);
			var alpha : Number = isDown || isDisabled ? .3 : 1;
			
			var size : uint = getStyle(style_size);
			var icon : Shape = new Shape();
			
			with (icon.graphics) {
				lineStyle(2, getStyle(style_color), alpha);
				
				moveTo(0, Math.round(1 / 2 * size));
				lineTo(Math.round(1 / 3 * size), size);
				lineTo(size, 0);

			}

			icon.x = Math.round((_width - size) / 2);
			icon.y = Math.round((_height - size) / 2);

			addChild(icon);
		}
	}
}
