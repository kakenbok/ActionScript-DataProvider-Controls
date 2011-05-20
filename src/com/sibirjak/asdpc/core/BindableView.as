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
package com.sibirjak.asdpc.core {
	import com.sibirjak.asdpc.core.managers.BindingManager;

	/**
	 * View with binding capabilities.
	 * 
	 * @author jes 16.12.2009
	 */
	public class BindableView extends View implements IBindableView {

		/**
		 * BindingManager instance.
		 */
		private var _bindingManager : BindingManager;

		/**
		 * BindableView constructor.
		 */
		public function BindableView() {
			_bindingManager = new BindingManager(this);
		}

		/*
		 * IBindableView
		 */
		
		/**
		 * @copy com.sibirjak.asdpc.core.managers.BindingManager#bindProperty()
		 */
		public final function bindProperty(propertyName : String, listener : Object, listenerPropertyName : String = null) : void {
			var bound : Boolean = _bindingManager.bindProperty(propertyName, listener, listenerPropertyName);
			if (_initialised && bound) {
				_bindingManager.updateBinding(propertyName, listener, listenerPropertyName);
			}
		}

		/**
		 * @copy com.sibirjak.asdpc.core.managers.BindingManager#unbindProperty()
		 */
		public final function unbindProperty(propertyName : String, listener : Object, listenerPropertyName : String = null) : void {
			_bindingManager.unbindProperty(propertyName, listener, listenerPropertyName);
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			removeAllBindings();
		}

		/*
		 * Protected
		 */

		/**
		 * @copy com.sibirjak.asdpc.core.managers.BindingManager#setBindableProperties()
		 */
		protected final function setBindableProperties(properties : Array) : void {
			_bindingManager.setBindableProperties(properties);
		}

		/**
		 * @copy com.sibirjak.asdpc.core.managers.BindingManager#updateAllBindings()
		 */
		protected final function updateAllBindings() : void {
			_bindingManager.updateAllBindings();
		}

		/**
		 * Updates all listeners of a certain property.
		 * 
		 * @param propertyName The name of the bound property.
		 */
		protected final function updateBindingsForProperty(propertyName : String) : void {
			_bindingManager.updateBindingsForProperty(propertyName);
		}

		/**
		 * @copy com.sibirjak.asdpc.core.managers.BindingManager#removeAllBindings()
		 */
		public final function removeAllBindings() : void {
			_bindingManager.removeAllBindings();
		}

	}
}
