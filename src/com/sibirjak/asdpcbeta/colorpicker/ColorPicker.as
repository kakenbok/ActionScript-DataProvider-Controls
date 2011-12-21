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
package com.sibirjak.asdpcbeta.colorpicker {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpcbeta.colorpicker.core.ColorPickerWindow;
	import com.sibirjak.asdpcbeta.colorpicker.core.ColorUtil;
	import com.sibirjak.asdpcbeta.colorpicker.skins.ColorPickerIconSkin;
	import com.sibirjak.asdpcbeta.core.managers.PopUpManager;
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author jes 08.12.2009
	 */
	public class ColorPicker extends Button {
		
		public static const BINDABLE_PROPERTY_SELECTED_COLOR : String = "selectedColor";

		private var _liveChoosing : Boolean = true;
		private var _selectedColor : uint;
		private var _popUp : ColorPickerWindow;

		[Embed(source="assets/button_open_icon.png")]
		private var openIconSkin : Class;

		public function ColorPicker() {
			
			// default size
			setDefaultSize(18, 18);
			
			setBindableProperties([BINDABLE_PROPERTY_SELECTED_COLOR]);
			
			setStyles([
				Button.style.upIconSkin, ColorPickerIconSkin,
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.selectedUpIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.selectedOverIconSkinName, Button.UP_ICON_SKIN_NAME,
				Button.style.selectedDownIconSkinName, Button.UP_ICON_SKIN_NAME
			]);
			
			toggle = true;
		}
		
		public function get selectedColor() : uint {
			return _selectedColor;
		}
		
		public function set selectedColor(selectedColor : uint) : void {
			if (selectedColor == _selectedColor) return;
			_selectedColor = selectedColor;
			colorize();
			updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_COLOR);
		}
		
		public function set liveChoosing(liveChoosing : Boolean) : void {
			_liveChoosing = liveChoosing;
		}

		public function get liveChoosing() : Boolean {
			return _liveChoosing;
		}
		
		public function notifyColorSelected(color : uint) : void {
			_selectedColor = color;
			colorize();
			
			_popUp.minimise();

			updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_COLOR);

			var event : ColorPickerEvent = new ColorPickerEvent(ColorPickerEvent.COLOR_SELECTED);
			event.selectedColor = _selectedColor;
			dispatchEvent(event);
		}

		public function notifyColorRollOver(color : uint) : void {
			if (_liveChoosing) {
				_selectedColor = color;
				colorize();
				
				updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_COLOR);

				var event : ColorPickerEvent = new ColorPickerEvent(ColorPickerEvent.COLOR_ROLL_OVER);
				event.selectedColor = _selectedColor;
				dispatchEvent(event);
			}
		}
		
		public function notifyPopUpOwnerChanged(colorPicker : ColorPicker) : void {
			deselect();
		}
		
		/*
		 * View life cycle
		 */

		override protected function init() : void {
			super.init();
			
			setStyle(ColorPickerIconSkin.style_size, _width - 4);
		}

		override protected function draw() : void {
			super.draw();
			
			var openIcon : DisplayObject = new openIconSkin();
			DisplayObjectAdapter.moveTo(
				openIcon,
				Math.round((_width - openIcon.width) / 2),
				_height - openIcon.height - 1
			);
			DisplayObjectAdapter.addChild(openIcon, this);
			
			colorize();
		}
		
		override protected function initialised() : void {
			updateAllBindings();
		}

		/*
		 * Protected
		 */

		override protected function getToolTip() : String {
			var toolTip : String = super.getToolTip();
			
			if (toolTip) return toolTip + "\n\n" + ColorUtil.hexToString(_selectedColor);
			else return ColorUtil.hexToString(_selectedColor);
		}

		override protected function onSelectionChanged() : void {

			var popUp : ColorPickerWindow = getColorPickerWindow();
			
			if (selected) {
				
				// popup reopened during a minimise tween
				if (!_popUp) _popUp = popUp;
				
				/*
				 * Position
				 */

				var point : Point = localToGlobal(new Point(0, 0));
				
				var posX : int;
				var posY : int;
				
				if (point.x > stage.stageWidth / 2) {
					posX = point.x + _width - popUp.width;
				} else {
					posX = point.x;
				}
	
				posX = Math.min(posX, stage.stageWidth - _width - 4);
				
				if (point.y > stage.stageHeight / 2) {
					posY = point.y - popUp.height - 4;
				} else {
					posY = point.y + _height + 4;
				}
				
				// do not overlap the movies bottom
				if (posY > stage.stageHeight - popUp.height - 4) posY = stage.stageHeight - popUp.height - 4;
				// do not overlap the movies top
				if (posY < 0) posY = 4;

				popUp.restorePosition = new WindowPosition(posX, posY);
				popUp.minimisePosition = new WindowPosition(point.x + Math.round(_width / 2), point.y + Math.round(_height / 2));

				/*
				 * Show popup
				 */

				popUp.colorPicker = this;
				popUp.addEventListener(WindowEvent.MINIMISED, minimisedHandler);
				PopUpManager.getInstance().createPopUp(popUp);
				popUp.restore();
				
			} else {
				popUp.minimise();
			}
		}
		
		protected function getColorPickerWindow() : ColorPickerWindow {
			return ColorPickerWindow.getInstance();
		}
		
		/*
		 * Events
		 */
		
		private function minimisedHandler(event : WindowEvent) : void {
			deselect();
		}

		/*
		 * Private
		 */
		
		private function deselect() : void {
			_popUp.removeEventListener(WindowEvent.MINIMISED, minimisedHandler);
			PopUpManager.getInstance().removePopUp(_popUp);
			_popUp = null;

			selected = false;
		}

		private function colorize() : void {
			setStyle(ColorPickerIconSkin.style_color, _selectedColor);
		}

	}
}
