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
package com.sibirjak.asdpcbeta.colorpicker.core {

	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.textfield.ITextInput;
	import com.sibirjak.asdpc.textfield.TextInput;
	import com.sibirjak.asdpc.textfield.TextInputEvent;

	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.LinkedSet;

	import flash.display.DisplayObject;
	import flash.display.Shape;

	/**
	 * @author jes 08.01.2010
	 */
	public class ColorPickerWindowContent extends View {

		/* properties */
		protected var _colorPickerWindow : ColorPickerWindow;
		private var _colorToSelect : uint;

		/* internal */
		private var _history : LinkedSet;
		
		/* children */
		protected var _paletteButton : IButton;
		private var _customChart : SwatchChart;
		private var _selectedPreview : ColorPreview;
		protected var _preview : ColorPreview;
		private var _colorInput : ITextInput;
		protected var _colorChart : SwatchChart;
		
		protected var _colorChartSwatchWidth : uint = 10;
		protected var _colorChartSwatchHeight : uint = 10;
		protected var _colorChartItemsPerRow : uint = 25;
		
		/* asssets */
		[Embed(source="../assets/color_swatch.png")]
		private var _webColor : Class;
		
		public function ColorPickerWindowContent(colorPickerWindow : ColorPickerWindow) {
			_colorPickerWindow = colorPickerWindow;

			_history = new LinkedSet();
		}

		public function previewColor(color : uint) : void {
			_preview.color = color;
			_colorInput.text = ColorUtil.hexToString(_preview.color, false).toUpperCase();
		}

		public function selectColor(color : uint) : void {
			if (!_initialised) {
				_colorToSelect = color;
				return;
			}
			
			onWillSetColor(color);

			addToHistory(color);
			_selectedPreview.color = color;
			_preview.color = color;
			_colorInput.text = ColorUtil.hexToString(color, false).toUpperCase();
			
			_colorChart.selectColor(color);
		}

		public function notifyColorRollOver(color : uint) : void {
			previewColor(color);
			onColorRollOver(_preview.color);
		}

		public function notifyColorClick() : void {
			selectColor(_preview.color);
			onColorSelected(_preview.color);
		}

		public function notifyColorReset() : void {
			selectColor(_selectedPreview.color);
			onColorRollOver(_selectedPreview.color);
		}

		/*
		 * View life cycle
		 */

		override protected function draw() : void {
			
			// selected color

			_selectedPreview = new ColorPreview();
			_selectedPreview.setSize(51, 21);
			_selectedPreview.color = _colorToSelect;
			_selectedPreview.moveTo(0, 0);
			addChild(_selectedPreview);

			// preview
			
			_preview = new ColorPreview();
			_preview.setSize(51, 21);
			_preview.color = _colorToSelect;
			_preview.moveTo(50, 0);
			addChild(_preview);
			
			_colorInput = new TextInput();
			_colorInput.setSize(51, 21);
			_colorInput.setStyles([
				TextInput.style.background, true,
				TextInput.style.backgroundColor, 0xFFFFFF,
				TextInput.style.restrict, "0-9A-Fa-f",
				TextInput.style.maxChars, 6
			]);
			_colorInput.text = ColorUtil.hexToString(_colorToSelect, false).toUpperCase();
			_colorInput.moveTo(100, 0);
			
			_colorInput.addEventListener(TextInputEvent.CHANGED, colorInputChangeHandler);
			_colorInput.addEventListener(TextInputEvent.SUBMIT, colorInputSubmitHandler);
			addChild(DisplayObject(_colorInput));
			
			// preview borders
			
			var borders : Shape = new Shape();
			with (borders.graphics) {
				lineStyle(0, 0);
				moveTo(0, 20);
				lineTo(0, 0);
				lineTo(100, 0);

				moveTo(100, 20);
				lineTo(100, 0);
				lineTo(150, 0);
				
				lineStyle(0, 0x999999);
				moveTo(0, 20);
				lineTo(100, 20);
				lineTo(100, 1);

				moveTo(100, 20);
				lineTo(150, 20);
				lineTo(150, 0);
			}
			
			
			addChild(borders);
			
			// custom chart
			
			_customChart = new SwatchChart();
			_customChart.colorPickerWindowContent = this;
			_customChart.setStyle(SwatchChart.style_numItemsPerRow, 7);
			_customChart.numItems = 14;
			_customChart.selectColor(_colorToSelect);
			_customChart.moveTo(155, 0);
			addChild(_customChart);

			// palette button
			
			_paletteButton = new Button();
			_paletteButton.setSize(21, 21);
			_paletteButton.setStyles([
				Button.style.upIconSkin, _webColor,
				Button.style.overIconSkin, _webColor,
				Button.style.downIconSkin, _webColor,
				Button.style.selectedUpIconSkin, _webColor,
				Button.style.selectedOverIconSkin, _webColor,
				Button.style.selectedDownIconSkin, _webColor,

				ButtonSkin.style_backgroundColors, [0xFFFFFF, 0xCCCCCC],
				ButtonSkin.style_borderColors, [0x666666, 0x000000],
				ButtonSkin.style_borderAlias, false,
				ButtonSkin.style_cornerRadius, 0
			]);
			_paletteButton.toggle = true;
			_paletteButton.addEventListener(ButtonEvent.SELECTION_CHANGED, paletteButtonChangedHandler);
			_paletteButton.moveTo(230, 0);
			addChild(DisplayObject(_paletteButton));

			// palette

			_colorChart = new SwatchChart();
			_colorChart.colorPickerWindowContent = this;
			_colorChart.setStyle(SwatchChart.style_numItemsPerRow, _colorChartItemsPerRow);
			_colorChart.setStyle(SwatchChart.style_itemWidth, _colorChartSwatchWidth);
			_colorChart.setStyle(SwatchChart.style_itemHeight, _colorChartSwatchHeight);
			_colorChart.dataSource = getPalette();
			_colorChart.selectColor(_colorToSelect);
			_colorChart.moveTo(0, 26);
			addChild(_colorChart);
			
			// additional elements

			drawAdditionalElements();
			
			// select
			
			addToHistory(_colorToSelect);
			_selectedPreview.color = _colorToSelect;
		}

		override protected function cleanUpCalled() : void {
			_colorInput.removeEventListener(TextInputEvent.CHANGED, colorInputChangeHandler);
			_colorInput.removeEventListener(TextInputEvent.SUBMIT, colorInputSubmitHandler);

			_paletteButton.removeEventListener(ButtonEvent.SELECTION_CHANGED, paletteButtonChangedHandler);
		}

		protected function getPalette() : ArrayList {
			return Palette.palette();
		}
		
		protected function drawAdditionalElements() : void {
		}
		
		protected function onWillSetColor(color : uint) : void {
		}
		
		/*
		 * Private
		 */
		
		private function onColorSelected(color : uint) : void {
			_colorPickerWindow.colorPicker.notifyColorSelected(color);
		}

		private function onColorRollOver(color : uint) : void {
			_colorPickerWindow.colorPicker.notifyColorRollOver(color);
		}

		private function addToHistory(color : uint) : void {
			_history.remove(color);
			_history.add(color);
			
			if (_history.size == 15) {
				_history.removeFirst();
			}
			
			_customChart.dataSource = _history;
			_customChart.selectColor(color);
		}

		/*
		 * Events
		 */
		
		private function colorInputChangeHandler(event : TextInputEvent) : void {
			var text : String = TextInput(event.currentTarget).text;
			if (!text) text = "0";
			_preview.color = Number("0x" + text);
			onColorRollOver(_preview.color);
		}

		private function colorInputSubmitHandler(event : TextInputEvent) : void {
			var text : String = TextInput(event.currentTarget).text;
			if (!text) text = "0";
			var color : uint = Number("0x" + text);
			selectColor(color);
			onColorSelected(color);
		}

		private function paletteButtonChangedHandler(event : ButtonEvent) : void {
			if (_paletteButton.selected) {
				_colorChart.dataSource = Palette.webPalette();
			} else {
				_colorChart.dataSource = getPalette();
			}
		}
		
	}
}
