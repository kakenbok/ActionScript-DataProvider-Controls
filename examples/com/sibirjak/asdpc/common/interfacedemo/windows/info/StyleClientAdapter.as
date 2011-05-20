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
	import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;
	import com.sibirjak.asdpc.core.managers.IStyleManagerClient;
	import com.sibirjak.asdpc.core.managers.StyleManager;
	import com.sibirjak.asdpcbeta.colorpicker.core.ColorUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author jes 26.01.2010
	 */
	public class StyleClientAdapter implements IDataSourceAdapter {
		
		private var _client : IStyleManagerClient;
		private var _children : Array;
		
		public function StyleClientAdapter(client : IStyleManagerClient) {
			_client = client;
			
			_children = new Array();
			
			var styleContainer : StyleContainer = new StyleContainer();
			
			var styleManager : StyleManager = _client.styleManager;
			
			var value : *;
			
			var defaultStyles : Array = styleManager.getDefaultStyles();
			var property : String;
			
			var i : uint;

			for (i = 0; i < defaultStyles.length; i++) {
				property = defaultStyles[i];
				value = styleManager.getStyle(property);
				
				if (value is Array) {
					if (property.indexOf("Colors") > -1) {
						var colors : Array = new Array();
						if (!isNaN(value[0])) colors.push(ColorUtil.hexToString(value[0]));
						if (!isNaN(value[1])) colors.push(ColorUtil.hexToString(value[1]));
						
						styleContainer.add(new Style(property, colors.join(", ")));

					} else {
						styleContainer.add(new Style(property, value));
					}
					
				} else {
					if (property.indexOf("olor") > -1) value = ColorUtil.hexToString(value);
					styleContainer.add(new Style(property, value));
					
				}
				
				
			}
			
			if (styleContainer.size) _children.push(styleContainer);
			
			var child : DisplayObject;
			
			i = 0;
			
			if (_client is DisplayObjectContainer) {
			
				while (i < DisplayObjectContainer(_client).numChildren) {
					child = DisplayObjectContainer(_client).getChildAt(i);
					
					if (child is IStyleManagerClient) {
						_children.push(child);
					}
					i++;
				}
			
			}
		}

		
		public function itemAt(index : uint) : * {
			return _children[index];
		}
		
		public function get size() : uint {
			return _children.length;
		}

		public function get dataSource() : * {
			return _client;
		}

		public function cleanUp() : void {
		}
	}
}
