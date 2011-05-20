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
package com.sibirjak.asdpcbeta.window.core {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.core.skins.GlassFrame;
	import com.sibirjak.asdpc.textfield.ILabel;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.skins.TitleBarSkin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	/**
	 * @author jes 25.11.2009
	 */
	public class TitleBar extends View implements ITitleBar {
		
		protected var _window : Window;

		protected var _skin : DisplayObject;
		protected var _icon : DisplayObject;
		protected var _label : ILabel;
		protected var _clickArea : GlassFrame;
		protected var _minimiseButton : IButton;
		private var _lastMouseDownTime : int;
		
		public function TitleBar() {
		}
		
		public function set window(window : Window) : void {
			_window = window;
		}
		
		override protected function draw() : void {
			_skin = new TitleBarSkin();
			DisplayObjectAdapter.setSize(_skin, _width, _height);
			DisplayObjectAdapter.addChild(_skin, this);
			
			var iconSkin : Class = _window.getStyle(Window.style.windowIconSkin);
			if (iconSkin) {
				_icon = new iconSkin();
				DisplayObjectAdapter.addChild(_icon, this);
				_icon.visible = _window.getStyle(Window.style.windowIcon);
			}
			
			createLabel();
			layoutIconAndLabel();

			// click area over the label
			_clickArea = new GlassFrame();
			_clickArea.setSize(_width, _height);
			_clickArea.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addChild(_clickArea);
			
			createButtons();
			layoutButtons();
		}
		
		override protected function update() : void {
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				DisplayObjectAdapter.setSize(_skin, _width, _height);
				_clickArea.setSize(_width, _height);
				layoutButtons();
			}

			DisplayObjectAdapter.validateNow(_skin);
		}

		override protected function cleanUpCalled() : void {
			_clickArea.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			// custom title bars may not have a minimise button
			if (_minimiseButton) _minimiseButton.removeEventListener(MouseEvent.MOUSE_DOWN, minimiseButtonClickHandler);
		}
		
		/*
		 * Protected
		 */

		protected function createLabel() : void {
			var labelText : String = _window.title.toUpperCase();
			if (!labelText) return;
			
			_label = new Label();
			_label.setSize(Math.max(10, _width - 40), _height);
			
			_label.text = _window.title.toUpperCase();
			_label.setStyles([
				Label.style.bold, true,
				Label.style.color, 0xFFFFFF,
				Label.style.verticalAlign, Position.MIDDLE
			]);
			addChild(DisplayObject(_label));
		}

		protected function layoutIconAndLabel() : void {
			var labelX : uint = 5;
			
			if (_icon && _window.getStyle(Window.style.windowIcon)) {
				DisplayObjectAdapter.moveTo(_icon, 4, Math.round((_height - _icon.height) / 2));
				labelX += _icon.width;
			}
			
			if (_label) _label.moveTo(labelX, Math.round((_height - _label.height) / 2));
		}

		protected function createButtons() : void {
			_minimiseButton = new Button();
			_minimiseButton.setSize(15, 15);
			_minimiseButton.setStyles([
				ButtonSkin.style_overBackgroundColors, [0xCCCCCC, 0xAAAAAA],
				ButtonSkin.style_borderColors, [0xCCCCCC, 0x666666],

				ButtonSkin.style_backgroundAlpha, .3,
				
				ButtonSkin.style_cornerRadius, 0,

				Button.style.upSkin, null,
				Button.style.upIconSkin, _window.getStyle(Window.style.minimiseIconSkin),
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME
			]);
			
			_minimiseButton.visible = _window.getStyle(Window.style.minimiseButton);
			
			_minimiseButton.addEventListener(ButtonEvent.CLICK, minimiseButtonClickHandler);
			addChild(DisplayObject(_minimiseButton));
		}
			
		protected function layoutButtons() : void {
			_minimiseButton.moveTo(
				_width - _minimiseButton.width - 3,
				Math.round((_height - _minimiseButton.height) / 2)
			);
		}

		/*
		 * Events
		 */

		private function mouseDownHandler(event : MouseEvent) : void {
			if (_lastMouseDownTime && getTimer() - _lastMouseDownTime < 300) {
				if (_window.getStyle(Window.style.minimiseOnDoubleClick)) {
					_window.minimise();
					_lastMouseDownTime = 0;
				}
			} else {
				_window.startMoving();
				_lastMouseDownTime = getTimer();
			}
		}

		private function minimiseButtonClickHandler(event : ButtonEvent) : void {
			_window.minimise();
		}

	}
}
