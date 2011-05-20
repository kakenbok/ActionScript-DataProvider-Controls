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
package com.sibirjak.asdpc.listview.core {
	import com.sibirjak.asdpc.core.asdpc_internal;
	import com.sibirjak.asdpc.listview.ListView;
	
	use namespace asdpc_internal;

	/**
	 * Pool of IListItemRenderer instances.
	 * 
	 * <p>Manages visibility of renderers depending on the number of
	 * items in the list, the pool size and the first visible index.</p> 
	 * 
	 * @author jes 21.10.2009
	 */
	public class ListItemRendererPool {
		
		/**
		 * The ListView that owns the pool.
		 */
		private var _listView : ListView;

		/**
		 * Number of items in the list.
		 */
		private var _numItems : uint;

		/**
		 * Number of pooled IListItemRenderer instances.
		 */
		private var _poolSize : uint;

		/**
		 * First visible index.
		 */
		private var _firstVisibleIndex : uint;

		/**
		 * Currently visible renderers.
		 */
		protected var _visibleRenderers : Array;

		/**
		 * Parked renderers.
		 */
		private var _availableRenderers : Array;
		
		/**
		 * ListItemRendererPool constructor.
		 * 
		 * @param listView The owner.
		 * @param numItems The number of items in the list.
		 * @param poolSize The number of pooled renderes.
		 */
		public function ListItemRendererPool(listView : ListView, numItems : uint, poolSize : uint) {
			_listView = listView;
			_numItems = numItems;
			_poolSize = poolSize;
			_firstVisibleIndex = 0;

			_visibleRenderers = new Array(poolSize);
			_availableRenderers = new Array();
		}
		
		/*
		 * Command the listView to show/hide/position its renderers.
		 */

		/**
		 * Refreshs the listView.
		 */
		public function refresh() : void {
			
			var renderer : IListItemRenderer;
			
			for (var i : uint = 0; i < _poolSize; i++) {
				if (_firstVisibleIndex + i >= _numItems) break;
				renderer = _visibleRenderers[i];

				// renderer for that index exists.
				if (renderer) {
					_listView.updateListItemRendererListIndex_internal(renderer, _firstVisibleIndex + i);

				// try to reuse an available renderer.
				} else {
					renderer = _availableRenderers.pop();

					// renderer exists, that can be reused.
					if (renderer) {
						_listView.setListItemRendererData_internal(renderer, _firstVisibleIndex + i);

					// renderer does not exist, list needs to create one.
					} else {
						renderer = _listView.createNewListItemRenderer_internal(_firstVisibleIndex + i);
					}

					_visibleRenderers[i] = renderer;

					_listView.showListItemRenderer_internal(renderer); // sets property change listener
				}

				_listView.setListItemRendererPosition_internal(renderer, i);
			}
			
		}
		
		/*
		 * Pool size changed.
		 */

		/**
		 * Sets a new pool size.
		 * 
		 * <p>If the new size is lesser, all exceeding renderers become
		 * hidden and marked to be available.</p>
		 * 
		 * <p>If the new size is greater, a corresponding number of
		 * empty items will be appended.</p>
		 * 
		 * @param poolSize The number of pooled renderes.
		 */
		public function set poolSize(poolSize : uint) : void {
			if (poolSize > _poolSize) {
				_visibleRenderers = _visibleRenderers.concat(
					new Array(poolSize - _poolSize)
				);
			} else if (poolSize < _poolSize) {
				hideRenderers(
					_visibleRenderers.splice(
					poolSize, _poolSize - poolSize
				));
				
				// remove unnecessary renderers

				var numVisibleRenderers : uint;
				var renderer : IListItemRenderer;
				for (var i : uint = 0; i < _visibleRenderers.length; i++) {
					if (_visibleRenderers[i] != null) numVisibleRenderers++;
				}
				
				if (numVisibleRenderers + _availableRenderers.length > poolSize) {
					var numItemToRemove : uint = numVisibleRenderers + _availableRenderers.length - poolSize;
					var renderersToRemove : Array = _availableRenderers.splice(- numItemToRemove, numItemToRemove);

					for (i = 0; i < renderersToRemove.length; i++) {
						renderer = renderersToRemove[i];
						_listView.removeListItemRenderer_internal(renderer);
					}
				}

				
			}
			
			_poolSize = poolSize;
		}

		/*
		 * Visible index changed.
		 */

		/**
		 * Sets a new first visible index.
		 * 
		 * @param firstVisibleIndex The first visible index in the listView.
		 */
		public function set firstVisibleIndex(firstVisibleIndex : uint) : void {
			
			var numItemsToRemove : uint;
			
			// remove all renderers before the firstVisibleIndex and add emtpy items to the end
			if (firstVisibleIndex > _firstVisibleIndex) {
				numItemsToRemove = Math.min(_poolSize, firstVisibleIndex - _firstVisibleIndex);
				hideRenderers(
					_visibleRenderers.splice(0, numItemsToRemove)
				);

				_visibleRenderers = _visibleRenderers.concat(new Array(numItemsToRemove));

			// remove renderers from the end and add empty items in front 
			} else if (firstVisibleIndex < _firstVisibleIndex) {
				numItemsToRemove = Math.min(_poolSize, _firstVisibleIndex - firstVisibleIndex);
				
				hideRenderers(
					_visibleRenderers.splice(- numItemsToRemove, numItemsToRemove)
				);

				_visibleRenderers = new Array(numItemsToRemove).concat(_visibleRenderers);
			}
			
			_firstVisibleIndex = firstVisibleIndex;
		}

		/*
		 * Items added or removed.
		 */
		
		/**
		 * Notifies the pool, that items have been added to the list's data provider.
		 * 
		 * @param index Index where items have been added.
		 * @param numItems Number of items added.
		 */
		public function itemsAddedAt(index : uint, numItems : uint) : void {

			_numItems += numItems;
			
			// added before the first visible item
			if (index < _firstVisibleIndex) {
				_firstVisibleIndex += numItems;
			}
			
			// added between visible items
			else if (index < _firstVisibleIndex + _poolSize) {

				// get num items to add in the visible range
				var numItemsToAdd : uint = Math.min(
					_poolSize + _firstVisibleIndex - index,
					numItems
				);
				
				// remove from the end
				hideRenderers(
					_visibleRenderers.splice(- numItemsToAdd, numItemsToAdd)
				);
				
				// add empty items in between
				_visibleRenderers =
					_visibleRenderers.slice(0, index - _firstVisibleIndex)
					.concat(new Array(numItemsToAdd))
					.concat(_visibleRenderers.slice(index - _firstVisibleIndex));
			}
		}
		
		/**
		 * Notifies the pool, that items have been removed from the list's data provider.
		 * 
		 * <p>Case 1: All items are removed before the visible range.
		 * The firstVisibleIndex will be decreased by the number of
		 * items removed.</p>
		 * 
		 * <p>Case 2: All items are removed after the visible range.
		 * There is nothing to do then.</p>
		 * 
		 * <p>Case 3: Items are removed from within the visible range.
		 * All affected renderers will be removed from the visibleRenderers
		 * list and the same number of empty items is added to the end. The
		 * firstVisibleIndex stays as it is.</p>
		 * 
		 * <p>Case 4: Items are removed before and withing the visible range.
		 * The firstVisibleIndex will be decreased by the number of items
		 * removed before this range. All affected renderers will be removed
		 * from the visibleRenderers list and the same number of empty items
		 * is added to the end.</p>
		 * 
		 * @param index Index where items have been removed.
		 * @param numItems Number of items removed.
		 */
		public function itemsRemovedAt(index : uint, numItems : uint) : void {
			
			_numItems -= numItems;
			
			// removed starting before the first visible item
			// decrease the first visible index
			if (index < _firstVisibleIndex) {
				var numHiddenItemsRemoved : uint = Math.min(_firstVisibleIndex - index, numItems);
				_firstVisibleIndex -= numHiddenItemsRemoved;
				
				// no items to remove left
				if (numItems == numHiddenItemsRemoved) return;
				
				numItems = numItems - numHiddenItemsRemoved;
				index = _firstVisibleIndex;
			}
			
			// removed between visible items
			if (index >= _firstVisibleIndex && index < _firstVisibleIndex + _poolSize) {

				// get num items to remove
				var numItemsToRemove : uint = Math.min(
					_poolSize + _firstVisibleIndex - index,
					numItems
				);
				
				// remove in between
				hideRenderers(
					_visibleRenderers.splice(
						index - _firstVisibleIndex,
						numItemsToRemove
					)
				);

				// add empty items to the end
				_visibleRenderers = _visibleRenderers.concat(new Array(numItemsToRemove));
			}

		}
		
		/**
		 * Notifies the pool, that all items have been removed from the data provider.
		 */
		public function allItemsRemoved() : void {
			_numItems = 0;
			_firstVisibleIndex = 0;
			hideRenderers(_visibleRenderers);
			_visibleRenderers = new Array(_poolSize);
		}
		
		/**
		 * Clears the pool.
		 */
		public function clear() : void {
			_numItems = 0;
			_firstVisibleIndex = 0;
			_availableRenderers = new Array();
			_visibleRenderers = new Array(_poolSize);
		}

		/**
		 * Returns the renderer at the given position.
		 * 
		 * @return The renderer at the given position or undefined, if there is no renderer.
		 */
		public function getItemAt(index : uint) : IListItemRenderer {
			return _visibleRenderers[index - _firstVisibleIndex];
		}
		
		/**
		 * Notifies the pool that a renderer moved out of the visible area.
		 * 
		 * @param renderer The renderer, that moved out of the visible area.
		 */
		public function rendererOutOfVisibleArea(renderer : IListItemRenderer) : void {
			_visibleRenderers[renderer.data.listIndex - _firstVisibleIndex] = null;
			_availableRenderers.push(renderer);
			_listView.hideListItemRenderer_internal(renderer);
		}
		
		/*
		 * Private
		 */
		
		/**
		 * Hides renderers.
		 */
		private function hideRenderers(renderers : Array) : void {
			var renderer : IListItemRenderer;
			for (var i : uint = 0; i < renderers.length; i++) {
				renderer = renderers[i];
				if (renderer != null) { // may be null after insertion of empty items
					_availableRenderers.push(renderer);
					_listView.hideListItemRenderer_internal(renderer);
				}
			}
			
		}
		
		/*
		 * Test interface
		 */
		
		/**
		 * Return the array of currently visible renderers.
		 */
		internal function getVisibleRenderers() : Array {
			return _visibleRenderers;
		}
		
		/**
		 * Return the current pool size.
		 */
		internal function getPoolSize() : uint {
			return _poolSize;
		}
		
	}
}
