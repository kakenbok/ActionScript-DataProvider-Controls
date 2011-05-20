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
	public class HLayout extends AbstractLayout {
		
		public static var style : HLayoutStyles = new HLayoutStyles();

		public function HLayout() {
			setDefaultStyles([
				style.verticalAlign, Position.MIDDLE
			]);
		}

		/*
		 * Protected 
		 */
		
		override protected function layoutChildren() : void {
			
			var itemPadding : uint = getStyle(style.itemPadding);
			
			var child : DisplayObject;
			var currentX : uint = 0;

			// calculate max height
			
			_height = 0;
			for (var i : uint = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if (_excludeList.has(child)) continue;
				_height = Math.max(_height, child.height);
			}

			// layout

			for (i = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if (_excludeList.has(child)) continue;
				
				child.x = currentX;
				
				switch (getStyle(style.verticalAlign)) {
					case Position.TOP:
						child.y = 0;
						break;
					case Position.MIDDLE:
						child.y = Math.round((_height - child.height) / 2);
						break;
					case Position.BOTTOM:
						child.y = _height - child.height;
						break;
				}

				currentX += child.width + itemPadding;
			}
			
			_width = currentX - itemPadding;
		}
		
	}
}
