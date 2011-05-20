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
package com.sibirjak.asdpc.common.interfacedemo.windows.info {
	import com.sibirjak.asdpcbeta.colorpicker.core.ColorUtil;

	import org.as3commons.collections.framework.IDataProvider;

	/**
	 * @author jes 26.01.2010
	 */
	public class Style implements IDataProvider {
		
		public var property : String;
		public var value : *;
		
		public function Style(theProperty : String, theValue : *) {
			property = theProperty;
			value = theValue;
		}
		
		public function itemAt(index : uint) : * {
			var item : *;
			
			if (property.indexOf("Styles") > -1) {
				var styleValue : * = value[index * 2 + 1];
				if (String(value[index * 2]).indexOf("olor") > -1) styleValue = ColorUtil.hexToString(styleValue);
				
				item = new Style(value[index * 2], styleValue);

			} else {
				if (property.indexOf("olor") > -1) item = ColorUtil.hexToString(value[index]);
	
			}

			return item;
		}
		
		public function get size() : uint {
			return value is Array
				? property.indexOf("Styles") > -1
					? value["length"] / 2
					: value["length"]
				: 0;
		}
		
		public function get name() : String {
			if (value is Array) {
				return property;
			} else {
				return property + " = " + value;
			}
		}
	}
}
