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
package com.sibirjak.asdpc.treeview.renderer.skins {

	/*
	 * Styles
	 */
	
	/**
	 * @copy SolidConnectorSkin#style_color
	 */
	[Style(name="solidConnectorSkin_color", type="uint", format="Color")]

	/**
	 * Solid connector skin.
	 * 
	 * @author jes 29.10.2009
	 */
	public class SolidConnectorSkin extends BaseConnectorSkin {

		/**
		 * Style property defining the connector color.
		 */
		public static const style_color : String = "solidConnectorSkin_color";
		
		/**
		 * SolidConnectorSkin constructor.
		 */
		public function SolidConnectorSkin() {
			setDefaultStyles([
				style_color, 0xCCCCCC,
			]);
		}

		/*
		 * BaseConnectorSkin protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function drawVertical(x : int, y : int, height : int) : void {
			graphics.beginFill(getStyle(style_color));
			graphics.drawRect(x, y, 1, height);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawHorizontal(x : int, y : int, width : int) : void {
			graphics.beginFill(getStyle(style_color));
			graphics.drawRect(x, y, width, 1);
		}

	}
}
