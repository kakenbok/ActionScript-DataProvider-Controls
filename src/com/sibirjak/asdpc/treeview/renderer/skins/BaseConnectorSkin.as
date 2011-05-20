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
	import com.sibirjak.asdpc.core.Skin;
	import com.sibirjak.asdpc.treeview.renderer.Connector;
	import com.sibirjak.asdpc.treeview.renderer.IConnectorSkin;

	/**
	 * Base connector skin.
	 * 
	 * @author jes 15.01.2010
	 */
	public class BaseConnectorSkin extends Skin implements IConnectorSkin {
		
		/**
		 * The y position of the bottom connection.
		 */
		protected var _bottomY : uint;

		/**
		 * The bottom position of the bottom connection.
		 */
		protected var _extendedHeight : uint;
		
		/*
		 * IConnectorSkin
		 */
		
		/**
		 * @inheritDoc
		 */
		public function set bottomY(bottomY : uint) : void {
			_bottomY = bottomY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set extendedHeight(extendedHeight : uint) : void {
			_extendedHeight = extendedHeight;
		}

		/*
		 * View life cycle
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			/*
			 * If the _width/_height is an odd number, the connector starts or ends
			 * right in the middle (25 -> 13). If the _width/_height is an even number
			 * the horizontal connector starts or ends (24 -> 12) at the first pixel
			 * right to the middle.
			 */
			
			var x : uint = Math.floor(_width / 2); // center position
			var y : uint = Math.floor(_height / 2);
			x -= x % 2; // place only on even positions;
			y -= y % 2; // place only on even positions;
			
			switch (name) {
				
				case Connector.TOP_NAME:
					drawVertical(x, 0, y + 1);
					break;
				
				case Connector.RIGHT_NAME:
					drawHorizontal(x, y, _width - x);
					break;

				case Connector.BOTTOM_NAME:
					if (_bottomY) y = _bottomY;
					var h : int = _height - y + _extendedHeight;
				
					drawVertical(x, y, h);
					break;

				case Connector.LEFT_NAME:
					drawHorizontal(0, y, x + 1);
					break;
			}
		}
		
		/*
		 * Protected
		 */

		/**
		 * Draws a vertical connection.
		 * 
		 * @param x The x position.
		 * @param y The y position.
		 * @param height The connection height.
		 */
		protected function drawVertical(x : int, y : int, height : int) : void {
		}
		
		/**
		 * Draws a horizontal connection.
		 * 
		 * @param x The x position.
		 * @param y The y position.
		 * @param width The connection width.
		 */
		protected function drawHorizontal(x : int, y : int, width : int) : void {
		}

	}
}
