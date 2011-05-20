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
	import com.sibirjak.asdpc.core.BindableView;
	import com.sibirjak.asdpc.core.Container;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.asdpc_internal;
	import com.sibirjak.asdpc.core.constants.Direction;
	import com.sibirjak.asdpc.core.constants.Visibility;
	import com.sibirjak.asdpc.core.dataprovider.DataProviderEvent;
	import com.sibirjak.asdpc.core.dataprovider.DataSourceAdapterFactory;
	import com.sibirjak.asdpc.core.dataprovider.IDataSourceAdapter;
	import com.sibirjak.asdpc.core.dataprovider.IMapAdapter;
	import com.sibirjak.asdpc.core.skins.GlassFrame;
	import com.sibirjak.asdpc.listview.core.IListItemRenderer;
	import com.sibirjak.asdpc.listview.core.ItemIndexManager;
	import com.sibirjak.asdpc.listview.core.ListItemRendererData;
	import com.sibirjak.asdpc.listview.core.ListItemRendererEvent;
	import com.sibirjak.asdpc.listview.core.ListItemRendererPool;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.scrollbar.IScrollBar;
	import com.sibirjak.asdpc.scrollbar.ScrollBar;
	import com.sibirjak.asdpc.scrollbar.ScrollEvent;

	import org.as3commons.collections.framework.IDataProvider;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	use namespace asdpc_internal;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ListViewStyles#itemSize
	 */
	[Style(name="listView_itemSize", type="uint", format="Size")]

	/**
	 * @copy ListViewStyles#selectedItemSize
	 */
	[Style(name="listView_selectedItemSize", type="uint", format="Size")]

	/**
	 * @copy ListViewStyles#scrollBarSize
	 */
	[Style(name="listView_scrollBarSize", type="uint", format="Size")]

	/**
	 * @copy ListViewStyles#scrollBarVisibility
	 */
	[Style(name="listView_scrollBarVisibility", type="String", enumeration="visible, auto, hidden")]

	/*
	 * ListViewEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListViewEvent.ITEM_ADDED
	 */
	[Event(name="listView_itemAdded", type="com.sibirjak.asdpc.listview.ListViewEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListViewEvent.ITEM_REMOVED
	 */
	[Event(name="listView_itemRemoved", type="com.sibirjak.asdpc.listview.ListViewEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListViewEvent.DATA_RESET
	 */
	[Event(name="listView_dataReset", type="com.sibirjak.asdpc.listview.ListViewEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListViewEvent.SELECTION_CHANGED
	 */
	[Event(name="listView_selectionChanged", type="com.sibirjak.asdpc.listview.ListViewEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListViewEvent.SCROLL
	 */
	[Event(name="listView_scroll", type="com.sibirjak.asdpc.listview.ListViewEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListViewEvent.REFRESH
	 */
	[Event(name="listView_refresh", type="com.sibirjak.asdpc.listview.ListViewEvent")]

	/*
	 * ListItemEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListItemEvent.ROLL_OVER
	 */
	[Event(name="listItem_rollOver", type="com.sibirjak.asdpc.listview.ListItemEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListItemEvent.ROLL_OUT
	 */
	[Event(name="listItem_rollOut", type="com.sibirjak.asdpc.listview.ListItemEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListItemEvent.MOUSE_DOWN
	 */
	[Event(name="listItem_mouseDown", type="com.sibirjak.asdpc.listview.ListItemEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListItemEvent.CLICK
	 */
	[Event(name="listItem_click", type="com.sibirjak.asdpc.listview.ListItemEvent")]

	/**
	 * @eventType com.sibirjak.asdpc.listview.ListItemEvent.SELECTION_CHANGED
	 */
	[Event(name="listItem_selectionChanged", type="com.sibirjak.asdpc.listview.ListItemEvent")]

	/**
	 * ListView component.
	 * 
	 * @author jes 08.07.2009
	 */
	public class ListView extends BindableView implements IListView {
		
		/* style declarations */

		/**
		 * Central accessor to all ListView style property definitions.
		 */
		public static var style : ListViewStyles = new ListViewStyles();
		
		/* constants */

		/**
		 * Name constant for the bindable property ListView.selectedIndex.
		 */
		public static const BINDABLE_PROPERTY_SELECTED_INDEX : String = "selectedIndex";

		/**
		 * Name constant for the bindable property ListView.selectedIndices.
		 */
		public static const BINDABLE_PROPERTY_SELECTED_INDICES : String = "selectedIndices";

		/* changeable properties or styles */

		/**
		 * Name constant for the data source invalidation property.
		 */
		private const UPDATE_PROPERTY_DATA_SOURCE : String = "data_source";

		/**
		 * Name constant for the item size invalidation property.
		 */
		private const UPDATE_PROPERTY_ITEM_SIZE : String = "item_size";

		/**
		 * Name constant for the scroll position invalidation property.
		 */
		private const UPDATE_PROPERTY_FIRST_VISIBLE_INDEX : String = "scroll_position"; // list should be redrawn

		/**
		 * Name constant for the scrollbar size invalidation property.
		 */
		private const UPDATE_PROPERTY_SCROLLBAR_SIZE : String = "scrollbar_size";

		/**
		 * Name constant for the scrollbar visibility invalidation property.
		 */
		private const UPDATE_PROPERTY_SCROLLBAR_VISIBILITY : String = "scrollbar_visibility";

		/* properties */

		/**
		 * The data source.
		 */
		protected var _dataSource : *;

		/**
		 * An optional data source adapter function.
		 */
		protected var _dataSourceAdapterFunction : Function;

		/**
		 * List item renderer.
		 */
		private var _itemRenderer : Class;

		/**
		 * List direction.
		 */
		private var _direction : String = Direction.VERTICAL;

		/**
		 * Select flag.
		 */
		private var _select : Boolean = true;

		/**
		 * Multiselect flag.
		 */
		private var _multiselect : Boolean = false;

		/**
		 * Deselect flag.
		 */
		private var _deselect : Boolean = true;

		/* internal */

		/**
		 * The data source adapter.
		 */
		protected var _dataSourceAdapter : IDataProvider;

		/**
		 * Item renderer pool.
		 */
		private var _itemRendererPool : ListItemRendererPool;

		/**
		 * Selected item index manager.
		 */
		private var _selectedItemsManager : ItemIndexManager;

		/**
		 * Scroll position.
		 */
		private var _firstVisibleIndex : int = -1;

		/**
		 * Items to select initially.
		 */
		private var _itemsToSelect : Array;

		/**
		 * Initial scroll position.
		 */
		private var _indexToScroll : int = -1;
		
		/**
		 * Renderer to event handler map.
		 */
		private var _dataPropertyChangeHandlers : Dictionary = new Dictionary();

		/**
		 * Control variable of the current renderer position during a list refresh.
		 */
		private var _currentItemRendererPosition : int;
		
		/* styles */

		/**
		 * List item size.
		 */
		private var _itemSize : uint;

		/**
		 * Selected item size factor.
		 */
		private var _selectedItemSizeFactor : uint = 1;

		/**
		 * Scrollbar visibility.
		 */
		private var _scrollBarVisiblity : String;

		/**
		 * Scrollbar size.
		 */
		private var _scrollBarSize : int;

		/* children */

		/**
		 * Mouse wheel sensitive area.
		 */
		private var _clickArea : GlassFrame;

		/**
		 * Container of all renderers.
		 */
		private var _itemContainer : Container;

		/**
		 * Mask of the item container.
		 */
		private var _containerMask : GlassFrame;

		/**
		 * Scrollbar.
		 */
		private var _scrollBar : IScrollBar;

		/**
		 * ListView constructor
		 */
		public function ListView() {
			
			// default size
			setDefaultSize(200, 240);

			setBindableProperties([
				BINDABLE_PROPERTY_SELECTED_INDICES,
				BINDABLE_PROPERTY_SELECTED_INDEX
			]);

			setDefaultStyles([
				style.itemSize, 20,
				style.selectedItemSize, 1,

				style.scrollBarSize, 14,
				style.scrollBarVisibility, Visibility.AUTO
			]);
			
			_selectedItemsManager = new ItemIndexManager();
			_itemsToSelect = new Array();

		}
		
		/*
		 * IListView
		 */

		/**
		 * @inheritDoc
		 */
		public function set dataSource(dataSource : *) : void {
			_dataSource = dataSource;
			
			if (_initialised) initDataSource();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get dataSource() : * {
			return _dataSource;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set dataSourceAdapterFunction(dataSourceAdapterFunction : Function) : void {
			_dataSourceAdapterFunction = dataSourceAdapterFunction;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get dataSourceAdapterFunction() : Function {
			return _dataSourceAdapterFunction;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set direction(direction : String) : void {
			if (_initialised) return;
			
			_direction = direction;
		}

		/**
		 * @inheritDoc
		 */
		public function get direction() : String {
			return _direction;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set select(select : Boolean) : void {
			_select = select;
		}

		/**
		 * @inheritDoc
		 */
		public function get select() : Boolean {
			return _select;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set deselect(deselect : Boolean) : void {
			_deselect = deselect;
		}

		/**
		 * @inheritDoc
		 */
		public function get deselect() : Boolean {
			return _deselect;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set multiselect(multiselect : Boolean) : void {
			
			// deselect all selected items except the first one
			if (_initialised && _multiselect && !multiselect) {
				
				var selectedIndices : Array = _selectedItemsManager.indices.concat();
				
				var i : uint;
				for (i = 1; i < selectedIndices.length; i++) {
					deselectItemAt_private(selectedIndices[i], false, false, false);
				}
				
				if (i > 1) {
					if (_selectedItemSizeFactor > 1) setFirstVisibleIndex(_firstVisibleIndex, true);
					dispatchListViewSelectionChanged();
				}

			}

			_multiselect = multiselect;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get multiselect() : Boolean {
			return _multiselect;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getListItemDataAt(listIndex : uint) : ListItemData {
			if (!_initialised) return null;

			// wrong range
			if (listIndex < -1 || listIndex >= _dataSourceAdapter.size) return null;

			return createListItemData(listIndex);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numItems() : uint {
			if (!_initialised) return 0;

			return _dataSourceAdapter.size;
		}

		/**
		 * @inheritDoc
		 */
		public function set itemRenderer(renderer : Class) : void {
			if (_initialised) return;

			_itemRenderer = renderer;
		}

		/*
		 * Scroll
		 */
		
		/**
		 * @inheritDoc
		 */
		public function scrollToItemAt(listIndex : uint) : void {
			if (!_initialised) {
				_indexToScroll = listIndex;
				return;
			}
			
			setFirstVisibleIndex(listIndex, true, true);
		}

		/**
		 * @inheritDoc
		 */
		public function get firstVisibleIndex() : int {
			return _firstVisibleIndex;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxScrollIndex() : int {
			// if an adapter is not yet created return -1
			// we use this method internally
			if (!_initialised) return -1;
			
			return maxScrollIndex_private;
		}

		/*
		 * Selection
		 */

		/**
		 * @inheritDoc
		 */
		public function selectItemAt(listIndex : uint) : void {
			// store list of items to select after initialisation
			if (!_initialised) {
				_itemsToSelect.push(listIndex);
				return;
			}

			// selection not enabled
			if (!_select) return;

			// wrong index
			if (listIndex >= _dataSourceAdapter.size) return;
			
			// select item again not possible
			if (_selectedItemsManager.hasIndex(listIndex)) return;
			
			selectItemAt_private(listIndex, true, false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function deselectItemAt(listIndex : uint) : void {
			// disabled before a list has been added to the stage
			if (!_initialised) return;

			// selection/deselection not enabled
			if (!_deselect) return;

			// wrong index
			if (listIndex >= _dataSourceAdapter.size) return;
			
			// deselect item again not possible
			if (!_selectedItemsManager.hasIndex(listIndex)) return;

			deselectItemAt_private(listIndex, true, false, true);
		}
			
		/**
		 * @inheritDoc
		 */
		public function get selectedIndex() : int {
			return _multiselect ? -1 : _selectedItemsManager.firstIndex;
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedItemData() : ListItemData {
			if (_multiselect) return null;
			
			var selectedIndex : int = _selectedItemsManager.firstIndex;
			if (selectedIndex == -1) return null;
			return createListItemData(selectedIndex);
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedIndices() : Array {
			if (!_multiselect) return new Array();

			return _selectedItemsManager.indices;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectedItemsData() : Array {
			var selectedItems : Array = new Array();

			if (!_multiselect) return selectedItems;

			var selectedIndices : Array = _selectedItemsManager.indices;
			if (selectedIndices.length) {
				for (var i : int = 0; i < selectedIndices.length; i++) {
					selectedItems.push(createListItemData(selectedIndices[i]));
				}
			}
			return selectedItems;
		}

		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			_scrollBarVisiblity = getStyle(style.scrollBarVisibility);
			_scrollBarSize = getStyle(style.scrollBarSize);
			_itemSize = getStyle(style.itemSize);
			_selectedItemSizeFactor = getStyle(style.selectedItemSize);
			
			if (!_itemRenderer) _itemRenderer = getDefaultListItemRenderer();
			if (!_dataSource) _dataSource = [];
			
			initDataSource();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			// click area / background
			// we need this clickarea to track mouse scrolling
			// over the entire list and not only the drawn content
			
			_clickArea = new GlassFrame();
			_clickArea.setSize(_width, _height);
			_clickArea.name = "clickArea";
			addChild(_clickArea);
			
			// container

			_itemContainer = new Container();
			_itemContainer.name = "itemRendererContainer";
			addChild(_itemContainer);

			// mask

			_containerMask = new GlassFrame();
			_containerMask.setSize(maskWidth, maskHeight);
			_containerMask.name = "containerMask";
			_itemContainer.mask = _containerMask;
			addChild(_containerMask);
			
			// scrollbar

			createScrollBar();
			updateAutomatically(DisplayObject(_scrollBar));

			// show items
			
			refreshList();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initialised() : void {
			if (_indexToScroll > -1) scrollToItemAt(_indexToScroll);

			if (_select) {
				var numItemsToSelect : uint = _itemsToSelect.length;
				if (numItemsToSelect) {
					if (_multiselect) { // select all items
						for (var i : uint = 0; i < numItemsToSelect; i++) {
							selectItemAt(_itemsToSelect[i]);
						}
					} else { // select only the last selected
						selectItemAt(_itemsToSelect[numItemsToSelect - 1]);
					}
				}
			}
			_itemsToSelect = null;

			updateAllBindings();
		}

		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			var updateMask : Boolean = false;
			var updateBackground : Boolean = false;

			var resizePool : Boolean = false;
			var resizeItems : Boolean = false;
			var resizeScrollBar : Boolean = false;

			var setScrollBarProperties : Boolean = false;
			var setScrollBarPosition : Boolean = false;
			
			var updateListItems : Boolean = false;
			
			// data changed

			if (isInvalid(UPDATE_PROPERTY_DATA_SOURCE)) {
				setScrollBarProperties = true; // document size and position
				updateListItems = true;
			}

			// size changed
			
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				updateBackground = true;
				updateMask = true;

				// If a scrolled list is minimised too heavy, the index
				// moves down to the zero position.
				setFirstVisibleIndex(_firstVisibleIndex, false);

				resizeItems = true;
				resizePool = true;

				resizeScrollBar = true; // new page size
				setScrollBarProperties = true; // position and page scroll
				updateListItems = true;

			}
			
			// scroll position changed
			
			if (isInvalid(UPDATE_PROPERTY_FIRST_VISIBLE_INDEX)) {
				updateListItems = true;
				setScrollBarPosition = true;
			}

			// scroll bar size changed

			if (isInvalid(UPDATE_PROPERTY_SCROLLBAR_SIZE)) {
				updateMask = true;
				resizeItems = true;
				resizeScrollBar = true;
			}

			// scroll bar visibility changed

			if (isInvalid(UPDATE_PROPERTY_SCROLLBAR_VISIBILITY)) {
				updateMask = true;
				resizeItems = true;
			}

			// item size changed

			if (isInvalid(UPDATE_PROPERTY_ITEM_SIZE)) {
				// If a scrolled list is minimised too heavy, the index
				// moves down to the zero position.
				setFirstVisibleIndex(_firstVisibleIndex, false);
				
				resizePool = true;
				resizeItems = true;

				setScrollBarProperties = true; // document size and position and line scroll

				updateListItems = true;
			}

			// updates
			
			// resize items, if the scrollbar visibility changes
			if (scrollBarVisible() != _scrollBar.visible) {
				updateMask = true;
				_scrollBar.visible = scrollBarVisible();
				resizeItems = true;
			}
			
			if (updateBackground) {
				_clickArea.setSize(_width, _height);
			}

			if (updateMask) {
				_containerMask.setSize(maskWidth, maskHeight);
			}

			if (resizeScrollBar) {
				_scrollBar.setSize(scrollBarWidth, scrollBarHeight);
				_scrollBar.moveTo(scrollBarX, scrollBarY);
			}

			if (resizePool) {
				_itemRendererPool.poolSize = itemsPerPage;
			}

			if (resizeItems) {
				resizeItemRenderers();
			}
			
			if (setScrollBarProperties) {
				_scrollBar.setScrollProperties(_itemSize, _itemSize, pageSize);
				setScrollBarPosition = true;
			}

			if (setScrollBarPosition) {
				_scrollBar.documentSize = documentSize;
				_scrollBar.scrollTo(indexToScrollPosition(_firstVisibleIndex));
			}

			if (updateListItems) {
				refreshList();
			}
			
		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			
			if (property == style.scrollBarSize) {
				_scrollBarSize = value;
				
				invalidateProperty(UPDATE_PROPERTY_SCROLLBAR_SIZE);
			}

			if (property == style.scrollBarVisibility) {
				_scrollBarVisiblity = value;

				invalidateProperty(UPDATE_PROPERTY_SCROLLBAR_VISIBILITY);
			}

			if (property == style.itemSize) {
				
				// make open item size a multiple of the item size
				_itemSize = value;

				invalidateProperty(UPDATE_PROPERTY_ITEM_SIZE);
			}

			if (property == style.selectedItemSize) {
				_selectedItemSizeFactor = value; // must be a multiple of item size

				invalidateProperty(UPDATE_PROPERTY_ITEM_SIZE);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();
			
			// clean up renderers			

			var renderer : IListItemRenderer;
			for (var i : uint = 0; i < _itemContainer.numChildren; i++) {
				renderer = _itemContainer.getChildAt(i) as IListItemRenderer;

				if (renderer.data.item is IEventDispatcher) {
					var handler : Function = _dataPropertyChangeHandlers[renderer];
					if (handler != null) {
						IEventDispatcher(renderer.data.item).removeEventListener(Event.CHANGE, handler);
						delete _dataPropertyChangeHandlers[renderer];
					}
				}

			}
			
			_dataPropertyChangeHandlers = null;

			// remove data source adapter listener
			
			if (_dataSourceAdapter is IEventDispatcher) {
				IEventDispatcher(_dataSourceAdapter).removeEventListener(
					DataProviderEvent.DATA_PROVIDER_CHANGED, dataProviderChangedHandler
				);
			}
			
			if (_dataSourceAdapter is IDataSourceAdapter) {
				IDataSourceAdapter(_dataSourceAdapter).cleanUp();
			}
			
			// remove scroll bar listener

			_scrollBar.removeEventListener(ScrollEvent.SCROLL, scrollBarScrollHandler);

		}

		/*
		 * asdpc_internal
		 */
		
		/**
		 * Creates a new renderer.
		 * 
		 * <p>Invoked only by the internal item renderer pool.</p>
		 * 
		 * @param listIndex The list index of the renderer.
		 */
		asdpc_internal function createNewListItemRenderer_internal(listIndex : uint) : IListItemRenderer {
			var renderer : IListItemRenderer = new _itemRenderer();
			renderer.data = createListItemRendererData(listIndex);
			
			renderer.setSize(itemWidth, itemHeight);
			renderer.setSelectedSize(selectedItemWidth, selectedItemHeight);
			renderer.drawListItem();
			
			_itemContainer.addChild(DisplayObject(renderer));
			
			renderer.visible = false;

			return renderer;
		}
		
		/**
		 * Sets new data to an existing renderer.
		 * 
		 * <p>Invoked only by the internal item renderer pool.</p>
		 * 
		 * @param renderer The existing renderer.
		 * @param listIndex The list index of the renderer.
		 */
		asdpc_internal function setListItemRendererData_internal(renderer : IListItemRenderer, listIndex : uint) : void {
			renderer.data = createListItemRendererData(listIndex);
			renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.DATA_CHANGED));
		}

		/**
		 * Sets a new list index to an existing renderer.
		 * 
		 * <p>Invoked only by the internal item renderer pool.</p>
		 * 
		 * @param renderer The existing renderer.
		 * @param listIndex The new list index of the renderer.
		 */
		asdpc_internal function updateListItemRendererListIndex_internal(renderer : IListItemRenderer, listIndex : uint) : void {
			// The renderer data may show a wrong index after
			// an item has been added at a position before this
			// renderer.
			
			var dispatchChanged : Boolean = false;
			
			if (renderer.data.listIndex != listIndex) {
				renderer.data.listItemData.setListIndex_internal(listIndex);
				renderer.data.listItemData.setItemIndex_internal(listIndex);
				dispatchChanged = true;
			}

			// is first
			if (renderer.data.isFirst && listIndex != 0) {
				renderer.data.setIsFirst_internal(false);
				dispatchChanged = true;
			} else if (!renderer.data.isFirst && listIndex == 0) {
				renderer.data.setIsFirst_internal(true);
				dispatchChanged = true;
			}

			// is first
			if (renderer.data.isLast && listIndex != _dataSourceAdapter.size - 1) {
				renderer.data.setIsLast_internal(false);
				dispatchChanged = true;
			} else if (!renderer.data.isLast && listIndex == _dataSourceAdapter.size - 1) {
				renderer.data.setIsLast_internal(true);
				dispatchChanged = true;
			}

			if (dispatchChanged) {
				renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.LIST_INDEX_CHANGED));
			}

		}

		/**
		 * Positions the given renderer.
		 * 
		 * <p>Invoked only by the internal item renderer pool.</p>
		 * 
		 * <p>This method is called for each visible renderer after every
		 * scroll, insert or remove operation. This is a good place to apply
		 * changes to renderers that should become visible soon.</p>
		 * 
		 * @param renderer The renderer.
		 * @param visibleIndex The visible index of the renderer, where the first visible renderer has
		 * a visibleIndex of 0.
		 */
		asdpc_internal function setListItemRendererPosition_internal(renderer : IListItemRenderer, visibleIndex : uint) : void {
			// refresh starts
			if (!_currentItemRendererPosition) {
				var itemScrollPosition : uint = indexToScrollPosition(renderer.data.listIndex);
				_currentItemRendererPosition = _scrollBar.documentPosition - itemScrollPosition;
			}
			
			var itemPosition : int = _currentItemRendererPosition;
			
			if (itemPosition >= pageSize) {
				_itemRendererPool.rendererOutOfVisibleArea(renderer);
				return;
			}
			
			if (isHorizontal) {
				renderer.x = itemPosition;
			} else {
				renderer.y = itemPosition;
			}
			
			if (_selectedItemsManager.hasIndex(renderer.data.listIndex)) {
				_currentItemRendererPosition += selectedItemSize;
			} else {
				_currentItemRendererPosition += _itemSize;
			}
			
			// validate now
			
			DisplayObjectAdapter.validateNow(DisplayObject(renderer));
		}
		
		/**
		 * Shows the given renderer.
		 * 
		 * <p>Invoked only by the internal item renderer pool.</p>
		 * 
		 * <p>The renderer has been parked beforehand.</p>
		 * 
		 * @param renderer The renderer.
		 */
		asdpc_internal function showListItemRenderer_internal(renderer : IListItemRenderer) : void {
			if (renderer.data.item is IEventDispatcher) {
				
				var handler : Function = function(event : Event) : void {
					renderer.dispatchEvent(createListItemRendererEvent(
						ListItemRendererEvent.DATA_PROPERTY_CHANGED
					));
				};
				_dataPropertyChangeHandlers[renderer] = handler;
				
				IEventDispatcher(renderer.data.item).addEventListener(Event.CHANGE, handler);
			}
			
			renderer.visible = true;
			renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.VISIBILITY_CHANGED));
		}
		
		/**
		 * Hides the given renderer.
		 * 
		 * <p>Invoked only by the internal item renderer pool.</p>
		 * 
		 * @param renderer The renderer.
		 */
		asdpc_internal function hideListItemRenderer_internal(renderer : IListItemRenderer) : void {
			if (renderer.data.item is IEventDispatcher) {
				var handler : Function = _dataPropertyChangeHandlers[renderer];
				IEventDispatcher(renderer.data.item).removeEventListener(Event.CHANGE, handler);
				delete _dataPropertyChangeHandlers[renderer];
			}

			// dispatch a final roll out event to set renderer.over to false
			// TODO if the renderer is not yet initialised because the list has been removed from the
			// display list beforehand this might throw an error
			renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.ROLL_OUT));

			renderer.visible = false;
			renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.VISIBILITY_CHANGED));
			
		}

		/**
		 * Removes the given renderer.
		 * 
		 * <p>Invoked only by the internal item renderer pool.</p>
		 * 
		 * @param renderer The renderer.
		 */
		asdpc_internal function removeListItemRenderer_internal(renderer : IListItemRenderer) : void {
			if (renderer.visible) hideListItemRenderer_internal(renderer); // available renderers are hidden and already cleaned up
			
			DisplayObjectAdapter.cleanUp(DisplayObject(renderer));

			_itemContainer.removeChild(DisplayObject(renderer));
		}

		/**
		 * Selects the item at the given index.
		 * 
		 * <p>Invoked only by a ListItemRendererData instance.</p>
		 * 
		 * @param listIndex The index of the item to select.
		 */
		asdpc_internal function selectItemAt_internal(listIndex : uint) : void {
			// selection not enabled
			if (!_select) return;

			// renderer might be removed beforehand
			if (!getRendererAt(listIndex)) return;

			// select item again not possible
			if (_selectedItemsManager.hasIndex(listIndex)) return;

			selectItemAt_private(listIndex, true, true);

			if (getStyle(style.selectedItemSize) > 1) {
				/*
				 * If the selected item size differs from the normal size,
				 * we need to refresh the list. We force it here to get
				 * a immediate response to the user click action.
				 */
				validateNow();
			}
		}

		/**
		 * Deselects the item at the given index.
		 * 
		 * <p>Invoked only by a ListItemRendererData instance.</p>
		 * 
		 * @param listIndex The index of the item to deselect.
		 */
		asdpc_internal function deselectItemAt_internal(listIndex : uint) : void {
			
			// selection/deselection not enabled
			if (!_deselect) return;

			// renderer might be removed beforehand
			if (!getRendererAt(listIndex)) return;

			// deselect item again not possible
			if (!_selectedItemsManager.hasIndex(listIndex)) return;

			deselectItemAt_private(listIndex, true, true, true);

			if (getStyle(style.selectedItemSize) > 1) {
				/*
				 * If the selected item size differs from the normal size,
				 * we need to refresh the list. We force it here to get
				 * a immediate response to the user click action.
				 */
				validateNow();
			}
		}

		/**
		 * Dispatchs renderer and item roll over events.
		 * 
		 * <p>Invoked only by a ListItemRendererData instance.</p>
		 * 
		 * @param listIndex The index of the item rolled over.
		 */
		asdpc_internal function notifyRollOverRendererAt_internal(listIndex : uint) : void {
			var renderer : IListItemRenderer = getRendererAt(listIndex);
			if (!renderer) return; // renderer might be removed beforehand
			renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.ROLL_OVER));
			dispatchEvent(createListItemEvent(ListItemEvent.ROLL_OVER, renderer.data.listIndex));
			
			DisplayObjectAdapter.validateNow(DisplayObject(renderer));
		}
			
		/**
		 * Dispatchs renderer and item roll out events.
		 * 
		 * <p>Invoked only by a ListItemRendererData instance.</p>
		 * 
		 * @param listIndex The index of the item rolled out.
		 */
		asdpc_internal function notifyRollOutRendererAt_internal(listIndex : uint) : void {
			var renderer : IListItemRenderer = getRendererAt(listIndex);
			if (!renderer) return; // renderer might be removed beforehand
			renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.ROLL_OUT));
			dispatchEvent(createListItemEvent(ListItemEvent.ROLL_OUT, renderer.data.listIndex));

			DisplayObjectAdapter.validateNow(DisplayObject(renderer));
		}

		/**
		 * Dispatchs item mouse down event.
		 * 
		 * <p>Invoked only by a ListItemRendererData instance.</p>
		 * 
		 * @param listIndex The index of the item the mouse is down over.
		 */
		asdpc_internal function notifyMouseDownRendererAt_internal(listIndex : uint) : void {
			// renderer might be removed beforehand
			if (!getRendererAt(listIndex)) return;

			dispatchEvent(createListItemEvent(ListItemEvent.MOUSE_DOWN, listIndex));
		}
		
		/**
		 * Dispatchs item mouse down event.
		 * 
		 * <p>Invoked only by a ListItemRendererData instance.</p>
		 * 
		 * @param listIndex The index of the item clicked.
		 */
		asdpc_internal function notifyClickRendererAt_internal(listIndex : uint) : void {
			// renderer might be removed beforehand
			if (!getRendererAt(listIndex)) return;

			dispatchEvent(createListItemEvent(ListItemEvent.CLICK, listIndex));
		}
		
		/*
		 * Protected
		 */
		
		/**
		 * Returns the renderer at the given list index.
		 */
		protected function getRendererAt(listIndex : uint) : IListItemRenderer {
			return _itemRendererPool.getItemAt(listIndex);
		}

		/**
		 * Returns the containing collection of the item at the given list index.
		 * 
		 * @return The item's containing collection.
		 */
		protected function getParentItem(listIndex : uint) : * {
			return _dataSource;
		}

		/**
		 * Returns the position of the item in the containing collection.
		 * 
		 * @return The position of the item in the containing collection.
		 */
		protected function getItemIndex(listIndex : uint) : * {
			return listIndex;
		}

		/**
		 * Returns the key of the item if the containing collection is an IMap.
		 * 
		 * @return The key of item or null if the containing collection is not a map.
		 */
		protected function getItemKey(listIndex : uint) : * {
			if (_dataSourceAdapter is IMapAdapter) {
				return IMapAdapter(_dataSourceAdapter).getKeyAt(listIndex);
			}
			return null;
		}

		/*
		 * ListViewEvent
		 */
		
		/**
		 * Creates a ListViewEvent.
		 * 
		 * @param type The event type.
		 * @return A ListViewEvent instance.
		 */
		protected function createListViewEvent(type : String) : ListViewEvent {
			return new (getListViewEventClass())(type);
		}

		/**
		 * Returns the concrete ListViewEvent class.
		 * 
		 * <p>ListView: ListViewEvent</p>
		 * 
		 * <p>TreeView: TreeViewEvent</p>
		 * 
		 * @return The concrete ListViewEvent class.
		 */
		protected function getListViewEventClass() : Class {
			return ListViewEvent;
		}
			
		/*
		 * ListItemEvent
		 */
		
		/**
		 * Creates a ListItemEvent.
		 * 
		 * @param type The event type.
		 * @param listIndex The index of the item.
		 * @return A ListItemEvent instance.
		 */
		protected function createListItemEvent(type : String, listIndex : uint) : ListItemEvent {
			return new (getListItemEventClass())(type, createListItemData(listIndex));
		}

		/**
		 * Returns the concrete ListItemEvent class.
		 * 
		 * <p>ListView: ListItemEvent</p>
		 * 
		 * <p>TreeView: TreeNodeEvent</p>
		 * 
		 * @return The concrete ListItemEvent class.
		 */
		protected function getListItemEventClass() : Class {
			return ListItemEvent;
		}
			
		/*
		 * ListItemRendererEvent
		 */

		/**
		 * Creates a ListItemRendererEvent.
		 * 
		 * @param type The event type.
		 * @return A ListItemRendererEvent instance.
		 */
		protected function createListItemRendererEvent(type : String) : ListItemRendererEvent {
			return new (getListItemRendererEventClass())(type);
		}

		/**
		 * Returns the concrete ListItemRendererEvent class.
		 * 
		 * <p>ListView: ListItemRendererEvent</p>
		 * 
		 * <p>TreeView: TreeNodeRendererEvent</p>
		 * 
		 * @return The concrete ListItemRendererEvent class.
		 */
		protected function getListItemRendererEventClass() : Class {
			return ListItemRendererEvent;
		}
			
		/*
		 * ListItemRendererData
		 */

		/**
		 * Creates the item renderer data for the item at the given index.
		 * 
		 * @param listIndex The list index of the item.
		 * @return A ListItemRendererData instance.
		 */
		protected function createListItemRendererData(listIndex : uint) : ListItemRendererData {
			var data : ListItemRendererData = new (getListItemRendererDataClass())();
			data.setListItemData_internal(createListItemData(listIndex));

			data.setListView_internal(this);
			data.setIsFirst_internal(listIndex == 0);
			data.setIsLast_internal(listIndex == _dataSourceAdapter.size - 1);

			return data;
		}
		
		/**
		 * Returns the concrete ListItemRendererData class.
		 * 
		 * <p>ListView: ListItemRendererData</p>
		 * 
		 * <p>TreeView: TreeNodeRendererData</p>
		 * 
		 * @return The concrete ListItemRendererData class.
		 */
		protected function getListItemRendererDataClass() : Class {
			return ListItemRendererData;
		}
			
		/*
		 * ListItemData
		 */

		/**
		 * Creates the item data for the item at the given index.
		 * 
		 * @param listIndex The list index of the item.
		 * @return A ListItemData instance.
		 */
		protected function createListItemData(listIndex : uint) : ListItemData {
			var data : ListItemData = new (getListItemDataClass())();

			data.setListIndex_internal(listIndex);

			data.setParentItem_internal(_dataSource);
			data.setItem_internal(_dataSourceAdapter.itemAt(listIndex));
			data.setItemIndex_internal(getItemIndex(listIndex));
			data.setItemKey_internal(getItemKey(listIndex));

			data.setSelected_internal(_selectedItemsManager.hasIndex(listIndex));

			setAdditionalListItemDataProperties(data);

			return data;
		}
		
		/**
		 * Returns the concrete ListItemData class.
		 * 
		 * <p>ListView: ListItemData</p>
		 * 
		 * <p>TreeView: TreeNodeData</p>
		 * 
		 * @return The concrete ListItemData class.
		 */
		protected function getListItemDataClass() : Class {
			return ListItemData;
		}
			
		/**
		 * Sets additional list item data properties.
		 * 
		 * @param data The list item data to update.
		 */
		protected function setAdditionalListItemDataProperties(data : ListItemData) : void {
		}
		
		/*
		 * ListItemRenderer
		 */

		/**
		 * Returns the concrete default item renderer.
		 * 
		 * <p>ListView: ListItemRenderer</p>
		 * 
		 * <p>TreeView: TreeNodeRenderer</p>
		 * 
		 * @return The concrete item renderer.
		 */
		protected function getDefaultListItemRenderer() : Class {
			return ListItemRenderer;
		}
			
		/**
		 * Initialises the data source.
		 */
		protected function initDataSource() : void {
			
			/*
			 * Create data source adapter
			 */

			if (_dataSourceAdapter) {
				if (_dataSourceAdapter is IEventDispatcher) {
					IEventDispatcher(_dataSourceAdapter).removeEventListener(
						DataProviderEvent.DATA_PROVIDER_CHANGED, dataProviderChangedHandler
					);
				}

				if (_dataSourceAdapter is IDataSourceAdapter) {
					IDataSourceAdapter(_dataSourceAdapter).cleanUp();
				}
			}

			_dataSourceAdapter = createNewDataSourceAdapter();
			
			if (_dataSourceAdapter is IEventDispatcher) {
				IEventDispatcher(_dataSourceAdapter).addEventListener(
					DataProviderEvent.DATA_PROVIDER_CHANGED, dataProviderChangedHandler
				);
			}
			
			/*
			 * Create or update list item renderer pool
			 */

			if (_initialised) {
				_itemRendererPool.allItemsRemoved();
				_itemRendererPool.itemsAddedAt(0, _dataSourceAdapter.size);
			} else {
				createListItemRendererPool();
			}

			/*
			 * Scroll to top
			 */

			setFirstVisibleIndex(0, false);
			
			/*
			 * Deselect all selected items
			 */

			var removedIndices : Array = _selectedItemsManager.removeAllIndices();
			if (removedIndices.length) {
				dispatchListViewSelectionChanged();
			}

			/*
			 * Dispatch reset
			 */
			
			dispatchEvent(createListViewEvent(ListViewEvent.DATA_RESET));

			/*
			 * Update display
			 */
			
			invalidateProperty(UPDATE_PROPERTY_DATA_SOURCE);
			
		}
		
		/**
		 * Creates a new data source adapter.
		 * 
		 * @return The data source Adapter.
		 */
		protected function createNewDataSourceAdapter() : IDataProvider {
			return DataSourceAdapterFactory.getAdapter(_dataSource, _dataSourceAdapterFunction);
		}

		/**
		 * Applies a function to all renderers.
		 * 
		 * @param applyFunction The function to apply.
		 * @param onlyVisibles Indicates, if only visible renderers should be affec
		 */
		protected function applyToRenderers(applyFunction : Function, onlyVisibles : Boolean = true) : void {
			var renderer : IListItemRenderer;
			for (var i : uint = 0; i < _itemContainer.numChildren; i++) {
				renderer = _itemContainer.getChildAt(i) as IListItemRenderer;
				if (onlyVisibles && !renderer.visible) continue;
				applyFunction(renderer);
			}
		}
		
		/*
		 * Private
		 */
		
		/**
		 * Selects the item at the given index.
		 * 
		 * <p>By contract the caller of this method guarantees, that the item at the
		 * given index is not selected.</p>
		 */
		private function selectItemAt_private(
			listIndex : uint,
			dispatchListViewEvent : Boolean,
			dispatchListItemEvent : Boolean
		) : void {

			// deselect selected item

			if (!_multiselect && _selectedItemsManager.firstIndex > -1) {
				deselectItemAt_private(_selectedItemsManager.firstIndex, false, false, false);
			}

			// select item

			_selectedItemsManager.addIndex(listIndex);

			// adjust scroll properties

			if (_selectedItemSizeFactor > 1) setFirstVisibleIndex(_firstVisibleIndex, true);

			// notify renderer

			notifySelectedRenderer(listIndex, true);
			
			// dispatch item selection changed

			if (dispatchListItemEvent) dispatchListItemSelectionChanged(listIndex);

			// dispatch list selection changed

			if (dispatchListViewEvent) dispatchListViewSelectionChanged();
		}

		/**
		 * Deselects the item at the given index.
		 * 
		 * By contract the caller of this method guarantees, that the item at the
		 * given index is selected.
		 */
		private function deselectItemAt_private(
			listIndex : uint,
			dispatchListViewEvent : Boolean,
			dispatchListItemEvent : Boolean,
			invalidateFirstVisibleIndex : Boolean
		) : void {

			// deselect selected item

			_selectedItemsManager.removeIndex(listIndex);

			// adjust scroll properties

			if (invalidateFirstVisibleIndex && _selectedItemSizeFactor > 1) setFirstVisibleIndex(_firstVisibleIndex, true);

			// notify renderer

			notifySelectedRenderer(listIndex, false);

			// dispatch item selection changed

			if (dispatchListItemEvent) dispatchListItemSelectionChanged(listIndex);

			// dispatch list selection changed

			if (dispatchListViewEvent) dispatchListViewSelectionChanged();

		}

		/**
		 * Creates the scrollbar.
		 */
		private function createScrollBar() : void {
			_scrollBar = new ScrollBar();
			_scrollBar.setSize(scrollBarWidth, scrollBarHeight);

			_scrollBar.owner = this;
			_scrollBar.direction = _direction;
			_scrollBar.setScrollProperties(_itemSize, _itemSize, pageSize);
			_scrollBar.documentSize = documentSize;
			_scrollBar.visible = scrollBarVisible();
			
			updateAutomatically(DisplayObject(_scrollBar));

			_scrollBar.moveTo(scrollBarX, scrollBarY);
			_scrollBar.addEventListener(ScrollEvent.SCROLL, scrollBarScrollHandler);
			addChild(DisplayObject(_scrollBar));
		}

		/**
		 * Creates the list item renderer pool.
		 */
		private function createListItemRendererPool() : void {
			_itemRendererPool = new ListItemRendererPool(
				this,
				_dataSourceAdapter.size,
				itemsPerPage
			);
		}

		/**
		 * Event handler for data provider changes.
		 */
		private function dataProviderChangedHandler(event : DataProviderEvent) : void {
			
			var listViewEvent : ListViewEvent;
			var removedIndices : Array;

			switch (event.kind) {

				case DataProviderEvent.ITEM_ADDED:

//					trace ("ListDataProviderEvent.ITEM_ADDED index" + event.index + " numItems" + event.numItems);

					// update visible items 
					_itemRendererPool.itemsAddedAt(event.index, event.numItems);

					// update selected items
					_selectedItemsManager.itemsAddedAt(event.index, event.numItems);

					// set new position 
					if (event.index <= _firstVisibleIndex) {
						// items added before the first visible index
						setFirstVisibleIndex(_firstVisibleIndex + event.numItems, true);
					} else {
						// -1 may become here to 0
						setFirstVisibleIndex(_firstVisibleIndex, true);
					}

					// dispatch list view event
					listViewEvent = createListViewEvent(ListViewEvent.ITEM_ADDED);
					listViewEvent.listIndex = event.index;
					listViewEvent.numItems = event.numItems;
					dispatchEvent(listViewEvent);

					break;

				case DataProviderEvent.ITEM_REMOVED:
//					 trace ("ListDataProviderEvent.ITEM_REMOVED index" + event.index + " numItems" + event.numItems);

					// update visible items 
					_itemRendererPool.itemsRemovedAt(event.index, event.numItems);

					// update selected items
					removedIndices = _selectedItemsManager.itemsRemovedAt(event.index, event.numItems);
					if (removedIndices.length) {
						dispatchListViewSelectionChanged();
					}

					// set new position 
					if (event.index < _firstVisibleIndex) {
						// calculate num itmes removed before the first visible index
						var itemsBeforeFirstVisible : uint = Math.min(_firstVisibleIndex - event.index, event.numItems);
						setFirstVisibleIndex(_firstVisibleIndex - itemsBeforeFirstVisible, true);
					} else {
						// in a scrolled list the first visible index may move down
						// if too much items are removed from the end. 
						setFirstVisibleIndex(_firstVisibleIndex, true);
					}
					
					// dispatch list view event
					listViewEvent = createListViewEvent(ListViewEvent.ITEM_REMOVED);
					listViewEvent.listIndex = event.index;
					listViewEvent.numItems = event.numItems;
					dispatchEvent(listViewEvent);
					
					break;

				case DataProviderEvent.RESET:
//					 trace ("ListDataProviderEvent.RESET");

					// update visible items 
					_itemRendererPool.allItemsRemoved();
					_itemRendererPool.itemsAddedAt(0, _dataSourceAdapter.size);

					// update selected items
					removedIndices = _selectedItemsManager.removeAllIndices();
					if (removedIndices.length) {
						dispatchListViewSelectionChanged();
					}
					
					// set new position 
					setFirstVisibleIndex(0, true);
					
					// dispatch list view event
					dispatchEvent(createListViewEvent(ListViewEvent.DATA_RESET));

					break;
			}
			
		}
		
		/**
		 * Sets the first visible index.
		 */
		private function setFirstVisibleIndex(firstVisibleIndex : int, invalidateFirstVisibleIndex : Boolean, invalidateOnlyIfChanged : Boolean = false) : void {
			firstVisibleIndex = minMaxFirstVisibleIndex(firstVisibleIndex);
			
			if (firstVisibleIndex == _firstVisibleIndex) {
				if (invalidateOnlyIfChanged) return;

			} else {
				_firstVisibleIndex = firstVisibleIndex;
			}
			
			if (invalidateFirstVisibleIndex) invalidateProperty(UPDATE_PROPERTY_FIRST_VISIBLE_INDEX);
		}

		/**
		 * Ranges a possible first visible index.
		 */
		private function minMaxFirstVisibleIndex(firstVisibleIndex : int) : int {
			// index cannot be -1 if items are present
			firstVisibleIndex = Math.max(minScrollIndex_private, firstVisibleIndex);
			// cannot become more than max scroll index
			firstVisibleIndex = Math.min(maxScrollIndex_private, firstVisibleIndex);
			// cannot become less than -1
			return Math.max(-1, firstVisibleIndex);
		}
			
		/**
		 * Resizes all item renderers.
		 */
		private function resizeItemRenderers() : void {
			var renderer : IListItemRenderer;
			for (var i : uint = 0; i < _itemContainer.numChildren; i++) {
				renderer = _itemContainer.getChildAt(i) as IListItemRenderer;
				renderer.setSize(itemWidth, itemHeight);
				renderer.setSelectedSize(selectedItemWidth, selectedItemHeight);
			}
		}

		/**
		 * Refreshs the list.
		 */
		private function refreshList() : void {
			_itemRendererPool.firstVisibleIndex = _firstVisibleIndex;
			_itemRendererPool.refresh();
			
			// resets the current item position, which is counted during a refresh
			_currentItemRendererPosition = 0;
			

			dispatchEvent(createListViewEvent(ListViewEvent.REFRESH));
		}

		/**
		 * Returns true, if the scrollbar should currently be visible.
		 */
		private function scrollBarVisible() : Boolean {
			return (
				documentSize > pageSize && _scrollBarVisiblity != Visibility.HIDDEN
				|| _scrollBarVisiblity == Visibility.VISIBLE
			);
		}

		/**
		 * Notifies the affected renderer about its selection or deselection.
		 * 
		 * <p>A renderer should immediately response to a selection event,
		 * so we validate the renderer now.</p> 
		 */
		private function notifySelectedRenderer(listIndex : uint, selected : Boolean) : void {
			var renderer : IListItemRenderer = _itemRendererPool.getItemAt(listIndex);
			if (renderer) { // if renderer is visible
				renderer.data.listItemData.setSelected_internal(selected);
				renderer.dispatchEvent(createListItemRendererEvent(ListItemRendererEvent.SELECTION_CHANGED));
			}
				
		}

		/**
		 * Dispatch a list view selection changed event and updates all bindings.
		 */
		private function dispatchListViewSelectionChanged() : void {
			updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_INDICES);
			updateBindingsForProperty(BINDABLE_PROPERTY_SELECTED_INDEX);
			
			dispatchEvent(createListViewEvent(ListViewEvent.SELECTION_CHANGED));
		}
		
		/**
		 * Dispatch a list item selection changed event.
		 */
		private function dispatchListItemSelectionChanged(listIndex : uint) : void {
			dispatchEvent(createListItemEvent(
				ListItemEvent.SELECTION_CHANGED, listIndex
			));
		}
		
		/**
		 * Handler for scroll bar events.
		 */
		private function scrollBarScrollHandler(event : ScrollEvent) : void {
			
			var oldFirstVisibleIndex : int = _firstVisibleIndex;
			var oldFirstVisibleItem : * = _firstVisibleIndex > -1 ? _dataSourceAdapter.itemAt(_firstVisibleIndex) : null;

			_firstVisibleIndex = scrollPositionToIndex(event.documentPosition);
			
			refreshList();
			
			var firstVisibleItem : * = _firstVisibleIndex > -1 ? _dataSourceAdapter.itemAt(_firstVisibleIndex) : null;
			if (_firstVisibleIndex != oldFirstVisibleIndex || firstVisibleItem != oldFirstVisibleItem) {
				dispatchEvent(createListViewEvent(ListViewEvent.SCROLL));
			}
		}
		
		/**
		 * Converses a scroll position into a first visible index.
		 */
		private function scrollPositionToIndex(position : Number) : int {
			var maxIndex : int = - position / _itemSize;

			// no open items
			if (!_selectedItemsManager.numItemsBefore(maxIndex)) return maxIndex;

			var minIndex : int = Math.floor(- position / selectedItemSize);
			
			return getNearestIndex(minIndex, maxIndex, position);
		}
		
		/**
		 * Converses an index into a scroll position.
		 */
		private function indexToScrollPosition(index : int) : int {
			if (index < 1) return 0;
			
			var numOpenItemsBefore : uint = _selectedItemsManager.numItemsBefore(index);
			
			return (- (numOpenItemsBefore * selectedItemSize + (index - numOpenItemsBefore) * _itemSize));
		}

		/**
		 * Algorithm to find the nearest visible index for a given scroll position.
		 */
		private function getNearestIndex(startIndex : uint, endIndex : uint, position : Number) : int {
			
			var currentIndex : int;
			var result : int;

			while (startIndex <= endIndex) {
				currentIndex = (endIndex + startIndex) / 2;
				
				result = compare(currentIndex - 1, currentIndex, currentIndex + 1);
				
				switch (result) {
					case -2: // predecessor greater than 0
						endIndex = currentIndex - 1;
						break;
					case -1: // predecessor with least distance
						return currentIndex - 1;
						break;
					case 0: // current index with least distance
						return currentIndex;
						break;
					case 1: // successor with least distance
						return currentIndex + 1;
						break;
					case 2: // successor less than 0
						startIndex = currentIndex + 1;
						break;
				}

			}

			return 0;
			
			function compare(indexBefore : int, currentIndex : int, indexAfter : int) : int {
				
				var diffBefore : int = position - indexToScrollPosition(indexBefore);
				if (diffBefore == 0) return -1; // 0, +y, +z
				if (diffBefore > 0) return -2; // +x, +y, +z

				// now the first diff is < 0
				// -x, (-y, 0, +y), (-z, 0, +z)

				var diffAfter : int = position - indexToScrollPosition(indexAfter);
				if (diffAfter == 0) return 1; // -x, -y, 0
				if (diffAfter < 0) return 2; // -x, -y, -z
				
				// now the first diff is < 0 and the last diff > 0
				// -x, (-y, 0, +y), +z

				var diff : int = position - indexToScrollPosition(currentIndex);
				if (diff <= 0) return 0; // -x, (-y, 0), +z
				return -1; // -x, +y, +z
				
			}

		}

		/*
		 * State distinction
		 */
		
		/**
		 * Returns the minimal possible first visible index.
		 */
		private function get minScrollIndex_private() : int {
			return _dataSourceAdapter.size ? 0 : -1;
		}

		/**
		 * Returns the maximal possible first visible index.
		 */
		private function get maxScrollIndex_private() : int {
			if (!_dataSourceAdapter.size) return -1;
			if (documentSize <= pageSize) return 0;

			var maxDocumentPosition : int = - (documentSize - pageSize);
			return scrollPositionToIndex(maxDocumentPosition);
		}
		
		/**
		 * Returns the maximal number of visible renderers.
		 */
		private function get itemsPerPage() : uint {
			return pageSize % _itemSize
				? Math.floor(pageSize / _itemSize) + 1
				: pageSize / _itemSize;
		}

		/**
		 * Returns the real size of the listView.
		 */
		private function get documentSize() : uint {
			var documentSize : uint
				= _dataSourceAdapter.size * _itemSize
				+ _selectedItemsManager.size * (selectedItemSize - _itemSize);

			if (pageSize % _itemSize) {
				documentSize += (pageSize % _itemSize);
			}
			return documentSize;
		}
		
		/**
		 * Returns true, if the list is a horizontal list.
		 */
		private function get isHorizontal() : Boolean {
			return _direction == Direction.HORIZONTAL;
		}
		
		/**
		 * Returns scrollbar x position.
		 */
		private function get scrollBarX() : uint {
			return isHorizontal ? 0 : _width - _scrollBarSize;
		}

		/**
		 * Returns scrollbar y position.
		 */
		private function get scrollBarY() : uint {
			return isHorizontal ? _height - _scrollBarSize : 0;
		}

		/**
		 * Returns scrollbar width.
		 */
		private function get scrollBarWidth() : uint {
			return isHorizontal ? _width : _scrollBarSize;
		}

		/**
		 * Returns scrollbar height.
		 */
		private function get scrollBarHeight() : uint {
			return isHorizontal ? _scrollBarSize : _height;
		}

		/**
		 * Returns the renderer width.
		 */
		private function get itemWidth() : uint {
			return isHorizontal
				? _itemSize
				: scrollBarVisible()
					? _width - _scrollBarSize - 1
					: _width;
		}

		/**
		 * Returns the renderer height.
		 */
		private function get itemHeight() : uint {
			return isHorizontal
				? scrollBarVisible()
					? _height - _scrollBarSize - 1
					: _height
				: _itemSize;
		}

		/**
		 * Returns the selected renderer width.
		 */
		private function get selectedItemWidth() : uint {
			return isHorizontal
				? selectedItemSize
				: scrollBarVisible()
					? _width - _scrollBarSize - 1
					: _width;
		}

		/**
		 * Returns the selected renderer height.
		 */
		private function get selectedItemHeight() : uint {
			return isHorizontal
				? scrollBarVisible()
					? _height - _scrollBarSize - 1
					: _height
				: selectedItemSize;
		}

		/**
		 * Returns the list size in respect to its direction.
		 */
		private function get pageSize() : uint {
			return isHorizontal ? _width : _height;
		}
		
		/**
		 * Returns the selected item size.
		 */
		private function get selectedItemSize() : uint {
			return _selectedItemSizeFactor * _itemSize;
		}

		/**
		 * Returns the item container mask width.
		 */
		private function get maskWidth() : uint {
			return isHorizontal
				? _width
				: itemWidth;
		}

		/**
		 * Returns the item container mask height.
		 */
		private function get maskHeight() : uint {
			return isHorizontal
				? itemHeight
				: _height;
		}
		
	}
}
