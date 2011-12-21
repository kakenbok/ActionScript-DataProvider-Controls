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
package com.sibirjak.asdpcbeta.colorpicker.core {
	import flash.display.Sprite;

	/**
	 * @author jes 04.12.2009
	 */
	public class ColorSwatch extends Sprite {

		public var color : int;
		public var hex : String;
		public var index : int;
		
		public function ColorSwatch(theColor : int, width : uint, height : uint, theIndex : uint) {
			color = theColor;
			hex = ColorUtil.hexToString(color, false);
			index = theIndex;
	
			with (graphics) {
				if (color > -1) {
					lineStyle(0, 0x000000);
					beginFill(color);
					drawRect(0, 0, width, height);
				} else {
					lineStyle(0, 0);
					beginFill(0xFFFFFF);
					drawRect(0, 0, width, height);
					
					lineStyle(0, 0xBBBBBB);
					moveTo(width, 1);
					lineTo(1, height);
				}
			
			}
		}

	}
}
