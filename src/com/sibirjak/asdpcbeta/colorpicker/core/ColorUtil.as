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

	/**
	* @author jes 04.12.2009
	*/
	public class ColorUtil {

		public static function hexToString(hex : Number, addHash : Boolean = true) : String {
			var hexString : String = hex.toString(16);
			hexString = ("000000").substr(0, 6 - hexString.length) + hexString; 
			if (addHash) hexString = "#" + hexString; 
			return hexString.toUpperCase();
		}

		/*
		 * RGB
		 */

		public static function hex2Rgb(hex : Number) : Object {
			return {
				r : ( hex >> 16 ) & 0xFF,
				g : ( hex >> 8 ) & 0xFF,
				b : hex & 0xFF
			};
		}

		public static function rgb2Hex(r : Number, g : Number, b : Number) : Number {
			return (r << 16) | (g << 8) | b;
		}

		/*
		 * HSB
		 */

		public static function hsbToRgb(h : Number, s : Number, br : Number) : Object {
			return hex2Rgb(hsb2Hex(h, s, br));
		}

		public static function rgb2Hsb(r : Number, g : Number, b : Number) : Object {
			return hex2Hsb(rgb2Hex(r, g, b));
		}

		public static function hsb2Hex( h : Number, s : Number, br : Number ) : Number {
	
			var r : Number;
			var g : Number;
			var b : Number;
			var rgb : Number;
		
			if (!isNaN(s)) {
				s = (100 - s ) / 100;
				br = ( 100 - br ) / 100;
			}
		
			if ( ( h  > 300 && h <= 360 ) || ( h >= 0 && h <= 60 ) )  {
				r = 255;
				g = ( h / 60 ) * 255;
				b = ( ( 360 - h ) / 60 ) * 255;
			} else if ( h > 60 && h <= 180 )  {
				r = ( ( 120 - h ) / 60 ) * 255;
				g = 255;
				b = ( ( h - 120 ) / 60 ) * 255;
			} else  {
				r = ( ( h - 240 ) / 60 ) * 255;
				g = ( ( 240 - h ) / 60 ) * 255;
				b = 255;
			}
			
			if ( r > 255 || r < 0 ) r = 0;
			if ( g > 255 || g < 0 ) g = 0;
			if ( b > 255 || b < 0 ) b = 0;
			
			if (!isNaN(s)) {
				r += ( 255 - r ) * s;
				g += ( 255 - g ) * s;
				b += ( 255 - b ) * s;
				r -= r * br;
				g -= g * br;
				b -= b * br;
				r = Math.round( r );
				g = Math.round( g );
				b = Math.round( b );
			}
			rgb = b + ( g * 256 ) + ( r * 65536 );
			return rgb;
		}

		public static function hex2Hsb(hex : Number) : Object {
			var rgb : Object = hex2Rgb(hex);
			var r : Number = rgb["r"];
			var g : Number = rgb["g"];
			var b : Number = rgb["b"];

			var h : Number;
			var s : Number;
			var bri : Number;

			bri = Math.max(r, g, b);
			var min : Number = Math.min(r, g, b);

			s = ( bri <= 0 ) ? 0 : Math.round( 100 * ( bri - min ) / bri );

			bri = Math.round( ( bri / 255 ) * 100 );

			h = 0;
			if ( ( r == g ) && ( g == b ) )	{
				h = 0;
			} else if ( r >= g && g >= b ) {
				h = 60 * ( g - b ) / ( r - b );
			} else if ( g >= r && r >= b ) {
				h = 60 + 60 * ( g - r ) / ( g - b );
			} else if ( g >= b && b >= r ) {
				h = 120 + 60 * ( b - r ) / ( g - r );
			} else if ( b >= g && g >= r) {
				h = 180 + 60 * ( b - g ) / ( b - r );
			} else if ( b >= r && r >=  g ) {
				h = 240 + 60 * ( r - g ) / ( b - g );
			} else if ( r >= b && b >= g ) {
				h = 300 + 60 * ( r - b ) / ( r - g );
			} else {
				h = 0;
			}
			h = Math.round( h );

			return {h: h, s: s, b: b};
		}

		/*
		 * HSL
		 */

		public static function hex2Hsl(hex : uint) : Object {
			var rgb : Object = {r:(hex >> 16) & 0xFF, g:(hex >> 8) & 0xFF, b:hex & 0xFF};
			var hsl : Array = rgbToHsl(rgb["r"], rgb["g"], rgb["b"]);
			return {h: hsl[0], s: hsl[1], l: hsl[2]};
		}

		public static function rgbToHsl(r : Number, g : Number, b : Number) : Array {
		    r /= 255, g /= 255, b /= 255;
		    var max : Number = Math.max(r, g, b);
			var min : Number = Math.min(r, g, b);
		    var h : Number;
			var s : Number;
			var l : Number = (max + min) / 2;
		
		    if (max == min){
		        h = s = 0; // achromatic
		    } else {
		        var d : Number = max - min;
		        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
		        switch(max){
		            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
		            case g: h = (b - r) / d + 2; break;
		            case b: h = (r - g) / d + 4; break;
		        }
		        h /= 6;
		    }
		
		    return [h, s, l];
		}
		
		public static function hsl2Hex(hsl : Object) : uint {
			var rgb : Array = hslToRgb(hsl["h"], hsl["s"], hsl["l"]);
			return (rgb[0] << 16) + (rgb[1] << 8) + rgb[2];
		}

		public static function hslToRgb(h : Number, s : Number, l : Number) : Array {
		    var r : Number;
			var g : Number;
			var b : Number;
		
		    if(s == 0){
		        r = g = b = l; // achromatic
		    } else {
		        function hue2rgb(p : Number, q : Number, t : Number) : Number {
		            if(t < 0) t += 1;
		            if(t > 1) t -= 1;
		            if(t < 1/6) return p + (q - p) * 6 * t;
		            if(t < 1/2) return q;
		            if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
		            return p;
		        }
		
		        var q : Number = l < 0.5 ? l * (1 + s) : l + s - l * s;
		        var p : Number = 2 * l - q;
		        r = hue2rgb(p, q, h + 1/3);
		        g = hue2rgb(p, q, h);
		        b = hue2rgb(p, q, h - 1/3);
		    }
		    return [r * 255, g * 255, b * 255];
		}

		/*private static function hsb2Hex2(hsb : Object) : Number {
			if (!isNaN(hsb["s"])) {
				hsb["s"] = (100 - hsb["s"]) / 100;
				hsb["b"] = (100 - hsb["b"]) / 100;
			}
		
			var rgb : Object = new Object();

			if ((hsb["h"]  > 300 && hsb["h"] <= 360) || (hsb["h"] >= 0 && hsb["h"] <= 60))  {
				rgb["r"] = 255;
				rgb["g"] = (hsb["h"] / 60) * 255;
				rgb["b"] = ((360 - hsb["h"]) / 60) * 255;
			} else if (hsb["h"] > 60 && hsb["h"] <= 180)  {
				rgb["r"] = ((120 - hsb["h"]) / 60) * 255;
				rgb["g"] = 255;
				rgb["b"] = ((hsb["h"] - 120) / 60) * 255;
			} else  {
				rgb["r"] = ((hsb["h"] - 240) / 60) * 255;
				rgb["g"] = ((240 - hsb["h"]) / 60) * 255;
				rgb["b"] = 255;
			}
			
			if (rgb["r"] > 255 || rgb["r"] < 0) rgb["r"] = 0;
			if (rgb["g"] > 255 || rgb["g"] < 0) rgb["g"] = 0;
			if (rgb["b"] > 255 || rgb["b"] < 0) rgb["b"] = 0;
			
			if (!isNaN(hsb["s"])) {
				rgb["r"] += (255 - rgb["r"]) * hsb["s"];
				rgb["g"] += (255 - rgb["g"]) * hsb["s"];
				rgb["b"] += (255 - rgb["b"]) * hsb["s"];
				rgb["r"] -= rgb["r"] * hsb["b"];
				rgb["g"] -= rgb["g"] * hsb["b"];
				rgb["b"] -= rgb["b"] * hsb["b"];
				rgb["r"] = Math.round(rgb["r"]);
				rgb["g"] = Math.round(rgb["g"]);
				rgb["b"] = Math.round(rgb["b"]);
			}

			return rgb["b"] + (rgb["g"] * 256) + (rgb["r"] * 65536);
		}

		private static function hex2Hsb2(hex : Number) : Object {
			var rgb : Object = {
				r : (hex >> 16) & 0xFF,
				g : (hex >> 8) & 0xFF,
				b : hex & 0xFF
			};
			
			var hsb : Object = new Object();
			hsb["b"] = Math.max(rgb["r"], rgb["g"], rgb["b"]);
			var min : Number = Math.min(rgb["r"], rgb["g"], rgb["b"]);
			hsb["s"] = (hsb["b"] <= 0) ? 0 : Math.round(100 * (hsb["b"] - min) / hsb["b"]);
			hsb["b"] = Math.round((hsb["b"] / 255) * 100);

			hsb["h"] = 0;
			if ((rgb["r"] == rgb["g"]) && (rgb["g"] == rgb["b"]))	{
				hsb["h"] = 0;
			} else if (rgb["r"] >= rgb["g"] && rgb["g"] >= rgb["b"]) {
				hsb["h"] = 60 * (rgb["g"] - rgb["b"]) / (rgb["r"] - rgb["b"]);
			} else if (rgb["g"] >= rgb["r"] && rgb["r"] >= rgb["b"]) {
				hsb["h"] = 60 + 60 * (rgb["g"] - rgb["r"]) / (rgb["g"] - rgb["b"]);
			} else if (rgb["g"] >= rgb["b"] && rgb["b"] >= rgb["r"]) {
				hsb["h"] = 120 + 60 * (rgb["b"] - rgb["r"]) / (rgb["g"] - rgb["r"]);
			} else if (rgb["b"] >= rgb["g"] && rgb["g"] >= rgb["r"]) {
				hsb["h"] = 180 + 60 * (rgb["b"] - rgb["g"]) / (rgb["b"] - rgb["r"]);
			} else if (rgb["b"] >= rgb["r"] && rgb["r"] >=  rgb["g"]) {
				hsb["h"] = 240 + 60 * (rgb["r"] - rgb["g"]) / (rgb["b"] - rgb["g"]);
			} else if (rgb["r"] >= rgb["b"] && rgb["b"] >= rgb["g"]) {
				hsb["h"] = 300 + 60 * (rgb["r"] - rgb["b"]) / (rgb["r"] - rgb["g"]);
			} else {
				hsb["h"] = 0;
			}
			hsb["h"] = Math.round(hsb["h"]);

			return hsb;
		}*/

	}
}
