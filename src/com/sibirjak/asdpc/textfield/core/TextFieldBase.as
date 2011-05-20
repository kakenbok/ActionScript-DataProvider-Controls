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
package com.sibirjak.asdpc.textfield.core {

	import com.sibirjak.asdpc.core.View;

	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/*
	 * Styles
	 */

	/**
	 * @copy TextFieldBaseStyles#selectable
	 */
	[Style(name="textFieldBase_selectable", type="Boolean")]

	/**
	 * @copy TextFieldBaseStyles#color
	 */
	[Style(name="textFieldBase_color", type="uint", format="Color")]

	/**
	 * @copy TextFieldBaseStyles#embedFont
	 */
	[Style(name="textFieldBase_embedFont", type="Boolean")]

	/**
	 * @copy TextFieldBaseStyles#embedFont
	 */
	[Style(name="textFieldBase_embedFont", type="Boolean")]

	/**
	 * @copy TextFieldBaseStyles#antiAliasType
	 */
	[Style(name="textFieldBase_antiAliasType", type="String", enumeration="advanced, normal")]

	/**
	 * @copy TextFieldBaseStyles#font
	 */
	[Style(name="textFieldBase_font", type="String", format="Font name")]

	/**
	 * @copy TextFieldBaseStyles#size
	 */
	[Style(name="textFieldBase_size", type="uint", format="Size")]

	/**
	 * @copy TextFieldBaseStyles#bold
	 */
	[Style(name="textFieldBase_bold", type="Boolean")]

	/**
	 * @copy TextFieldBaseStyles#underline
	 */
	[Style(name="textFieldBase_underline", type="Boolean")]

	/**
	 * @copy TextFieldBaseStyles#letterSpacing
	 */
	[Style(name="textFieldBase_letterSpacing", type="Number")]

	/**
	 * @copy TextFieldBaseStyles#background
	 */
	[Style(name="textFieldBase_background", type="Boolean")]

	/**
	 * @copy TextFieldBaseStyles#backgroundColor
	 */
	[Style(name="textFieldBase_backgroundColor", type="uint", format="Color")]

	/**
	 * @copy TextFieldBaseStyles#border
	 */
	[Style(name="textFieldBase_border", type="Boolean")]

	/**
	 * @copy TextFieldBaseStyles#borderLightColor
	 */
	[Style(name="textFieldBase_borderLightColor", type="uint", format="Color")]

	/**
	 * @copy TextFieldBaseStyles#borderDarkColor
	 */
	[Style(name="textFieldBase_borderDarkColor", type="uint", format="Color")]


	/**
	 * Base class for all text fields.
	 * 
	 * @author jes 04.11.2009
	 */
	public class TextFieldBase extends View {

		/* style declarations */

		/**
		 * Central accessor to all TextFieldBase style property definitions.
		 */
		public static var style : TextFieldBaseStyles = new TextFieldBaseStyles();

		/* changeable properties or styles */

		/**
		 * Name constant for the text invalidation property.
		 */
		protected const UPDATE_PROPERTY_TEXT : String = "text";

		/**
		 * Name constant for the text format invalidation property.
		 */
		protected const UPDATE_PROPERTY_TEXT_FORMAT : String = "text_format";

		/**
		 * Name constant for the color invalidation property.
		 */
		protected const UPDATE_PROPERTY_COLOR : String = "color";

		/**
		 * Name constant for the selectable invalidation property.
		 */
		protected const UPDATE_PROPERTY_SELECTABLE: String = "selectable";

		/**
		 * Name constant for the background invalidation property.
		 */
		protected const UPDATE_PROPERTY_BACKGROUND : String = "background";

		/**
		 * Name constant for the background color invalidation property.
		 */
		protected const UPDATE_PROPERTY_BACKGROUND_COLOR : String = "background_color";

		/**
		 * Name constant for the border invalidation property.
		 */
		protected const UPDATE_PROPERTY_BORDER : String = "border";

		/**
		 * Name constant for the border color invalidation property.
		 */
		protected const UPDATE_PROPERTY_BORDER_COLOR : String = "border_color";

		/**
		 * Name constant for the text field size update property.
		 */
		protected const COMMIT_PROPERTY_TEXT_FIELD_SIZE : String = "text_field_size";

		/**
		 * Name constant for the text size update property.
		 */
		protected const COMMIT_PROPERTY_TEXT_SIZE : String = "text_size";

		/**
		 * Name constant for the background update property.
		 */
		protected const COMMIT_PROPERTY_BACKGROUND : String = "background";

		/**
		 * Name constant for the border update property.
		 */
		protected const COMMIT_PROPERTY_BORDER : String = "border";

		/* properties */

		/**
		 * The textfield content.
		 */
		protected var _text : String = "";
		
		/* children */
		
		/**
		 * The background.
		 */
		protected var _background : Shape;

		/**
		 * The text field borders.
		 */
		protected var _border : Shape;

		/**
		 * The internal TextField instance.
		 */
		protected var _tf : TextField;

		/**
		 * TextFieldBase constructor.
		 */
		public function TextFieldBase() {
			
			// default size
			setDefaultSize(100, 20);
			
			setDefaultStyles([
				style.selectable, false,
				style.color, 0x333333,

				style.embedFont, false,
				style.antiAliasType, null,
				
				style.font, "_sans",
				style.size, 10,
				style.bold, false,
				style.underline, false,
				style.letterSpacing, 0,

				style.background, false,
				style.backgroundColor, 0xFFFFFF,
				style.border, false,
				style.borderLightColor, 0xCCCCCC,
				style.borderDarkColor, 0x333333
			]);

		}

		/*
		 * ITextField
		 */

		/**
		 * @inheritDoc
		 */
		public function set text(text : String) : void {
			if (text == _text) return;
			
			_text = text;
			
			invalidateProperty(UPDATE_PROPERTY_TEXT);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get text() : String {
			return _text;
		}

		/*
		 * View life cycle
		 */		
		
		/**
		 * @inheritDoc
		 */
		protected override function draw() : void {
			
			/*
			 * text field
			 */

			_tf = new TextField();
			_tf.name = "innerTextField";
			var textFormat : TextFormat = new TextFormat();

			_tf.width = _width;
			_tf.height = _height;
			
			_tf.selectable = getStyle(style.selectable);

			_tf.embedFonts = getStyle(style.embedFont);
			if (getStyle(style.antiAliasType)) {
				_tf.antiAliasType = getStyle(style.antiAliasType);
			}
			_tf.textColor = getStyle(style.color);
			
			textFormat.font = getStyle(style.font);
			textFormat.size = getStyle(style.size);
			textFormat.bold = getStyle(style.bold);
			textFormat.underline = getStyle(style.underline);
			textFormat.letterSpacing = getStyle(style.letterSpacing);
			
			_tf.defaultTextFormat = textFormat;
			_tf.setTextFormat(textFormat);

			setTextFieldProperties();
			
			_tf.text = _text;
			
			addChild(_tf);

			layoutTextField();

			/*
			 * background
			 */

			_background = new Shape();
			_background.name = "background";
			drawBackground();
			addChildAt(_background, 0);
			_background.visible = getStyle(style.background);

			/*
			 * border
			 */

			_border = new Shape();
			_border.name = "border";
			drawBorder();
			addChildAt(_border, 1);
			_border.visible = getStyle(style.border);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			/*
			 * TextField size changed
			 * - fit text
			 * - update background size
			 * - update border size
			 */
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				_tf.width = _width;
				_tf.height = _height;

				updateProperty(COMMIT_PROPERTY_BORDER);
				updateProperty(COMMIT_PROPERTY_BACKGROUND);
				updateProperty(COMMIT_PROPERTY_TEXT_FIELD_SIZE);
			}
			
			/*
			 * TextFormat changed
			 * - fit text (e.g. necessary after a font size change
			 * - update background size
			 * - update border size
			 */
			if (isInvalid(UPDATE_PROPERTY_TEXT_FORMAT)) {
				
				var textFormat : TextFormat = new TextFormat();

				textFormat.font = getStyle(style.font);
				textFormat.size = getStyle(style.size);
				textFormat.bold = getStyle(style.bold);
				textFormat.underline = getStyle(style.underline);
				textFormat.letterSpacing = getStyle(style.letterSpacing);
				
				_tf.setTextFormat(textFormat); // apply to existing text
				_tf.defaultTextFormat = textFormat; // use for new text

				updateProperty(COMMIT_PROPERTY_TEXT_SIZE);
			}
			
			/*
			 * Text changed
			 * - fit text
			 * - update background size
			 * - update border size
			 */
			if (isInvalid(UPDATE_PROPERTY_TEXT)) {
				_tf.text = _text;

				updateProperty(COMMIT_PROPERTY_TEXT_SIZE);
			}
			
			/*
			 * Selectable changed
			 */
			if (isInvalid(UPDATE_PROPERTY_SELECTABLE)) {
				_tf.selectable = getStyle(style.selectable);
			}

			/*
			 * Color changed
			 */
			if (isInvalid(UPDATE_PROPERTY_COLOR)) {
				_tf.textColor = getStyle(style.color);
			}

			/*
			 * Background visisiblity changed
			 */
			if (isInvalid(UPDATE_PROPERTY_BACKGROUND)) {
				_background.visible = getStyle(style.background);

				updateProperty(COMMIT_PROPERTY_BACKGROUND);
			}

			/*
			 * Background color changed
			 */
			if (isInvalid(UPDATE_PROPERTY_BACKGROUND_COLOR)) {
				updateProperty(COMMIT_PROPERTY_BACKGROUND);
			}

			/*
			 * Border visisiblity changed
			 */
			if (isInvalid(UPDATE_PROPERTY_BORDER)) {
				_border.visible = getStyle(style.border);

				updateProperty(COMMIT_PROPERTY_BORDER);
			}

			/*
			 * Border color changed
			 */
			if (isInvalid(UPDATE_PROPERTY_BORDER_COLOR)) {
				updateProperty(COMMIT_PROPERTY_BORDER);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function commitUpdate() : void {
			if (shouldUpdate(COMMIT_PROPERTY_TEXT_FIELD_SIZE)
			|| shouldUpdate(COMMIT_PROPERTY_TEXT_SIZE)) {
				// layout text before updating border and background
				layoutTextField();
			}

			if (shouldUpdate(COMMIT_PROPERTY_BACKGROUND)) {
				if (_background.visible) drawBackground();
			}

			if (shouldUpdate(COMMIT_PROPERTY_BORDER)) {
				if (_border.visible) drawBorder();
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property == style.background) {
				invalidateProperty(UPDATE_PROPERTY_BACKGROUND);

			} else if (property == style.backgroundColor) {
				invalidateProperty(UPDATE_PROPERTY_BACKGROUND_COLOR);
	
			} else if (property == style.border) {
				invalidateProperty(UPDATE_PROPERTY_BORDER);
	
			} else if (property == style.borderLightColor || property == style.borderDarkColor) {
				invalidateProperty(UPDATE_PROPERTY_BORDER_COLOR);

			} else if (property == style.color) {
				invalidateProperty(UPDATE_PROPERTY_COLOR);

			} else if (property == style.selectable) {
				invalidateProperty(UPDATE_PROPERTY_SELECTABLE);

			} else {
				invalidateProperty(UPDATE_PROPERTY_TEXT_FORMAT);
			}
		}
		
		/*
		 * Protected
		 */

		/**
		 * Template method to set custom text field properties.
		 */
		protected function setTextFieldProperties() : void {
			
		}

		/**
		 * Template method to layout and size the internal text field.
		 */
		protected function layoutTextField() : void {
		}

		/**
		 * Draws the text field borders.
		 */
		protected function drawBorder() : void {
			with (_border.graphics) {
				clear();

				lineStyle(0, getStyle(style.borderDarkColor));
				moveTo(0, _height);
				lineTo(0, 0);
				lineTo(_width - 1, 0);

				lineStyle(0, getStyle(style.borderLightColor));
				moveTo(1, _height - 1);
				lineTo(_width - 1, _height - 1);
				lineTo(_width - 1, 0);
			}
		}

		/**
		 * Draws the text field background.
		 */
		protected function drawBackground() : void {
			with (_background.graphics) {
				clear();
				beginFill(getStyle(style.backgroundColor));
				drawRect(0, 0, _width, _height);
			}
		}

	}
}
