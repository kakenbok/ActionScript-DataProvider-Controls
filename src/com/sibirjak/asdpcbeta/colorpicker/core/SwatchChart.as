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
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.dataprovider.DataSourceAdapterFactory;
	import com.sibirjak.asdpcbeta.layout.GridLayout;

	import org.as3commons.collections.framework.IDataProvider;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author jes 07.12.2009
	 */
	public class SwatchChart extends View {
		
		public static var style_itemWidth : String = "swatchChart_itemWidth";
		public static var style_itemHeight : String = "swatchChart_itemHeight";
		public static var style_numItemsPerRow : String = "swatchChart_numItemsPerRow";

		private var _numItems : uint;
		private var _dataSource : *;
		private var _dataProvider : IDataProvider;
		
		private var _colorPickerWindowContent : ColorPickerWindowContent;
		private var _grid : GridLayout;
		private var _iconBorder : ColorSwatchBorder;
		private var _selectedIconBorder : ColorSwatchBorder;
		
		private var _colorToSelect : uint;
		private var _colorSwatchMap : Dictionary;
		
		public function SwatchChart() {
			
			setDefaultStyles([
				style_itemWidth, 10,
				style_itemHeight, 10,
				style_numItemsPerRow, 0
			]);
			
			_colorSwatchMap = new Dictionary();
			
			addEventListener(MouseEvent.MOUSE_OVER, colorRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function set colorPickerWindowContent(colorPickerWindowContent : ColorPickerWindowContent) : void {
			_colorPickerWindowContent = colorPickerWindowContent;
		}

		public function set numItems(numItems : uint) : void {
			_numItems = numItems;
		}

		public function get dataSource() : * {
			return _dataSource;
		}
		
		public function set dataSource(dataSource : *) : void {
			_dataSource = dataSource;
			
			if (_initialised) {
				_dataProvider = DataSourceAdapterFactory.getAdapter(_dataSource);

				removeSwatches();
				addSwatches();
				
				_grid.validateNow(); // validate now for a valid reposition of the selected icon border
			}
		}
		
		public function selectColor(color : uint) : void {
			if (!_initialised) {
				_colorToSelect = color;
				return;
			}
			
			var colorSwatch : ColorSwatch = _colorSwatchMap[color];
			
			if (colorSwatch) {
				_selectedIconBorder.x = colorSwatch.x;
				_selectedIconBorder.y = colorSwatch.y;
				_selectedIconBorder.visible = true;
			} else {
				_selectedIconBorder.visible = false;
			}
			
		}
		
		/*
		 * View life cycle
		 */

		override protected function init() : void {
			if (!_dataSource) _dataSource = [];
			_dataProvider = DataSourceAdapterFactory.getAdapter(_dataSource);
		}

		override protected function draw() : void {
			
			_grid = new GridLayout();
			_grid.setStyles([
				GridLayout.style.itemWidth, getStyle(style_itemWidth),
				GridLayout.style.itemHeight, getStyle(style_itemHeight),
				GridLayout.style.numItemsPerRow, getStyle(style_numItemsPerRow)
			]);
			addSwatches();
			addChild(_grid);

			// selected swatch border
			
			_selectedIconBorder = new ColorSwatchBorder(getStyle(style_itemWidth), getStyle(style_itemHeight), 0xFFFF00);
			addChild(_selectedIconBorder);
			_selectedIconBorder.visible = false;
			
			// swatch border
			
			_iconBorder = new ColorSwatchBorder(getStyle(style_itemWidth), getStyle(style_itemHeight));
			addChild(_iconBorder);
			_iconBorder.visible = false;
			
		}

		override protected function initialised() : void {
			// finally select color
			selectColor(_colorToSelect);
		}

		override protected function cleanUpCalled() : void {
			removeEventListener(MouseEvent.MOUSE_OVER, colorRollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
		}

		/*
		 * Events
		 */

		private function clickHandler(event : MouseEvent) : void {
			if (_iconBorder.visible) _colorPickerWindowContent.notifyColorClick();
		}

		private function colorRollOverHandler(event : MouseEvent) : void {
			event.updateAfterEvent();

			if (event.target is ColorSwatch) {
				var colorSwatch : ColorSwatch = event.target as ColorSwatch;
				if (colorSwatch.color >= 0) {
					_iconBorder.x = colorSwatch.x;
					_iconBorder.y = colorSwatch.y;
					_iconBorder.color = colorSwatch.color;
					_iconBorder.visible = true;
					
					_colorPickerWindowContent.notifyColorRollOver(colorSwatch.color);
					return;
				}
			}
			_iconBorder.visible = false;
			
		}

		private function rollOutHandler(event : MouseEvent) : void {
			_iconBorder.visible = false;
			
			_colorPickerWindowContent.notifyColorReset();
		}

		/*
		 * Private
		 */

		private function addSwatches() : void {
			var itemWidth : uint = getStyle(style_itemWidth);
			var itemHeight : uint = getStyle(style_itemHeight);
			
			var colorSwatch : ColorSwatch;
		
			for (var i : int = 0; i < _dataProvider.size; i++) {
				var color : uint = _dataProvider.itemAt(i);
				colorSwatch = new ColorSwatch(color, itemWidth, itemHeight, i);
				_grid.addChild(colorSwatch);
				_colorSwatchMap[color] = colorSwatch;
			}
			
			if (_numItems) {
				for (i = i; i < _numItems; i++) {
					colorSwatch = new ColorSwatch(-1, itemWidth, itemHeight, i);
					_grid.addChild(colorSwatch);
				}
			}
		}

		private function removeSwatches() : void {
			while (_grid.numChildren) {
				_grid.removeChildAt(0);
			}
			_colorSwatchMap = new Dictionary();
		}
		
	}
}
