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
package com.sibirjak.asdpc.scrollbar.skins {
	import com.sibirjak.asdpc.core.Skin;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ScrollTrackSkin#style_color
	 */
	[Style(name="scrollTrackSkin_color", type="uint", format="Color")]

	/**
	 * Scrollbar track skin.
	 * 
	 * @author jes 14.07.2009
	 */
	public class ScrollTrackSkin extends Skin {

		/* Styles */
		
		/**
		 * Style property defining the track color.
		 */
		public static const style_color : String = "scrollTrackSkin_color";

		/**
		 * Style property defining the track color.
		 */
		public static const style_raster : String = "scrollTrackSkin_raster";

		/**
		 * ScrollTrackSkin constructor.
		 */
		public function ScrollTrackSkin() {
			setDefaultStyles([
				style_color, 0xCCCCCC,
				style_raster, true
			]);
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			var backgroundColor : uint = getStyle(style_color);

			if (getStyle(style_raster)) {
				var r1 : Rectangle = new Rectangle(0, 0, 1, 1);
				var r2 : Rectangle = new Rectangle(1, 1, 1, 1);
				var r3 : Rectangle = new Rectangle(0, 1, 1, 1);
				var r4 : Rectangle = new Rectangle(1, 0, 1, 1);
	
				var tile : BitmapData = new BitmapData(2, 2, true);
				tile.fillRect(r1, (0xFF << 24) + backgroundColor);
				tile.fillRect(r2, (0xFF << 24) + backgroundColor);
				tile.fillRect(r3, 0x00000000);
				tile.fillRect(r4, 0x00000000);

				with (graphics) {
					beginBitmapFill(tile, null, true);
					drawRect(0, 0, _width, _height);
				}

			} else {
				with (graphics) {
					beginFill(backgroundColor);
					drawRect(0, 0, _width, _height);
				}
			}

		}
		
	}
}
