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
package com.sibirjak.asdpcbeta.radiobutton {
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.core.managers.BindingManager;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * @author jes 02.12.2009
	 */
	public class RadioGroup extends EventDispatcher {
		
		public static const BINDABLE_PROPERTY_SELECTED_VALUE : String = "selectedValue";
		
		private var _selectedButton : IRadioButton;
		private var _valueButtonMap : IMap;
		private var _bindingManager : BindingManager;

		private var _enabled : Boolean = true;

		public function RadioGroup(target : IEventDispatcher = null) {
			_valueButtonMap = new Map();

			_bindingManager = new BindingManager(this);
			_bindingManager.setBindableProperties([BINDABLE_PROPERTY_SELECTED_VALUE]);
		}
		
		public function set enabled(enabled : Boolean) : void {
			if (enabled == _enabled) return;
			
			_enabled = enabled;
			
			if (_valueButtonMap.size) {
				var button : IRadioButton;
				var iterator : IIterator = _valueButtonMap.iterator();
				while (iterator.hasNext()) {
					button = iterator.next();
					button.enabled = _enabled;
				}
			}
		}

		public function setButtons(buttons : Array) : void {
			var button : IRadioButton;
			for (var i : int = 0; i < buttons.length; i++) {
				button = buttons[i];
				button.enabled = _enabled;
				_valueButtonMap.add(button.value, button);
				button.addEventListener(ButtonEvent.SELECTION_CHANGED, buttonSelectionChangeHandler);
				if (button.selected) {
					if (_selectedButton) button.selected = false; // more than one button selected by default
					else _selectedButton = button;
				}

			}
			
			_bindingManager.updateAllBindings();
		}

		public function unregisterButton(button : IRadioButton) : void {
			button.removeEventListener(ButtonEvent.SELECTION_CHANGED, buttonSelectionChangeHandler);
			_valueButtonMap.removeKey(button.value);
		}

		public function cleanUp() : void {
			var iterator : IIterator = _valueButtonMap.iterator();
			while (iterator.hasNext()) {
				IRadioButton(iterator.next()).removeEventListener(ButtonEvent.SELECTION_CHANGED, buttonSelectionChangeHandler);
			}
			_valueButtonMap.clear();
		}

		public function bindProperty(propertyName : String, listener : Object, listenerPropertyName : String = null) : void {
			var bound : Boolean = _bindingManager.bindProperty(propertyName, listener, listenerPropertyName);
			if (_valueButtonMap.size && bound) {
				_bindingManager.updateBinding(propertyName, listener, listenerPropertyName);
			}
		}

		public function unbindProperty(propertyName : String, listener : Object, listenerPropertyName : String = null) : void {
			_bindingManager.unbindProperty(propertyName, listener, listenerPropertyName);
		}
		
		private function buttonSelectionChangeHandler(event : ButtonEvent) : void {
			var button : IRadioButton = event.currentTarget as IRadioButton;
			
			if (button.selected) {
				if (_selectedButton) _selectedButton.selected = false;
				_selectedButton = button;
			} else {
				_selectedButton = null;
			}
			
			_bindingManager.updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_VALUE);
			
			dispatchEvent(new RadioGroupEvent(RadioGroupEvent.CHANGE, selectedValue));
		}
		
		public function get selectedValue() : * {
			if (_selectedButton) return _selectedButton.value;
			return null;
		}

		public function set selectedValue(value : *) : void {
			// deselect everything by passing null
			if (value == null && _selectedButton) {
				_selectedButton.selected = false;
				_selectedButton = null;
				return;
			}
			
			// value not specified - do nothing
			if (!_valueButtonMap.hasKey(value)) return;

			// value already selected
			if (_selectedButton && _selectedButton.value == value) return;

			// deselect current selection
			if (_selectedButton) _selectedButton.selected = false;
			// select new button
			_selectedButton = _valueButtonMap.itemFor(value);
			_selectedButton.selected = true;
			
			// update bindings
			_bindingManager.updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_VALUE);
		}

	}
}
