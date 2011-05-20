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
package com.sibirjak.asdpcbeta.window.skins {
	import com.sibirjak.asdpc.core.Skin;

	import flash.display.Shape;

	/**
	 * @author jes 30.11.2009
	 */
	public class MinimiseIconSkin extends Skin {
		
		public static const style_color : String = "minimiseIconSkin_color";
		public static const style_borderColor : String = "minimiseIconSkin_borderColor";
		
		public function MinimiseIconSkin() {
			setDefaultStyles([
				style_borderColor, 0x777777,
				style_color, 0xFCFCFC
			]);
		}

		override protected function draw() : void {
			
			var color : uint = getStyle(style_color);
			var borderColor : uint = getStyle(style_borderColor);
			
			var icon : Shape = new Shape();

			with (icon.graphics) {
				beginFill(borderColor);
				drawRect(0, 0, _width - 5, 4);

				beginFill(color);
				drawRect(1, 1, _width - 7, 2);
			}
			
			icon.x = 2;
			icon.y = 2;
			
			addChild(icon);
		}
	}
}
