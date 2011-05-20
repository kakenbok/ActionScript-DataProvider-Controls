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
package com.sibirjak.asdpc.listview.interfacedemo.windows.data {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author jes 17.12.2009
	 */
	public class InputWindowContent extends ControlPanelBase {
		
		private var _tf : TextField;
		
		private var _oldText : String;

		override protected function draw() : void {
			
			// background
			
			var h : uint = _height - 29;

			with (graphics) {

				beginFill(0xFFFFFF);
				drawRect(0, 0, _width, h);
				endFill();

				lineStyle(0, 0x999999);
				moveTo(0, h);
				lineTo(0, 0);
				lineTo(_width - 1, 0);

				lineStyle(0, 0xCCCCCC);
				moveTo(1, h - 1);
				lineTo(_width - 1, h - 1);
				lineTo(_width - 1, 0);
			}

			// text area

			_tf = new TextField;
			
			_tf.width = _width;
			_tf.height = _height - 25;
			
			_tf.type = TextFieldType.INPUT;

			_tf.multiline = true;
			_tf.wordWrap = true;
			
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "_typewriter";
			
			_tf.defaultTextFormat = textFormat;

			addChild(_tf);
			
			// button

			var button : Button = new Button();
			button.setSize(50, 20);
			button.label = "Submit";
			button.moveTo(Math.round(_width / 2 - 20), _height - 21);
			button.addEventListener(ButtonEvent.CLICK, submitHandler);
			addChild(button);
		}
		
		public function set error(text : String) : void {
			_tf.text = text;
			_tf.addEventListener(MouseEvent.MOUSE_DOWN, tfMouseDownHandler);
		}
		
		private function tfMouseDownHandler(event : MouseEvent) : void {
			_tf.removeEventListener(MouseEvent.MOUSE_DOWN, tfMouseDownHandler);
			_tf.text = _oldText;
		}

		public function get content() : String {
			_oldText = _tf.text;
			_tf.text = "";
			return _oldText;
		}

		public function removeContent() : void {
			_tf.removeEventListener(MouseEvent.MOUSE_DOWN, tfMouseDownHandler);
			_tf.text = "";
			_oldText = "";
		}

		private function submitHandler(event : ButtonEvent) : void {
			dispatchEvent(new Event("submit", true));
		}
		
		public function get tf() : TextField {
			return _tf;
		}
	}
}
