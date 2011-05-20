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
	 * @author jes 04.12.2009
	 */
	public class GridLayout extends AbstractLayout {
		
		public static var style : GridLayoutStyles = new GridLayoutStyles();

		public function GridLayout() {
			setDefaultStyles([
				style.itemWidth, 30,
				style.itemHeight, 30,
				style.numItemsPerRow, 0,
				style.horizontalAlign, Position.CENTER,
				style.verticalAlign, Position.MIDDLE,
				style.horizontalAlign, Position.CENTER
			]);
		}
		
		/*
		 * Protected 
		 */

		override protected function init() : void {
			super.init();
			
			var itemWidth : uint = getStyle(style.itemWidth);
			var itemPadding : uint = getStyle(style.itemPadding);
			var numItemsPerRow : uint = getStyle(style.numItemsPerRow);
			if (numItemsPerRow) {
				_width = numItemsPerRow * (itemWidth + itemPadding) - itemPadding;
			}
			
		}
		
		override protected function layoutChildren() : void {
			
			var itemWidth : uint = getStyle(style.itemWidth);
			var itemHeight : uint = getStyle(style.itemHeight);
			var itemPadding : uint = getStyle(style.itemPadding);

			var child : DisplayObject;
			var currentX : uint = 0;
			var currentY : uint = 0;

			// layout
			
			for (var i : uint = 0; i < numChildren; i++) {
				child = getChildAt(i);
				if (_excludeList.has(child)) continue;
				
				child.x = currentX;
				child.y = currentY;
				
				currentX += itemWidth + itemPadding;
				
				if (currentX + itemWidth > _width) {
					currentX = 0;
					currentY += itemHeight + itemPadding;
				}
				
			}
			
			_height = currentY - itemPadding;
			
		}

	}
}
