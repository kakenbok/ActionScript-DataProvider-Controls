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
package com.sibirjak.asdpc.core.skins {
	import flash.display.Sprite;

	/**
	 * Mouse sensitive transparent rectangular area.
	 * 
	 * <p>The GlassFrame automatically redraws after each resize operation.</p>
	 * 
	 * <p>The GlassFrame subclasses Sprite rather than Shape in order to be mouse sensitive.</p>
	 * 
 	 * <listing>
		_disabledFrame = new GlassFrame(0xFFFFFF, .5); // sets color and alpha
		_disabledFrame.setSize(_width, _height); // initially draws the frame
		addChild(_disabledFrame);
		...
		_disabledFrame.setSize(newWidth, newHeight); // immediately redraws the frame
	 * </listing>
	 * 
	 * @author jes 05.01.2010
	 */
	public class GlassFrame extends Sprite {
		
		/**
		 * The color.
		 */
		private var _color : uint;

		/**
		 * The alpha.
		 */
		private var _alpha : Number;

		/**
		 * GlassFrame constructor.
		 * 
		 * <p>If an alpha value != 0 is passed, the GlassFrame becomes visible.</p>
		 * 
		 * @param color The background color.
		 * @param alpha The background alpha.
		 */
		public function GlassFrame(color : uint = 0, alpha : Number = 0) {
			_color = color;
			_alpha = alpha;
		}
		
		/**
		 * Draws or redraws the GlassFrame with the specified dimensions.
		 * 
		 * @param width The frame width.
		 * @param height The frame height.
		 */
		public function setSize(width : uint, height : uint) : void {
			draw(width, height);
		}

		/**
		 * Finally draws the GlassFrame.
		 */
		private function draw(width : uint, height : uint) : void {
			with (graphics) {
				clear();
				beginFill(_color, _alpha);
				drawRect(0, 0, width, height);
			}
		}

	}
}
