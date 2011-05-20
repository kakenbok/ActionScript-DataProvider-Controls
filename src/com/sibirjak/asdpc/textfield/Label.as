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
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.textfield.core.TextFieldBase;

	import flash.text.TextFieldAutoSize;

	/*
	 * Styles
	 */

	/**
	 * @copy LabelStyles#fittingMode
	 */
	[Style(name="label_fittingMode", type="String", enumeration="scale, chop, none")]

	/**
	 * @copy LabelStyles#horizontalAlign
	 */
	[Style(name="label_horizontalAlign", type="String", enumeration="left, center, right")]

	/**
	 * @copy LabelStyles#verticalAlign
	 */
	[Style(name="label_verticalAlign", type="String", enumeration="top, middle, bottom")]

	/**
	 * @copy LabelStyles#borderType
	 */
	[Style(name="label_borderType", type="String", enumeration="label, text")]

	/*
	 * LabelEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.textfield.LabelEvent.INNER_SIZE_CHANGED
	 */
	[Event(name="label_sizeChanged", type="com.sibirjak.asdpc.textfield.LabelEvent")]

	/**
	 * Label component.
	 * 
	 * @author jes
	 */
	public class Label extends TextFieldBase implements ILabel {
		
		/* style declarations */

		/**
		 * Central accessor to all Label style property definitions.
		 */
		public static var style : LabelStyles = new LabelStyles();

		/* constants */

		/**
		 * Name constant defining the fitting mode scale.
		 */
		public static const FITTING_MODE_SCALE : String = "scale";

		/**
		 * Name constant defining the fitting mode chop first.
		 */
		public static const FITTING_MODE_CHOP_FIRST : String = "chop_first";

		/**
		 * Name constant defining the fitting mode chop center.
		 */
		public static const FITTING_MODE_CHOP_CENTER : String = "chop_center";

		/**
		 * Name constant defining the fitting mode chop last.
		 */
		public static const FITTING_MODE_CHOP_LAST : String = "chop_last";

		/**
		 * Name constant defining the fitting mode none.
		 */
		public static const FITTING_MODE_NONE : String = "none";
		
		/**
		 * Name constant defining the the border type label.
		 */
		public static const BORDER_TYPE_LABEL : String = "label";

		/**
		 * Name constant defining the border type text.
		 */
		public static const BORDER_TYPE_TEXT : String = "text";

		/* internals */
		
		/**
		 * True, if the text has been chopped to fit into the label dimensions.
		 */
		private var _textChopped : Boolean = false;

		/**
		 * True, if the text has been scaled to fit into the label dimensions.
		 */
		private var _textScaled : Boolean = false;
		
		/**
		 * Label constructor.
		 */
		public function Label() {
			
			setDefaultStyles([
				style.fittingMode, FITTING_MODE_CHOP_LAST,
				style.horizontalAlign, Position.LEFT,
				style.verticalAlign, Position.TOP,
				style.borderType, BORDER_TYPE_LABEL
			]);
		}

		/*
		 * ILabel
		 */

		/**
		 * @inheritDoc
		 */
		public function get innerWidth() : uint {
			return _tf ? _tf.width : _width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get innerHeight() : uint {
			return _tf ? _tf.height : _height;
		}

		public function get textChopped() : Boolean {
			return _textChopped;
		}

		/*
		 * Info
		 */

		/**
		 * toString() function.
		 */
		override public function toString() : String {
			return "[Label] " + _text;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			super.update();

			if (shouldUpdate(COMMIT_PROPERTY_TEXT_FIELD_SIZE)
			|| shouldUpdate(COMMIT_PROPERTY_TEXT_SIZE)) {
				if (getStyle(style.borderType) == BORDER_TYPE_TEXT) {
					updateProperty(COMMIT_PROPERTY_BACKGROUND);
					updateProperty(COMMIT_PROPERTY_BORDER);
				}
			}
		}

		/*
		 * TextFieldBase protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function setTextFieldProperties() : void {
			_tf.autoSize = TextFieldAutoSize.LEFT;
		}

		/**
		 * @inheritDoc
		 */
		override protected function layoutTextField() : void {
			
			/*
			 * Fit text
			 */

			if (_textChopped) {
				_tf.text = _text;
				_textChopped = false;
			}
			
			if (_textScaled) {
				_tf.scaleX = _tf.scaleY = 1;
				_textScaled = false;
			}
			
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

			/*
			 * Check text size and resize if necessary
			 */

			var maxTextWidth : uint = Math.max(0, _width - 4);
			var maxTextHeight : uint = Math.max(0, _height - 4);
			
			if (_tf.textWidth > maxTextWidth || _tf.textHeight > maxTextHeight) {
				
				var fittingMode : String = getStyle(style.fittingMode);

				// fit text into label dimensions
				if (fittingMode == FITTING_MODE_SCALE) {
					_tf.scaleX = _tf.scaleY = Math.min(1, maxTextWidth / (_tf.width - 4), maxTextHeight / (_tf.height - 4));

					_textScaled = true;
				}
				
				// cut text
				else if (_tf.textWidth > maxTextWidth && fittingMode != FITTING_MODE_NONE) {
					_tf.text = "...";
					var periodWidth : Number = _tf.textWidth;
					var leftTextWidth : uint = maxTextWidth - periodWidth;
					var tmpText : String;
					
					// if even just the periods exceed the width -> nullify text content
					if (periodWidth > maxTextWidth) {
						_tf.text = "";

					// remove chars till the text fits into the left space
					} else if (periodWidth < maxTextWidth) {
						_tf.text = _text;
						
						while (_tf.textWidth > leftTextWidth) {
							var maxLength : uint = _tf.length / (_tf.textWidth / leftTextWidth);

							if (fittingMode == FITTING_MODE_CHOP_LAST) {
								_tf.text = _tf.text.substr(0, maxLength);

							} else if (fittingMode == FITTING_MODE_CHOP_FIRST) {
								_tf.text = _tf.text.substr(- maxLength, maxLength);

							} else { // center
								if (maxLength % 2) maxLength--;
								tmpText = _tf.text.substr(0, maxLength / 2);
								tmpText += _tf.text.substr(- maxLength / 2, maxLength / 2);
								_tf.text = tmpText;
							}

						}
						
						if (fittingMode == FITTING_MODE_CHOP_LAST) {
							_tf.text += "...";

						} else if (fittingMode == FITTING_MODE_CHOP_FIRST) {
							_tf.text = "..." + _tf.text;
							
						} else { // center
							tmpText = _tf.text.substr(0, _tf.text.length / 2);
							tmpText += "...";
							tmpText += _tf.text.substr(- _tf.text.length / 2, _tf.text.length / 2);
							_tf.text = tmpText;
						}
					}

					_textChopped = true;
				}

			}

			/*
			 * Set text field position
			 */

			// align tf
			var horizontalAlign : String = getStyle(style.horizontalAlign);
			switch (horizontalAlign) {
				case Position.LEFT:
					_tf.x = 0;
					break;
				case Position.RIGHT:
					_tf.x = Math.round(_width - _tf.width);
					break;
				case Position.CENTER:
					_tf.x = Math.round((_width - _tf.width) / 2);
					break;
			}
			
			var verticalAlign : String = getStyle(style.verticalAlign);
			switch (verticalAlign) {
				case Position.TOP:
					_tf.y = 0;
					break;
				case Position.BOTTOM:
					_tf.y = Math.round(_height - _tf.height);
					break;
				case Position.MIDDLE:
					_tf.y = Math.round((_height - _tf.height) / 2);
					break;
			}
			
			/*
			 * Add text field again
			 */

			addChildAt(_tf, childIndex);
			
			var event : LabelEvent = new LabelEvent(LabelEvent.INNER_SIZE_CHANGED);
			event.chopped = _textChopped;
			dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawBorder() : void {
			if (getStyle(style.borderType) == BORDER_TYPE_LABEL) {
				super.drawBorder();
				return;
			}
			
			with (_border.graphics) {
				clear();
				lineStyle(0, getStyle(style.borderDarkColor));
				drawRect(0, Math.round((_height - _tf.height) / 2), _tf.width - 1, _tf.height - 1);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function drawBackground() : void {
			if (getStyle(style.borderType) == BORDER_TYPE_LABEL) {
				super.drawBackground();
				return;
			}
			
			with (_background.graphics) {
				clear();
				beginFill(getStyle(style.backgroundColor));
				drawRect(0, Math.round((_height - _tf.height) / 2), _tf.width, _tf.height);
			}
		}
		
	}
}
