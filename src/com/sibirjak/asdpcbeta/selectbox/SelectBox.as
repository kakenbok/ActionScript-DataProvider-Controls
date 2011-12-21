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
package com.sibirjak.asdpcbeta.selectbox {

	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpc.core.BindableView;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.core.dataprovider.DataProviderEvent;
	import com.sibirjak.asdpc.core.dataprovider.DataSourceAdapterFactory;
	import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;
	import com.sibirjak.asdpc.core.dataprovider.genericToStringFunction;
	import com.sibirjak.asdpc.core.managers.IPopUpControl;
	import com.sibirjak.asdpc.core.managers.IPopUpControlPopUp;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.ListItemEvent;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.scrollbar.skins.ScrollButtonIconSkin;
	import com.sibirjak.asdpc.textfield.ILabel;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.tooltip.ToolTip;
	import com.sibirjak.asdpcbeta.core.managers.PopUpManager;
	import com.sibirjak.asdpcbeta.selectbox.core.SelectBoxWindow;
	import com.sibirjak.asdpcbeta.window.Window;
	import com.sibirjak.asdpcbeta.window.WindowEvent;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;

	import org.as3commons.collections.framework.IDataProvider;

	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author jes 08.01.2010
	 */
	public class SelectBox extends BindableView implements IPopUpControl {

		/* style declarations */
		public static var style : SelectBoxStyles = new SelectBoxStyles();

		/* constants */
		public static const UPDATE_PROPERTY_DATA_SOURCE : String = "data_source";
		public static const UPDATE_PROPERTY_ENABLED : String = "enabled";
		public static const BINDABLE_PROPERTY_SELECTED_ITEM : String = "selectedItem";

		/* properties */
		private var _dataSource : *;
		private var _dataSourceAdapter : IDataProvider;
		
		private var _indexToSelect : int = -1;
		private var _indexToScroll : int = -1;
		private var _liveSelecting : Boolean = false;
		private var _enabled : Boolean = true;

		/* children */
		protected var _skin : DisplayObject;
		protected var _label : ILabel;
		protected var _button : IButton;
		protected var _popUp : SelectBoxWindow;
		protected var _openIcon : DisplayObject;

		/* styles */
		private var _labelFunction : Function;
		private var _listItemSize : uint;
		private var _listPadding : uint;
		private var _buttonSize : uint;

		/* assets */
		[Embed(source="assets/button_open_icon.png")]
		private var openIconSkin : Class;


		public function SelectBox() {
			
			// default size
			setDefaultSize(100, 20);

			setBindableProperties([BINDABLE_PROPERTY_SELECTED_ITEM]);
			
			setDefaultStyles([
				style.maxVisibleItems, 8,
				style.buttonSize, 13,
				style.popUpSize, 0,

				style.listItemRenderer, null,
				style.listPadding, 1,
				style.listItemSize, 18,
				
				style.button, true,
				style.buttonClass, Button,
				style.openIcon, true,

				style.borderLightColor, 0xCCCCCC,
				style.borderDarkColor, 0x666666,
				style.disabledBorderLightColor, 0xCCCCCC,
				style.disabledBorderDarkColor, 0xCCCCCC,
				
				style.labelBackground, true,
				style.labelBorder, true,
				style.labelFunction, null,

				style.toolTips, true
			]);
		}
		
		/*
		 * IPopUpControl
		 */
		
		public function get popUp() : IPopUpControlPopUp {
			return _popUp;
		}

		/*
		 * ISelectBox
		 */

		public function set dataSource(dataSource : *) : void {
			_dataSource = dataSource;
			
			if (_initialised) {
				initDataSource();
			}

			invalidateProperty(UPDATE_PROPERTY_DATA_SOURCE);
		}
		
		public function get dataSource() : * {
			return _dataSource;
		}
		
		public function selectItemAt(selectedIndex : uint) : void {
			if (!_initialised) {
				_indexToSelect = selectedIndex;
			} else {
				_popUp.list.selectItemAt(selectedIndex);
			}
		}

		public function get selectedIndex() : int {
			return _initialised ? _popUp.list.selectedIndex : -1;
		}
		
		public function get selectedItem() : * {
			if (!_initialised) return null;
			
			var listItemData : ListItemData = _popUp.list.selectedItemData;
			if (listItemData) {
				return listItemData.item;
			} else {
				return null;
			}
		}
		
		public function set liveSelecting(liveSelecting : Boolean) : void {
			_liveSelecting = liveSelecting;
		}
		
		public function set enabled(enabled : Boolean) : void {
			_enabled = enabled;
			invalidateProperty(UPDATE_PROPERTY_ENABLED);
		}

		public function get enabled() : Boolean {
			return _enabled;
		}

		public function get numItems() : uint {
			if (!_initialised) return 0;
			return _popUp.list.numItems;
		}

		public function scrollToItemAt(index : uint) : void {
			if (!_initialised) {
				_indexToScroll = index;
			} else {
				_popUp.list.scrollToItemAt(index);
			}
		}
		
		private function initDataSource() : void {
			
			if (_dataSourceAdapter) {
				if (_dataSourceAdapter is IEventDispatcher) {
					IEventDispatcher(_dataSourceAdapter).removeEventListener(
						DataProviderEvent.DATA_PROVIDER_CHANGED, dataProviderChangedHandler
					);
				}
			}
			
			_dataSourceAdapter = DataSourceAdapterFactory.getAdapter(_dataSource);

			if (_dataSourceAdapter is IEventDispatcher) {
				IEventDispatcher(_dataSourceAdapter).addEventListener(
					DataProviderEvent.DATA_PROVIDER_CHANGED, dataProviderChangedHandler
				);
			}
		}
		
		/*
		 * View life cycle
		 */

		override protected function init() : void {
			_labelFunction = getStyle(style.labelFunction);
			_listItemSize = Math.max(_height, getStyle(style.listItemSize));
			_listPadding = getStyle(style.listPadding);
			_buttonSize = getStyle(style.buttonSize);
			
			if (!_dataSource) _dataSource = [];
			
			initDataSource();
		}

		override protected function draw() : void {
			var lightColor : uint = _enabled ? getStyle(style.borderLightColor) : getStyle(style.disabledBorderLightColor);
			var darkColor : uint = _enabled ? getStyle(style.borderDarkColor) : getStyle(style.disabledBorderDarkColor);
			
			/* Trigger button */

			var buttonClass : Class = getStyle(style.buttonClass);
			_button = new buttonClass();
			_button.setSize(_buttonSize, _height);
			_button.enabled = _enabled;
			
			_button.setStyles([
				ButtonSkin.style_borderColors, [lightColor, darkColor]
			]);

			_button.toggle = true;
			_button.moveTo(_width - _buttonSize, 0);
			_button.addEventListener(ButtonEvent.SELECTION_CHANGED, buttonSelectedHandler);
			addChild(DisplayObject(_button));

			_openIcon = new openIconSkin();
			DisplayObjectAdapter.moveTo(
				_openIcon,
				_button.x + Math.round((_buttonSize - _openIcon.width) / 2),
				_height - _openIcon.height - 2
			);
			DisplayObjectAdapter.addChild(_openIcon, this);
			
			_button.visible = getStyle(style.button);
			_openIcon.visible = getStyle(style.button) && getStyle(style.openIcon);
			
			/* Label */
			
			_label = new Label();
			_label.setSize(_width - _buttonSize + 2 - _label.x, _height);
			_label.setStyles([
				Label.style.verticalAlign, Position.MIDDLE,
				Label.style.background, getStyle(style.labelBackground),
				Label.style.border, getStyle(style.labelBorder),
				Label.style.borderLightColor, darkColor, // swap label colors with label for a convex effect
				Label.style.borderDarkColor, lightColor
			]);
			_label.text = "Select me";
			_label.addEventListener(MouseEvent.CLICK, labelClickHandler);
			_label.addEventListener(MouseEvent.ROLL_OVER, labelRollOverHandler);
			_label.addEventListener(MouseEvent.ROLL_OUT, labelRollOutHandler);
			addChild(DisplayObject(_label));
			
			/* PopUp */
			
			_popUp = new SelectBoxWindow();
			if (getStyle(style.listItemRenderer)) _popUp.list.itemRenderer = getStyle(style.listItemRenderer);
			setPopUpSize(_dataSourceAdapter.size);

			_popUp.setStyles([
				Window.style.padding, _listPadding,
				ListView.style.itemSize, _listItemSize,
				ListView.style.scrollBarSize, _buttonSize - 3,
				ButtonSkin.style_borderAlias, false,
				ScrollButtonIconSkin.style_iconSize, 6,
				ListItemRenderer.style.clickSelection, true
			]);
			if (_labelFunction != null) _popUp.setStyle(
				ListItemContent.style.labelFunction, _labelFunction
			);

			if (getStyle(style.toolTips)) _popUp.setStyle(
				ListItemContent.style.toolTips, true
			);

			_popUp.selectBox = this;
			_popUp.minimised = true;
			_popUp.addEventListener(WindowEvent.MINIMISED, minimisedHandler);
			_popUp.moveTo(0, _height + 1);
			addChild(DisplayObject(_popUp));
			
			/* List */
			
			with (_popUp.list) {
				dataSource = _dataSourceAdapter;
				selectItemAt(_indexToSelect);
				scrollToItemAt(_indexToScroll);
				
				// fires immediately since list is already added to stage here
				bindProperty(ListView.BINDABLE_PROPERTY_SELECTED_INDEX, setSelectedIndex);
				
				addEventListener(ListItemEvent.CLICK, itemClickHandler);
				addEventListener(ListItemEvent.ROLL_OVER, itemRollOverHandler);
				addEventListener(ListItemEvent.SELECTION_CHANGED, selectionChangedHandler);
			}
		}

		override protected function update() : void {
			var updatePopUpSize : Boolean = false;
			
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				_label.setSize(_width - _buttonSize + 2, _height);
					
				_button.setSize(_buttonSize, _height);
				_button.moveTo(_width - _buttonSize, 0);
	
				DisplayObjectAdapter.moveTo(
					_openIcon,
					_button.x + Math.round((_buttonSize - _openIcon.width) / 2),
					_height - _openIcon.height - 2
				);
				
				if (_skin) {
					DisplayObjectAdapter.setSize(_skin, _width, _height);
				}

				updatePopUpSize = true;
			}
			
			if (isInvalid(UPDATE_PROPERTY_DATA_SOURCE)) {
				_popUp.list.dataSource = _dataSourceAdapter;

				updatePopUpSize = true;
			}
			
			if (isInvalid(UPDATE_PROPERTY_ENABLED)) {
				_button.enabled = _enabled;

				var lightColor : uint = _enabled ? getStyle(style.borderLightColor) : getStyle(style.disabledBorderLightColor);
				var darkColor : uint = _enabled ? getStyle(style.borderDarkColor) : getStyle(style.disabledBorderDarkColor);
				_label.setStyles([
					Label.style.borderLightColor, darkColor, // swap label colors with label for a convex effect
					Label.style.borderDarkColor, lightColor
				]);
			}

			if (updatePopUpSize) {
				setPopUpSize(_dataSourceAdapter.size);
			}
		}

		override protected function initialised() : void {
			updateAllBindings();
		}

		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();
			
			_label.removeEventListener(MouseEvent.CLICK, labelClickHandler);
			_button.removeEventListener(ButtonEvent.SELECTION_CHANGED, buttonSelectedHandler);

			_popUp.list.removeEventListener(ListItemEvent.CLICK, itemClickHandler);
			_popUp.list.removeEventListener(ListItemEvent.ROLL_OVER, itemRollOverHandler);
			_popUp.list.removeEventListener(ListItemEvent.SELECTION_CHANGED, selectionChangedHandler);

			_popUp.removeEventListener(WindowEvent.MINIMISED, minimisedHandler);

			if (_dataSourceAdapter is IEventDispatcher) {
				IEventDispatcher(_dataSourceAdapter).removeEventListener(
					DataProviderEvent.DATA_PROVIDER_CHANGED, dataProviderChangedHandler
				);
			}
			
			if (_dataSourceAdapter is IDataSourceAdapter) {
				IDataSourceAdapter(_dataSourceAdapter).cleanUp();
			}

		}

		/*
		 * Private
		 */
		
		private function setPopUpSize(numItems : uint) : void {
			var maxVisibleItems : uint = getStyle(style.maxVisibleItems);
			var numVisibleItems : uint = Math.min(maxVisibleItems, numItems);

			var popUpWidth : uint = getStyle(style.popUpSize);
			if (!popUpWidth) popUpWidth = _width;
			_popUp.setSize(popUpWidth, numVisibleItems * _listItemSize + 2 * _listPadding + 2); // 2*1px padding, 2*1px border
		}

		private function setSelectedIndex(selectedIndex : int) : void {
			setSelectedLabel();
			
			if (!_initialised) return;

			updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_ITEM);
		}

		private function getSelectedLabel() : String {
			var listItemData : ListItemData = _popUp.list.selectedItemData;
			
			if (listItemData) {
				return _labelFunction != null
					? _labelFunction(listItemData)
					: genericToStringFunction(listItemData.item);
				
			} else {
				return "";
			}
		}

		private function setSelectedLabel() : void {
			_label.text = getSelectedLabel();
			_label.validateNow();
		}

		private function showList(show : Boolean) : void {
			if (show) {

				/*
				 * Position
				 */
				
				var point : Point = localToGlobal(new Point(0, 0));
				var posX : int = point.x + _width - _popUp.width;
				if (posX < 0) posX = point.x;
				
				var posY : int;
				var minimisePosY : int;
				
				if (point.y > stage.stageHeight / 2) {
					posY = point.y - _popUp.height - 1;
					minimisePosY = point.y - 1;
				} else {
					posY = point.y + _height + 1;
					minimisePosY = posY;
				}

				_popUp.restorePosition = new WindowPosition(posX, posY);
				_popUp.minimisePosition = new WindowPosition(point.x + _width, minimisePosY);

				_popUp.list.scrollToItemAt(_popUp.list.selectedIndex - 1);

				/*
				 * Show popup
				 */

				PopUpManager.getInstance().createPopUp(_popUp);
				_popUp.restore();

			} else {
				_popUp.minimise();
			}
		}
		
		/*
		 * Events
		 */
		
		private function minimisedHandler(event : WindowEvent) : void {
			_button.selected = false;
			PopUpManager.getInstance().removePopUp(_popUp);
			
			// leave popup in the display list
			addChild(_popUp);
		}

		private function buttonSelectedHandler(event : ButtonEvent) : void {
			showList(_button.selected);
		}

		private function labelClickHandler(event : MouseEvent) : void {
			if (!_enabled) return;
			
			_button.selected = !_button.selected;
			showList(_button.selected);
		}
		
		private function labelRollOverHandler(event : MouseEvent) : void {
			if (_label.textChopped && getStyle(style.toolTips)) {
				ToolTip.getInstance().show(
					this, getSelectedLabel(), new Point(- _buttonSize - 10, 4)
				);
			}
		}
		
		private function labelRollOutHandler(event : MouseEvent) : void {
			if (_label.textChopped && getStyle(style.toolTips)) {
				ToolTip.getInstance().hide(this);
			}
		}
		
		private function itemClickHandler(event : ListItemEvent) : void {
			showList(false);
		}

		private function selectionChangedHandler(event : ListItemEvent) : void {
			var selectBoxEvent : SelectBoxEvent = new SelectBoxEvent(SelectBoxEvent.SELECTION_CHANGED);
			selectBoxEvent.selectedIndex = _popUp.list.selectedIndex;
			dispatchEvent(selectBoxEvent);
		}

		private function itemRollOverHandler(event : ListItemEvent) : void {
			if (!_liveSelecting) return;
			
			var index : uint = event.listIndex;
			_popUp.list.selectItemAt(index);
		}

		private function dataProviderChangedHandler(event : DataProviderEvent) : void {
			invalidateProperty(UPDATE_PROPERTY_DATA_SOURCE);
		}

	}
}
