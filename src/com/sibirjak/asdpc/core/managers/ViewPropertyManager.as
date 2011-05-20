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
package com.sibirjak.asdpc.core.managers {
	import flash.display.DisplayObject;

	/**
	 * Generic property manager for display objects.
	 * 
	 * <p>Often a child display object needs to be consistent to an ancector state.
	 * E.g. the rotation of the arrow icon of a ScrollBar button depends on the
	 * ScrollBar direction. A ViewPropertyManager simply stores property-value-pairs
	 * that can be easily received by a traversal of the parent chain of a child
	 * object. This way even custom programmatic skins, who not extend the core
	 * View class may obtain information about their parents.</p>
	 * 
	 * <listing>
		in ScrollBar:
		----------------------------------
		setViewProperty(VIEW_PROPERTY_SCROLLBAR_DIRECTION, _direction);
		...
		_upButton.setViewProperty(VIEW_PROPERTY_SCROLLBAR_BUTTON, UP_BUTTON_NAME);

		
		in ScrollButtonIconSkin:
		----------------------------------
		var direction : String = getViewProperty(ScrollBar.VIEW_PROPERTY_SCROLLBAR_DIRECTION);
		...
		var buttonName : String = getViewProperty(ScrollBar.VIEW_PROPERTY_SCROLLBAR_BUTTON);
		...
		if (direction == Direction.VERTICAL &#38;&#38; buttonName == ScrollBar.DOWN_BUTTON_NAME) {
			icon.rotation = 180;
		}

		or in CustomSkin:
		----------------------------------
		var direction : String = ViewPropertyManager.getViewProperty(this, ScrollBar.VIEW_PROPERTY_SCROLLBAR_DIRECTION);
		...
		var buttonName : String = ViewPropertyManager.getViewProperty(this, ScrollBar.VIEW_PROPERTY_SCROLLBAR_BUTTON);
		...
		if (direction == Direction.VERTICAL &#38;&#38; buttonName == ScrollBar.DOWN_BUTTON_NAME) {
			icon.rotation = 180;
		}
	 * </listing>
	 * 
	 * @author jes 03.12.2009
	 */
	public class ViewPropertyManager {
		
		/**
		 * The owner.
		 */
		private var _client : IViewPropertyManagerClient;

		/**
		 * The properties.
		 */
		private var _properties : Object;

		/**
		 * ViewPropertyManager constructor.
		 * 
		 * @param client The property hosting client.
		 */
		public function ViewPropertyManager(client : IViewPropertyManagerClient) {
			_client = client;
			
			_properties = new Object();
		}

		/**
		 * Sets a property.
		 * 
		 * <p>Properties can be used to enable state distinction by display
		 * descendants.</p>
		 * 
		 * @param property The name of the property.
		 * @param value The value of the property.
		 */
		public final function setViewProperty(property : String, value : *) : void {
			_properties[property] = value;
		}
		
		/**
		 * Gets a property value.
		 * 
		 * @param property The name of the property.
		 * @return The value of the property.
		 */
		public final function getViewProperty(property : String) : * {
			return ViewPropertyManager.getViewProperty(DisplayObject(_client), property);
		}
		
		/**
		 * Gets a property value via the static interface.
		 * 
		 * @param displayObject The display object from that the lookup starts.
		 * @param property The name of the property.
		 * @return The value of the property.
		 */
		public static function getViewProperty(displayObject : DisplayObject, property : String) : * {
			var value : *;
			
			while (displayObject) {
				if (displayObject is IViewPropertyManagerClient) {
					value = IViewPropertyManagerClient(displayObject).viewPropertyManager._properties[property];
					if (value !== undefined) return value;
				}
				
				displayObject = displayObject.parent;
			}
			
			return null;
		}

	}
}
