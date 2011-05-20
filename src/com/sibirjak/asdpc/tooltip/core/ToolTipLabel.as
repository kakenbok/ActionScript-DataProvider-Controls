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
package com.sibirjak.asdpc.tooltip.core {
	import com.sibirjak.asdpc.textfield.Label;

	import flash.text.TextFieldAutoSize;

	/**
	 * Self resizing label for the ToolTip component.
	 * 
	 * @author jes 10.12.2009
	 */
	public class ToolTipLabel extends Label {
		
		/**
		 * ToolTipLabel constructor.
		 */
		public function ToolTipLabel() {
			
			setDefaultStyles([
				Label.style.size, 9
			]);
			
		}
		
		/*
		 * TextFieldBase protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function setTextFieldProperties() : void {
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.multiline = false;
			_tf.wordWrap = false;
		}

		/**
		 * @inheritDoc
		 */
		override protected function layoutTextField() : void {
			setTextFieldProperties();
			
			if (_tf.width > _width) {
				_tf.multiline = true;
				_tf.wordWrap = true;
				_tf.width = _width;
				_tf.width = _tf.textWidth + 4;
			}
		}
		
	}
}
