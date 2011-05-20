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
package com.sibirjak.asdpc.core.dataprovider {
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	/**
	 * A generic toString() function.
	 * 
	 * <p>Returns:</p>
	 * 
	 * <ul>
	 * <li>The item - if the item is a primitive type (String, Number, Boolean).</li>
	 * <li>The node content - if the item is an XML text node.</li>
	 * <li>The value of the label attribute - if the item is an XML node and has a label attribute.</li>
	 * <li>The value of the name attribute - if the item is an XML node and has a name attribute.</li>
	 * <li>The tag name - if the item is an XML node.</li>
	 * <li>The value of the name property - if the item is a DisplayObject and a custom name property is set.</li>
	 * <li>The class name - if the item is a DisplayObject.</li>
	 * <li>The value of the label property - if the item has a public label property.</li>
	 * <li>The value of the name property - if the item has a public name property.</li>
	 * <li>The class name - for all other items.</li>
	 * </ul>
	 * 
	 * @param item The item to convert to a String.
	 * @return The converted String.
	 * 
	 * @author jes 22.01.2010
	 */
	public function genericToStringFunction(item : *) : String {
		
			if (item is String) return item;
			
			if (item is Number) return item;
			
			if (item is Boolean) return item;

			if (item is XML) {
				
				if (XML(item).nodeKind() == "text") return item;
				
				if (XML(item).attribute("label").length()) return XML(item).attribute("label").toString(); 

				if (XML(item).attribute("name").length()) return XML(item).attribute("name").toString(); 

				return XML(item).localName() as String; 

			}

			if (item is DisplayObject) {
				var string : String = "[" + getQualifiedClassName(item).replace(/^.*::/, "") + "]";
				if (DisplayObject(item).name && DisplayObject(item).name.indexOf("instance") != 0) string += " " + DisplayObject(item).name;
				return string;
			}

			try {
				if (item["label"]) return item["label"];
			} catch (e : Error) {
				
			}
			
			try {
				if (item["name"]) return item["name"];
			} catch (e : Error) {
				
			}
			
			return "[" + getQualifiedClassName(item).replace(/^.*.::/, "") + "]";

	}

}
