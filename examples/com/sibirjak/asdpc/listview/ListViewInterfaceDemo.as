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
package com.sibirjak.asdpc.listview {
	import com.sibirjak.asdpc.common.dataprovider.ArrayListItem;
	import com.sibirjak.asdpc.common.dataprovider.DataSourceCreator;
	import com.sibirjak.asdpc.common.dataprovider.IItem;
	import com.sibirjak.asdpc.common.icons.IconFactory;
	import com.sibirjak.asdpc.common.interfacedemo.WindowContainer;
	import com.sibirjak.asdpc.common.interfacedemo.windows.configuration.ConfigurationWindow;
	import com.sibirjak.asdpc.common.interfacedemo.windows.data.DataWindow;
	import com.sibirjak.asdpc.common.interfacedemo.windows.events.EventItem;
	import com.sibirjak.asdpc.common.interfacedemo.windows.events.EventWindow;
	import com.sibirjak.asdpc.common.interfacedemo.windows.info.InfoWindow;
	import com.sibirjak.asdpc.common.interfacedemo.windows.navigation.NavigationWindow;
	import com.sibirjak.asdpc.common.interfacedemo.windows.styles.StyleWindow;
	import com.sibirjak.asdpc.common.pinbar.PinBar;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.listview.interfacedemo.SelectedListItemContent;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.configuration.BehaviourTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.configuration.ConfigurationTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.configuration.SizeTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.data.DataWindowContent;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.events.EventWindowContent;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.navigation.NavigationWindowContent;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.styles.BackgroundTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.styles.IconTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.styles.LabelTab;
	import com.sibirjak.asdpc.listview.interfacedemo.windows.styles.ScrollBarTab;
	import com.sibirjak.asdpc.listview.renderer.ListItemIcon;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpcbeta.window.Window;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author jes 01.12.2009
	 */
	public class ListViewInterfaceDemo extends Sprite {
		
		protected var _listView : IListView;

		private var _dataWindow : Window;
		private var _configurationWindow : Window;
		private var _styleWindow : Window;
		private var _navigationWindow : Window;
		private var _eventWindow : Window;
		private var _infoWindow : Window;
		
		private var _backgroundColor : uint;
		
		/*
		 * Static
		 */

		public static function createDataSource(numItems : uint = 30) : IItem {
			return DataSourceCreator.createList(ArrayListItem, numItems);
		}

		public function ListViewInterfaceDemo() {
			
 			/*
 			 * ListView
 			 */
 			 
 			createListView();
 			
			/*
			 * Windows
			 */

			var windowContainer : WindowContainer = new WindowContainer();
			addChild(windowContainer);

 			/*
 			 * Events
 			 */

			_eventWindow = new EventWindow();
			_eventWindow.setSize(240, 244);
			_eventWindow.document = getEventWindowContent();
			_eventWindow.minimised = true;
			_eventWindow.moveTo(200, 20);
			windowContainer.addChild(_eventWindow);
			
 			/*
 			 * Info
 			 */

			_infoWindow = new InfoWindow(_listView);
			_infoWindow.setSize(440, 500);
			_infoWindow.minimised = true;
			_infoWindow.moveTo(240, 50);
			windowContainer.addChild(_infoWindow);
			
			/*
 			 * Navigation
 			 */

			_navigationWindow = new NavigationWindow();
			_navigationWindow.setSize(280, 372);
			_navigationWindow.document = getNavigationContent();
			_navigationWindow.minimised = true;
			_navigationWindow.moveTo(360, 160);
			windowContainer.addChild(_navigationWindow);

			/*
 			 * Styles
 			 */

			_styleWindow = new StyleWindow();
			_styleWindow.setSize(340, 360);
			
			_styleWindow.documents = [
				"Background", new BackgroundTab(_listView),
				getIconTabName(), getIconTab(),
				"Label", new LabelTab(_listView),
				"Scrollbar", new ScrollBarTab(_listView)
			];
			_styleWindow.selectedTabName = "List";

			_styleWindow.moveTo(280, 80);
			windowContainer.addChild(_styleWindow);

  			/*
 			 * Size
 			 */

			_configurationWindow = new ConfigurationWindow();
			_configurationWindow.setSize(340, 360);

			_configurationWindow.documents = [
				"Size", getSizeTab(),
				"Appearance", getConfigurationTab(),
				"Behaviour", getBehaviourTab()
			];

			_configurationWindow.moveTo(320, 120);
			windowContainer.addChild(_configurationWindow);

 			/*
 			 * Data
 			 */

			_dataWindow = new DataWindow();
			_dataWindow.setSize(330, 372);
			
			_dataWindow.document = getDataContent();

			_dataWindow.moveTo(400, 200);
			windowContainer.addChild(_dataWindow);

 			/*
 			 * PinBar
 			 */

			var pinBar : PinBar = new PinBar();
			pinBar.setStyle(PinBar.style.position, Position.RIGHT);
			
			pinBar.registerWindow(_dataWindow, DataWindow.pinBarIconSkin);
			pinBar.registerWindow(_navigationWindow, _navigationWindow.getStyle(Window.style.windowIconSkin));
			pinBar.registerWindow(_configurationWindow, ConfigurationWindow.pinBarIconSkin);
			pinBar.registerWindow(_styleWindow, _styleWindow.getStyle(Window.style.windowIconSkin));
			pinBar.registerWindow(_infoWindow, _infoWindow.getStyle(Window.style.windowIconSkin));
			pinBar.registerWindow(_eventWindow, _eventWindow.getStyle(Window.style.windowIconSkin));
			
			addChild(pinBar);
			
			/*
			 * Tree view events
			 */

			_listView.addEventListener(ListViewEvent.SCROLL, scrollHandler);
			_listView.addEventListener(ListViewEvent.REFRESH, refreshHandler);
			_listView.addEventListener(ListViewEvent.ITEM_ADDED, itemAddedHandler);
			_listView.addEventListener(ListViewEvent.ITEM_REMOVED, itemRemovedHandler);
			_listView.addEventListener(ListViewEvent.DATA_RESET, dataResetHandler);
			_listView.addEventListener(ListViewEvent.SELECTION_CHANGED, listSelectionChangedHandler);
			
			_listView.addEventListener(ListItemEvent.ROLL_OVER, rollOverHandler);
			_listView.addEventListener(ListItemEvent.ROLL_OUT, rollOutHandler);

			_listView.addEventListener(ListItemEvent.MOUSE_DOWN, mouseDownHandler);
			_listView.addEventListener(ListItemEvent.CLICK, clickHandler);

			_listView.addEventListener(ListItemEvent.SELECTION_CHANGED, selectionChangedHandler);
		}
		
		public function get backgroundColor() : uint {
			return _backgroundColor;
		}
		
		public function set backgroundColor(backgroundColor : uint) : void {
			_backgroundColor = backgroundColor;

			with (graphics) {
				clear();
				beginFill(_backgroundColor);
				drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				endFill();

				lineStyle(1, 0xCCCCCC);
				drawRect(0, 0, stage.stageWidth - 1, stage.stageHeight - 1);
			}
		}

		/*
		 * Protected
		 */

		protected function getListViewClass() : Class {
			return ListView;
		}
		
		protected function setListViewProperties() : void {
		}

		protected function getDataSource() : IItem {
 			return createDataSource();
		}

		protected function getSizeTab() : SizeTab {
			return new SizeTab(_listView);
		}

		protected function getConfigurationTab() : ConfigurationTab {
			return new ConfigurationTab(_listView);
		}

		protected function getBehaviourTab() : BehaviourTab {
			return new BehaviourTab(_listView);
		}

		protected function getDataContent() : DataWindowContent {
			return new DataWindowContent(_listView);
		}

		protected function getEventWindowContent() : EventWindowContent {
			return new EventWindowContent();
		}

		protected function getNavigationContent() : NavigationWindowContent {
			return new NavigationWindowContent(_listView);
		}

		protected function getIconTab() : View {
			return new IconTab(_listView);
		}

		protected function getIconTabName() : String {
			return "Icon";
		}

		protected function addEvent(type : String, string : String) : void{
			EventWindowContent(_eventWindow.document).addEvent(new EventItem(type, string));
		}

		/*
		 * Private
		 */

		private function createListView() : void {
 			_listView = new (getListViewClass())();
 			_listView.setSize(400, 400);

			var iconFunction : Function = function (data : ListItemData) : Class {
				return IconFactory.getInstance().getIconSkin(IItem(data.item).category);
			};

			_listView.setStyle(ListView.style.selectedItemSize, 60);
			_listView.setStyle(ListItemRenderer.style.selectedItemContentRenderer, SelectedListItemContent);
			_listView.setStyle(ListItemIcon.style.iconSkinFunction, iconFunction);

			_listView.name = "listViewDemo";	
 			_listView.multiselect = false;
			_listView.dataSource = getDataSource();
			_listView.moveTo(10, 10);
			
			setListViewProperties();
			
			addChild(DisplayObject(_listView));
		}
		
		/*
		 * Events
		 */

		private function dataResetHandler(event : ListViewEvent) : void {
			addEvent(EventItem.TYPE_LIST_VIEW, "DATA_RESET");
		}

		private function itemAddedHandler(event : ListViewEvent) : void {
			addEvent(EventItem.TYPE_LIST_VIEW, "ITEM_ADDED: " + event.numItems + " items at " + event.listIndex);
		}

		private function itemRemovedHandler(event : ListViewEvent) : void {
			addEvent(EventItem.TYPE_LIST_VIEW, "ITEM_REMOVED: " + event.numItems + " items at " + event.listIndex);
		}

		private function scrollHandler(event : ListViewEvent) : void {
			var listItemData : ListItemData = _listView.getListItemDataAt(_listView.firstVisibleIndex);
			addEvent(EventItem.TYPE_LIST_VIEW, "SCROLL to " + _listView.firstVisibleIndex + ": " + IItem(listItemData.item).name);
		}

		private function listSelectionChangedHandler(event : ListViewEvent) : void {
			addEvent(EventItem.TYPE_LIST_VIEW, "SELECTION_CHANGED");
		}

		private function refreshHandler(event : ListViewEvent) : void {
			addEvent(EventItem.TYPE_LIST_VIEW, "REFRESH");
		}

		private function selectionChangedHandler(event : ListItemEvent) : void {
			if (event.selected) {
				addEvent(EventItem.TYPE_LIST_ITEM, "SELECTED at " + event.listIndex + ": " + IItem(event.item).name);
			} else {
				addEvent(EventItem.TYPE_LIST_ITEM, "DESELECTED at " + event.listIndex + ": " + IItem(event.item).name);
			}
		}

		private function rollOverHandler(event : ListItemEvent) : void {
			addEvent(EventItem.TYPE_LIST_ITEM, "ROLL_OVER at " + event.listIndex + ": " + IItem(event.item).name);
		}

		private function rollOutHandler(event : ListItemEvent) : void {
			addEvent(EventItem.TYPE_LIST_ITEM, "ROLL_OUT at " + event.listIndex + ": " + IItem(event.item).name);
		}

		private function mouseDownHandler(event : ListItemEvent) : void {
			addEvent(EventItem.TYPE_LIST_ITEM, "MOUSE_DOWN at " + event.listIndex + ": " + IItem(event.item).name);
		}
		
		private function clickHandler(event : ListItemEvent) : void {
			addEvent(EventItem.TYPE_LIST_ITEM, "CLICK at " + event.listIndex + ": " + IItem(event.item).name);
		}
		
	}
}
