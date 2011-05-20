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
package com.sibirjak.asdpcbeta.tabbar {
	import com.sibirjak.asdpc.core.BindableView;
	import com.sibirjak.asdpcbeta.tabbar.skins.TabItemSkin;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author jes 03.12.2009
	 */
	public class TabBar extends BindableView {
		
		/* style declarations */
		public static var style : TabBarStyles = new TabBarStyles();

		/* constants */
		public static const BINDABLE_PROPERTY_SELECTED_TAB_NAME : String = "selectedTabName";

		public static const VIEW_PROPERTY_FIRST_ITEM : String = "tabBarFirstItem";
		public static const VIEW_PROPERTY_LAST_ITEM : String = "tabBarLastItem";
		
		/* properties */
		private var _tabs : Array;

		/* internals */
		private var _selectedTab : TabItem;
		private var _labelTabMap : Dictionary;
		private var _tabNameToSelect : String;

		public function TabBar() {
			
			setBindableProperties([BINDABLE_PROPERTY_SELECTED_TAB_NAME]);
			
			setDefaultStyles([
				style.tabItemSkin, TabItemSkin,
				style.selectedTabItemSkin, TabItemSkin
			]);
			
			_labelTabMap = new Dictionary();
		}
		
		public function set tabs(tabs : Array) : void {
			_tabs = tabs;
		}
		
		public function set selectedTabName(tabName : String) : void {
			if (!_initialised) {
				_tabNameToSelect = tabName;
				return;
			}
			var tab : TabItem = _labelTabMap[tabName];
			selectTab(tab);
		}

		public function get selectedTabName() : String {
			// TODO catch !_initialised
			return _selectedTab.label;
		}

		/*
		 * View life cycle
		 */

		override protected function draw() : void {
			
			var numChars : uint;
			var i : uint;
			
			for (i = 0; i < _tabs.length; i++) {
				numChars += String(_tabs[i]).length;
			}
			var averageNumChars : uint = numChars / _tabs.length;
			
			var tabWidth : Number = Math.floor(_width / _tabs.length);
			var tab : TabItem;
			var widthRatio : Number;
			var currentX : uint = 0;

			for (i = 0; i < _tabs.length; i++) {
				tab = new TabItem();
				tab.tabBar = this;
				
				widthRatio = (String(_tabs[i]).length + averageNumChars) / numChars / 2;
				tabWidth = Math.round(_width * widthRatio);
				
				if (i == _tabs.length - 1) {
					tab.setSize(_width - currentX, _height);
				} else {
					tab.setSize(tabWidth, _height);
				}

				tab.setViewProperty(VIEW_PROPERTY_FIRST_ITEM, i == 0);
				tab.setViewProperty(VIEW_PROPERTY_LAST_ITEM, i == _tabs.length -1);

				tab.label = _tabs[i];
				
				tab.moveTo(currentX, 0);
				tab.addEventListener(MouseEvent.CLICK, tabClickHandler);
				addChild(tab);
				
				currentX += tabWidth;
				
				_labelTabMap[_tabs[i]] = tab;
			}

			if (_labelTabMap[_tabNameToSelect]) {
				tab = _labelTabMap[_tabNameToSelect];
			} else {
				tab = _labelTabMap[_tabs[0]];
			}
				
			tab.selected = true;
			_selectedTab = tab;
		}

		override protected function initialised() : void {
			updateAllBindings();
		}

		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();
			
			for each (var tab : TabItem in _labelTabMap) {
				tab.removeEventListener(MouseEvent.CLICK, tabClickHandler);
			}
			_labelTabMap = null;
		}
		
		/*
		 * Private
		 */

		private function tabClickHandler(event : MouseEvent) : void {
			selectTab(event.currentTarget as TabItem);
		}
		
		private function selectTab(tab : TabItem) : void {
			if (tab != _selectedTab) {
				_selectedTab.selected = false;
				tab.selected = true;
				_selectedTab = tab;

				updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_TAB_NAME);
			}
		}
	}
}
