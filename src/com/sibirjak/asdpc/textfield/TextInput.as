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
package com.sibirjak.asdpc.textfield {
	import com.sibirjak.asdpc.textfield.core.TextFieldBase;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	/*
	 * Styles
	 */

	/**
	 * @copy TextInputStyles#defaultTextColor
	 */
	[Style(name="textInput_defaultTextColor", type="uint", format="Color")]

	/**
	 * @copy TextInputStyles#restrict
	 */
	[Style(name="textInput_restrict", type="String", format="Chars")]

	/**
	 * @copy TextInputStyles#maxChars
	 */
	[Style(name="textInput_maxChars", type="uint", format="Quantity")]

	/*
	 * TextInputEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.textfield.TextInputEvent.FOCUS_IN
	 */
	[Event(name="textInput_focusIn", type="com.sibirjak.asdpc.textfield.TextInputEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.textfield.TextInputEvent.FOCUS_OUT
	 */
	[Event(name="textInput_focusOut", type="com.sibirjak.asdpc.textfield.TextInputEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.textfield.TextInputEvent.CHANGED
	 */
	[Event(name="textInput_changed", type="com.sibirjak.asdpc.textfield.TextInputEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.textfield.TextInputEvent.CANCEL
	 */
	[Event(name="textInput_cancel", type="com.sibirjak.asdpc.textfield.TextInputEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.textfield.TextInputEvent.SUBMIT
	 */
	[Event(name="textInput_submit", type="com.sibirjak.asdpc.textfield.TextInputEvent")]

	/**
	 * TextInput component.
	 * 
	 * @author jes 04.11.2009
	 */
	public class TextInput extends TextFieldBase implements ITextInput {

		/* style declarations */

		/**
		 * Central accessor to all TextInput style property definitions.
		 */
		public static var style : TextInputStyles = new TextInputStyles();
		
		/* changeable properties or styles */

		/**
		 * Name constant for the default text invalidation property.
		 */
		protected const UPDATE_PROPERTY_DEFAULT_TEXT : String = "default_text";

		/* properties */

		/**
		 * The default textfield content.
		 */
		protected var _defaultText : String = "";

		/* internal */
		
		/**
		 * Tracks the focus.
		 */
		private var _hasFocus : Boolean;

		/**
		 * TextInput constructor.
		 */
		public function TextInput() {

			setDefaultStyles([
				style.selectable, true, // override default
				style.background, true, // override default
				style.border, true, // override default

				style.defaultTextColor, 0x777777,
				style.restrict, "",
				style.maxChars, 400
			]);
		}
		
		/*
		 * ITextInput
		 */
		
		/**
		 * @inheritDoc
		 */
		public function set defaultText(defaultText : String) : void {
			if (_defaultText == defaultText) return;
			
			// reset old tf default text
			if (_initialised && _defaultText && _tf.text == _defaultText) _tf.text = "";
			
			_defaultText = defaultText;
			
			invalidateProperty(UPDATE_PROPERTY_DEFAULT_TEXT);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get defaultText() : String {
			return _defaultText;
		}

		/**
		 * @inheritDoc
		 */
		public function setSelection(startIndex : uint, endIndex : uint) : void {
			if (!_initialised) return;

			_tf.setSelection(startIndex, endIndex);
		}

		/**
		 * @inheritDoc
		 */
		public function scrollTo(scrollPosition : uint) : void {
			if (!_initialised) return;

			_tf.scrollH = scrollPosition;
		}

		/**
		 * @inheritDoc
		 */
		public function setFocus() : void {
			if (!_initialised) return;
			
			stage.focus = _tf;
		}

		/**
		 * @inheritDoc
		 */
		public function clearFocus() : void {
			if (!_initialised) return;

			if (stage.focus == _tf) {
				_hasFocus = false;
				stage.focus = null;
			}
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		override public function toString() : String {
			return "[TextInput] " + _text;
		}

		/*
		 * TextFieldBase protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function setTextFieldProperties() : void {
			_tf.type = TextFieldType.INPUT;
			
			var restrict : String = getStyle(style.restrict);
			if (restrict) _tf.restrict = restrict;

			var maxChars : uint = getStyle(style.maxChars);
			if (maxChars) _tf.maxChars = maxChars;
		}

		/**
		 * @inheritDoc
		 */
		override protected function layoutTextField() : void {
			/*
			 * Remove text field to untie from ancestor scalings.
			 * Without doing this, the _tf.textWidth information
			 * considers any parent scaling and becomes invalid.
			 * 
			 * tf at display list: width:900.4946594238281, height:200.10992431640625
			 * tf not at display list: width:42, height:12
			 */
			var childIndex : int = getChildIndex(_tf);
			removeChild(_tf);
			
			if (_tf.textHeight < _height) {
				_tf.y = Math.round((_height - (_tf.textHeight + 4)) / 2);
			}

			/*
			 * Add text field again
			 */

			addChildAt(_tf, childIndex);
		}
		
		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		protected override function draw() : void {
			super.draw(); // creates text field and adds it at 0
			
			// apply default text and color
			if (!_tf.text && _defaultText) {
				_tf.text = _defaultText;
				_tf.textColor = getStyle(style.defaultTextColor);
			}
			
			/*
			 * FocusEvent.FOCUS_IN does not allow setSelection() to operate as expected.
			 * Changed it to MouseEvent.CLICK and it works correctly.
			 * http://www.untoldentertainment.com/blog/2008/01/11/as3-pitfalls-textfieldsetselection-not-working/
			 */

			_tf.addEventListener(MouseEvent.MOUSE_DOWN , mouseDownHandler); // focus in
			_tf.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, focusChangeHandler); // track focus out
			_tf.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler); // focus out
			_tf.addEventListener(Event.CHANGE, changeHandler); // text input
			_tf.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler); // track special keys

		}

		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			super.update();

			// update tf text only if not currently focused to prevent
			// the default text highlighting during the input
			if (!_hasFocus) {
				if (isInvalid(UPDATE_PROPERTY_TEXT) || isInvalid(UPDATE_PROPERTY_DEFAULT_TEXT)) {
					if ((!_tf.text || _tf.text == _defaultText) && _defaultText) {
						_tf.text = _defaultText;
						_tf.textColor = getStyle(style.defaultTextColor);
	
					} else {
						_tf.text = _text;
						_tf.textColor = getStyle(style.color);
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property.indexOf("treeNodeRenderer_") == 0) {
				invalidateProperty(UPDATE_PROPERTY_DEFAULT_TEXT);
				
			} else {
				super.styleChanged(property, value);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			_tf.removeEventListener(MouseEvent.MOUSE_DOWN , mouseDownHandler); // focus in
			_tf.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, focusChangeHandler); // track focus out
			_tf.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler); // focus out
			_tf.removeEventListener(Event.CHANGE, changeHandler); // text input
			_tf.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler); // track special keys
		}

		/*
		 * Events
		 */

		/**
		 * Click event handler.
		 */
		private function mouseDownHandler(event : MouseEvent) : void {
			if (_hasFocus) return;
			
			_hasFocus = true;
			
			if (_tf.text == _defaultText) {
				_tf.text = "";
				_tf.textColor = getStyle(style.color);
			}
			
			dispatchEvent(new TextInputEvent(TextInputEvent.FOCUS_IN));
		}

		/**
		 * Key up handler.
		 */
		private function keyUpHandler(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.ENTER) {
				dispatchEvent(new TextInputEvent(TextInputEvent.SUBMIT));
			}
			if (event.keyCode == Keyboard.ESCAPE) {
				dispatchEvent(new TextInputEvent(TextInputEvent.CANCEL));
			}
		}

		/**
		 * Text change handler.
		 */
		private function changeHandler(event : Event) : void {
			text = _tf.text;
			dispatchEvent(new TextInputEvent(TextInputEvent.CHANGED));
		}

		/**
		 * Focus change handler.
		 */
		private function focusChangeHandler(event : FocusEvent) : void {
			_hasFocus = false;

			if ((!_tf.text || _tf.text == _defaultText) && _defaultText) {
				_tf.text = _defaultText;
				_tf.textColor = getStyle(style.defaultTextColor);
			}
		}

		/**
		 * Focus leave handler.
		 */
		private function focusOutHandler(event : FocusEvent) : void {
			dispatchEvent(new TextInputEvent(TextInputEvent.FOCUS_OUT));
		}

	}
}
