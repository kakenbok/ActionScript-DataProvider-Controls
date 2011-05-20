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
	import org.as3commons.collections.ArrayList;

	/**
	 * @author jes 04.12.2009
	 */
	public class Palette {
		
		public static function palette() : ArrayList {
			var palette : ArrayList = greyPalette();
			var i : int;
			var h : int;
			var s : int;
			var bri : int;

			for (i = -48; i < 288; i += 24) {
				h = i < 0 ? 360 + i : i;

				if (h == 168) h = 180; // cyan
				if (h == 312) h = 300; // pink

				for (bri = 100; bri > 0; bri -= 20) {
					for (s = 100; s > 0; s -= 20) {
						palette.add(ColorUtil.hsb2Hex(h, s, bri));
					}
				}
				
				if (h == 48) i -= 12; // add yellow
				if (h == 60) i -= 12;
			}

			return palette;
		}
		
		public static function greyPalette() : ArrayList {
			var palette : ArrayList = new ArrayList();
			var values : Array = [
				"00", "11", "22", "33", "44", "55", "66", "77", "88", "99",
				"A2", "AA", "B3", "BB", "C4", "CC", "D2", "D8", "DD", "E3",
				"E9", "EE", "F4", "FA", "FF"
			];
			
			var index : uint;
			for (var i : uint = 0; i < 25; i++) {
				index = 24 - i;
				palette.add(
					Number("0x" + values[index] + values[index] + values[index])
				);
			}

			return palette;
		}

		public static function webPalette() : ArrayList {
			var palette : ArrayList = greyWebPalette();
			var i : int;
			var h : int;
			var s : int;
			var bri : int;

			var rgb : Object;
			for (i = -48; i < 288; i += 24) {
				h = i < 0 ? 360 + i : i;

				if (h == 168) h = 180; // cyan
				if (h == 312) h = 300; // pink

				for (bri = 100; bri > 0; bri -= 20) {
					for (s = 100; s > 0; s -= 20) {
						rgb = ColorUtil.hsbToRgb(h, s, bri);
						palette.add(ColorUtil.rgb2Hex(
							roundToWeb(rgb["r"]),
							roundToWeb(rgb["g"]),
							roundToWeb(rgb["b"])
						));
					}
				}

				if (h == 48) i -= 12; // add yellow
				if (h == 60) i -= 12;
			}

			return palette;
		}
		
		public static function greyWebPalette() : ArrayList {
			var palette : ArrayList = new ArrayList();
			var values : Array = [
				"00", "33", "66", "99", "CC", "FF"
			];

			var index : uint;
            for (var i : uint = 0; i < 6; i++) {
	            for (var j : uint = 0; j < 4; j++) {
            		index = 5 - i;
	            	palette.add(Number("0x" + values[index] + values[index] + values[index]));
            	}
            }
            palette.add(0x000000);

            return palette;
		}

		private static function roundToWeb(value : uint) : uint {
			if (value % 0x33) {
				var diff : int = value % 0x33;
				if (diff > 0x1A) {
					return Math.floor(value / 0x33) * 0x33 + 0x33;
				} else {
					return Math.floor(value / 0x33) * 0x33;
				}
			}
			return value;
		}

	}
}
