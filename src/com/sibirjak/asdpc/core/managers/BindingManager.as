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
	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.framework.ISet;

	/**
	 * Data binding manager.
	 * 
	 * <p>Any object (display object, data object, ...) may define an unlimited
	 * number of bindable properties. A bound listener automatically gets updated
	 * if its bindable property changes. E.g. a DisplayObject's visibility can
	 * be directly bound to a toggle button's selected property without the need
	 * of implementing custom event listeners for the ButtonEvent.SELECTION_CHANGED
	 * event.</p>
	 * 
	 * <p>The BindingManager implements all necessary code to maintain listeners
	 * and property changes and updates. The class that hosts the bindable
	 * property is in charge to trigger updates after the property changes.</p>  
	 * 
 	 * <listing>
		var label : ILabel = new Label();
		label.text = "I am visible only if the button is selected";
		addChild(DisplayObject(label));

		var button : IButton = new Button();
		button.toggle = true;
		button.label = "Toggle";
		button.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, label, "visible");
		addChild(DisplayObject(button));
	 * </listing>
	 * 
 	 * <listing>
		private function setVisibility(visible : Boolean) : void {
			trace ("Visible: ", visible);
		}

		var button : IButton = new Button();
		button.toggle = true;
		button.label = "Toggle";
		button.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, setVisibility);
		addChild(DisplayObject(button));
	 * </listing>
	 * 
	 * @author jes 03.12.2009
	 */
	public class BindingManager extends LinkedMap {

		/**
		 * The instance that defines a bindable property.
		 */
		private var _client : Object;

		/**
		 * The owner.
		 */
		private var _bindableProperties : Object;

		/**
		 * BindingManager constructor.
		 * 
		 * @param client The instance that defines a bindable property.
		 */
		public function BindingManager(client : Object) {
			_client = client;
			_bindableProperties = new Object();
		}

		/**
		 * Sets a list of bindable properties.
		 * 
		 * <p>If not enabled by this setter, binding of a property does not work.</p>
		 * 
		 * <p>This list is usually set within the constructor of the client.</p>
		 * 
		 * @param properties A list of bindable properties.
		 */
		public final function setBindableProperties(properties : Array) : void {
			for (var i : int = 0; i < properties.length; i ++) {
				_bindableProperties[properties[i]] = true;
			}
		}

		/**
		 * Binds a listener (bound listener) to a bindable property.
		 * 
		 * @param propertyName The name of the property to bind.
		 * @param listener A function reference or the object that hosts the property,
		 * that should be updated automatically.
		 * @param listenerPropertyName The listener property, that should be updated automatically.
		 * @return True, if the binding could be established.
		 */
		public function bindProperty(propertyName : String, listener : Object, listenerPropertyName : String = null) : Boolean {
			if (!_bindableProperties[propertyName]) return false;
			
			var listeners : LinkedMap = itemFor(propertyName);
			if (!listeners) {
				listeners = new LinkedMap();
				add(propertyName, listeners);
			}
			
			var listenerProperties : ISet = listeners.itemFor(listener);
			if (!listenerProperties) {
				listenerProperties = new LinkedSet();
				listeners.add(listener, listenerProperties);
			}
			listenerProperties.add(listenerPropertyName);
			
			return true;
		}

		/**
		 * Unbinds a formerly bound listener from a bindable property.
		 * 
		 * @param propertyName The name of the property to unbind.
		 * @param listener A function reference or the object that hosts the property,
		 * that was updated automatically.
		 * @param listenerPropertyName The listener property, that was updated automatically.
		 */
		public function unbindProperty(propertyName : String, listener : Object, listenerPropertyName : String = null) : void {
			if (!_bindableProperties[propertyName]) return;

			var listeners : LinkedMap = itemFor(propertyName);
			
			if (listeners) {
				var listenerProperties : ISet = listeners.itemFor(listener);
				if (listenerProperties) {
					listenerProperties.remove(listenerPropertyName);
					if (!listenerProperties.size) {
						listeners.removeKey(listener);
						if (!listeners.size) {
							removeKey(propertyName);
						}
					}
				}
			}
		}
		
		/**
		 * Commands the BindingManager to update all bound listeners of a certain property.
		 * 
		 * <p>This method is invoked by the binding client usually after is has
		 * been fully initialised.</p>
		 * 
		 * @param propertyName The name of the bound property.
		 * @param listeners A map of all listeners of that property (only passed internally).
		 */
		public function updateBindingsForProperty(propertyName : String, listeners : LinkedMap = null) : void {
			if (!_bindableProperties[propertyName]) return;
			
			if (!listeners) listeners = itemFor(propertyName);
			
			if (listeners) {
				var listener : Object;
				var listenerProperties : ISet;
				var listenerPropertiesIterator : IIterator;

				var iterator : IMapIterator = listeners.iterator() as IMapIterator;
				while (iterator.hasNext()) {
					listenerProperties = iterator.next();
					listener = iterator.key;
					
					listenerPropertiesIterator = listenerProperties.iterator();
					while (listenerPropertiesIterator.hasNext()) {
						updateBinding(propertyName, listener, listenerPropertiesIterator.next());
					}
				}
			}
		}
		
		/**
		 * Commands the BindingManager to update all bound listeners of a all properties.
		 * 
		 * <p>This method is invoked by the binding client usually after is has
		 * been fully initialised. A View instance would do this in its initialised()
		 * method.</p>
		 */
		public function updateAllBindings() : void {
			var propertyName : String;
			var listeners : LinkedMap;
			var propertyIterator : IMapIterator = iterator() as IMapIterator;
			
			while (propertyIterator.hasNext()) {
				listeners = propertyIterator.next();
				propertyName = propertyIterator.key;
				
				updateBindingsForProperty(propertyName, listeners);
			}
		}
		
		/**
		 * Commands the BindingManager to update a bound listeners of a certain properties.
		 * 
		 * <p>This method is invoked by the binding client usually immediately after a new
		 * listener has been bound to a property.</p>
		 * 
		 * @param propertyName The name of the bound property.
		 * @param listener A function reference or the object that hosts the property,
		 * that shall be updated automatically.
		 * @param listenerPropertyName The listener property, that shall be updated automatically.
		 */
		public function updateBinding(propertyName : String, listener : Object, listenerProperty : String) : void {
			if (listener is Function) {
				(listener as Function).call(null, _client[propertyName]);
			} else {
				listener[listenerProperty] = _client[propertyName];
			}
		}

		/**
		 * Removes all bindings.
		 */
		public function removeAllBindings() : void {
			clear();
		}
	}
}
