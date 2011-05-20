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
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/*
	 * Styles
	 */
	
	/**
	 * @copy DottedConnectorSkin#style_color
	 */
	[Style(name="dottedConnectorSkin_color", type="uint", format="Color")]

	/**
	 * Dotted connector skin.
	 * 
	 * @author jes 29.10.2009
	 */
	public class DottedConnectorSkin extends BaseConnectorSkin {

		/**
		 * Style property defining the connector color.
		 */
		public static const style_color : String = "dottedConnectorSkin_color";
		
		/**
		 * DottedConnectorSkin constructor.
		 */
		public function DottedConnectorSkin() {
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
		override protected function drawHorizontal(x : int, y : int, width : int) : void {
			
			var r1 : Rectangle = new Rectangle(0, 0, 1, 1);
			var r2 : Rectangle = new Rectangle(1, 0, 1, 1);

			var horizontalTile : BitmapData = new BitmapData(2, 1, true);
			horizontalTile.fillRect(r1, (0xFF << 24) + getStyle(style_color));
			horizontalTile.fillRect(r2, 0x00000000);
			
			with (graphics) {
				lineStyle();
				beginBitmapFill(horizontalTile, null, true);
				drawRect(x, y, width, 1);
				endFill();
			}

		}

		/**
		 * @inheritDoc
		 */
		override protected function drawVertical(x : int, y : int, height : int) : void {
			
			var r1 : Rectangle = new Rectangle(0, 0, 1, 1);
			var r2 : Rectangle = new Rectangle(0, 1, 1, 1);

			var verticalTile : BitmapData = new BitmapData(1, 2, true);
			verticalTile.fillRect(r1, (0xFF << 24) + getStyle(style_color));
			verticalTile.fillRect(r2, 0x00000000);

			with (graphics) {
				lineStyle();
				beginBitmapFill(verticalTile, null, true);
				drawRect(x, y, 1, height);
				endFill();
			}
		}

	}
}
