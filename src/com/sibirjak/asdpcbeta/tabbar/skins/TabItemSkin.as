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
package com.sibirjak.asdpcbeta.tabbar.skins {
	import com.sibirjak.asdpc.core.Skin;
	import com.sibirjak.asdpcbeta.tabbar.TabBar;
	import com.sibirjak.asdpcbeta.tabbar.TabItem;

	import flash.display.GradientType;
	import flash.geom.Matrix;

	/**
	 * @author jes 03.12.2009
	 */
	public class TabItemSkin extends Skin {

		override protected function draw() : void {
			
			var isFirst : Boolean = getViewProperty(TabBar.VIEW_PROPERTY_FIRST_ITEM);
			//var isLast : Boolean  = getViewProperty(TabBar.VIEW_PROPERTY_LAST_ITEM);

			var selected : Boolean = name == TabItem.SELECTED_SKIN_NAME;
			
			var alpha : Number = selected ? 0 : 1;
			
			var angle : Number = Math.PI / 180 * 90;
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_width, _height, angle, 0, 0);
			var colors : Array = [0xAAAAAA, 0xB8B8B8];

			with (graphics) {

				beginGradientFill(GradientType.LINEAR, colors, [alpha, alpha], [0, 255], matrix);

//				beginFill(0xCCCCCC, alpha);
				drawRect(0, 0, _width, _height);
				endFill();

				lineStyle(1, 0x999999);
				
				// left
				
				if (!isFirst) {
					moveTo(0, _height);
					lineTo(0, 0);
				}
				
				// bottom

				if (!selected) {
					moveTo(0, _height - 1);
					lineTo(_width, _height - 1);
				}

				// top
				
				if (selected) {
					lineStyle(1, 0xDDDDDD, 1);
				} else {
					lineStyle(1, 0xBBBBBB);
				}
				
				moveTo(0, 0);
				lineTo(_width, 0);
//				if (selected) {
//					moveTo(0, _height);
//					lineTo(0, 0);
//					lineTo(_width - 1, 0);
//					lineTo(_width - 1, _height);
//					moveTo(0, 0);
//					lineTo(_width, 0);
//				}


			}
			
			
			
		}
	}
}
