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
package com.sibirjak.asdpcbeta.layout {
	import com.sibirjak.asdpc.core.constants.Position;

	import flash.display.DisplayObject;

	/**
	 * @author jes 01.12.2009
	 */
	public class VLayout extends AbstractLayout {

		public static var style : VLayoutStyles = new VLayoutStyles();

		public function VLayout() {
			setDefaultStyles([
				style.horizontalAlign, Position.LEFT
			]);
		}
		
		/*
		 * Protected 
		 */
		
		override protected function layoutChildren() : void {
			
			var itemPadding : uint = getStyle(style.itemPadding);
			
			var child : DisplayObject;
			var currentY : uint = 0;

			// calculate max height
			
			_width = 0;
			for (var i : uint = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if (_excludeList.has(child)) continue;
				_width = Math.max(_width, child.width);
			}

			// layout

			for (i = 0; i < numChildren; i++) {
				child = getChildAt(i);
				
				if (_excludeList.has(child)) continue;
				
				child.y = currentY;
				
				switch (getStyle(style.horizontalAlign)) {
					case Position.LEFT:
						child.x = 0;
						break;
					case Position.CENTER:
						child.x = Math.round((_width - child.width) / 2);
						break;
					case Position.RIGHT:
						child.x = _width - child.width;
						break;
				}

				currentY += child.height + itemPadding;
			}
			
			_height = currentY - itemPadding;
		}

	}
}
