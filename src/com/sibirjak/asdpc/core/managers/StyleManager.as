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
package com.sibirjak.asdpc.core.managers {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * ActionScript display object style manager.
	 * 
	 * <p>The StyleManager fulfills the following tasks:</p>
	 * 
	 * <ul>
	 * <li>Setting styles to a display object.</li>
	 * <li>Calculating and returning styles for a particular display object.</li>
	 * <li>Notifying display objects, if style values change.</li>
	 * </ul>
	 * 
	 * <strong>Base concept</strong>
	 * 
	 * <p>A distinction between object styles and properties can be made
	 * by looking at the object's state. While properties usually switch the
	 * object from one state to another, a changed style keeps the objects
	 * state but modifies its visualisation or visual behaviour. It is indeed
	 * not always obvious whether an entitiy should be modeled as a property
	 * or as a style.</p>
	 * 
	 * <p>While a property has to be set directly to an object, a style can
	 * also be set to a display ancestor and will be recognised by the object
	 * we want to apply the style to.</p>
	 * 
	 * <p>Both setting and getting a style examines the display hierarchy branch
	 * from which the particular object is part of. In order to do so, all objects
	 * of the display list need to implement the IStyleManagerClient interface.</p>
	 * 
	 * <strong>Getting a style</strong>
	 * 
	 * <p>A style set to a particular display object is available to this
	 * object and all of its children. Getting a style value performs the
	 * following lookup throughout the objects parent chain:</p>
	 * 
	 * <ul>
	 * <li>Test for a directly assigned style.</li>
	 * <li>(If undefined:) Test the value returned by parent.getStyle().</li>
	 * <li>(If undefined:) Test for a default style that has been defined for the object.</li>
	 * <li>Return the value found or undefined.</li>
	 * </ul>
	 * 
  	 * <listing>
		var view : ParentView = new ParentView();
		view.setStyle("color", 0x0000FF);
		addChild(view);

		var childView : ChildView = new ChildView();
		view.addChild(childView);
		
		childView.traceStyle();
		
		// in ChildView
		public function traceStyle() : void {
			trace (getStyle("color")); // 0x0000FF
		}
	 * </listing>
	 * 
	 * <strong>Setting a style</strong>
	 * 
	 * <p>A style can be set to any object without any restriction. If the object
	 * already is added to the display list, the entire child tree of that object will be
	 * traversed to notify children about a style change. Therefore, setting styles
	 * performs best before the object is added to the stage.</p>
	 * 
 	 * <listing>
		var view : MyView = new MyView();
		view.setStyle("color", 0x0000FF); // setting style before adding to the display list
		addChild(view);
	 * </listing>
	 * 
	 * <strong>Setting a default style</strong>
	 * 
	 * <p>Default styles are necessary to set up initial values the view
	 * can use, if not explicitly set at runtime.</p>
	 * 
	 * <strong>Style change notifications</strong>
	 * 
	 * <p>To receive notification about a particular style change, the object must
	 * declare this style as a default style. Otherwise no notification will be
	 * sent to this object. Setting a style to a view will traverse the
	 * entire view's child tree and notify any child view who defines
	 * the just set or changed style value.</p>
	 * 
	 * <listing>
		public function MyView() {
			_styleManager = new StyleManager(this);
			_styleManager.setDefaultStyles([
				"color", 0xFF0000
			]);
		}
		...
		public function styleManagerStyleChangeHandler(property : String, value : ~~) : void {
			if (property == "color") {
				trace ("color property has changed to " + value);
			}
		}
	 * </listing>
	 * 
	 * <strong>Contextual styles</strong>
	 * 
	 * <p>In certain circumstances we want to set different styles for child objects of the
	 * same type. E.g. a view contains two labels, and we want the first label appearing
	 * in red color and the second in blue. view.setStyle("color", "red") would also
	 * be applied to the second label. To address this issue, it is possible to pass a
	 * view selector to the setStyle method.</p>
	 * 
 	 * <listing>
		public function MyView() {
			var label1 : Label = new Label();
			label1.name = "Label1";
			addChild(label1);

			var label2 : Label = new Label();
			label2.name = "Label2";
			addChild(label2);
		}
		...
		
		// in Main
		var view : MyView = new MyView();
		view.setStyle("color", "red", ["Label1"]);
		view.setStyle("color", "blue", ["Label2"]);
		addChild(view);
	 * </listing>
	 * 
	 * <p>The view selector is an Array of either view names or types
	 * and is not restricted in size. The selector items within a selector are
	 * ordered from unspecific (left) to specific (right).</p>
	 * 
 	 * <listing>
		// all Button objects
		// or any child of a Button
		setStyle("color", "red", [Button]);

		// all views with the name "background"
		// or any child of such a view
		setStyle("color", "red", ["background"]);

		// all views with the name "background"
		// which are Button instances or child of a Button
		// of that name
		setStyle("color", "red", [Button, "background"]);

		// all views with the name "selected", which
		// is child of a view with the name "background",
		// or any child of such a view
		setStyle("color", "red", ["background", "selected"]);

		// all Rect objects, which are children of a Rect object
		// or any child of such a Rect
		setStyle("color", "red", [Rect, Rect]);
	 * </listing>
	 * 
	 * <strong>Excluding objects via contextual styles</strong>
	 * 
	 * <p>Vice versa, it is also possible to exclude objects from being affected
	 * by a global style rule, even if they define those style by default.
	 * E.g. a view contains two labels, and we want the first label appearing
	 * in red color and the second in blue. view.setStyle("color", "red") would also
	 * be applied to the second label. To address this issue, it is possible to pass a
	 * exclusion selector to the setStyle method.</p>
	 * 
 	 * <listing>
		public function MyView() {
			var label1 : Label = new Label();
			label1.name = "Label1";
			addChild(label1);

			var label2 : Label = new Label();
			label2.name = "Label2";
			addChild(label2);
		}
		...
		
		// in Main
		var view : MyView = new MyView();
		view.setStyle("color", "red", null, ["Label2"]);
		view.setStyle("color", "blue", null, ["Label1"]);
		addChild(view);
	 * </listing>
	 * 
	 * <p>The view selector is an Array of either view names or types
	 * and is not restricted in size. The selector items within a selector are
	 * ordered from unspecific (left) to specific (right).</p>
	 * 
 	 * <listing>
		// all views that are not Buttons
		// or a child of a Button
		setStyle("color", "red", null, [Button]);

		// all views whose name is not "background" or are
		// that are child of a view of that name
		setStyle("color", "red", null, ["background"]);
	 * </listing>
	 * 
	 * <strong>Style cache</strong>
	 * 
	 * <p>Styles returned will be cached to enhance the performance of the
	 * getStyle() operation.</p>
	 * 
	 * @author jes 17.08.2009
	 */
	public final class StyleManager {
		
		/**
		 * The style manager owner.
		 */
		private var _client : IStyleManagerClient;

		/**
		 * The directly assigned styles.
		 */
		private var _styles : Object;

		/**
		 * The client default styles.
		 */
		private var _defaultStyles : Object;

		/**
		 * A style cache.
		 */
		private var _styleCache : Object;

		/**
		 * The cached parent chain.
		 */
		private var _parentChain : Array;

		/**
		 * The cached selector chain matching results.
		 */
		private var _selectorMatchingResults : Dictionary = new Dictionary();

		/**
		 * StyleManager constructor.
		 * 
		 * @param client The client.
		 */
		public function StyleManager(client : IStyleManagerClient) {
			_client = client;
			
			_defaultStyles = new Object();
			_styles = new Object();
			_styleCache = new Object();
		}

		/**
		 * Returns a style value for a given style property.
		 * 
		 * <p>The order, how a style value is determined:</p>
		 * 
		 * <ul>
		 * <li>Directly assigned style.</li>
		 * <li>Style retrieved from the display ancestor.</li>
		 * <li>Default style that has been set.</li>
		 * <li><code>undefined</code>.</li>
		 * </ul>
		 * 
		 * @param property The style property.
		 * @return The style value for that property or undefined. 
		 */
		public function getStyle(property : String) : * {
			
			if (_defaultStyles[property] === undefined) {
				trace ("StyleManager: Tried to get the undefined style " + property + " for client " + _client);
				return undefined;
			}
			
			var value : * = _styleCache[property];

			if (value === undefined) value = getDirectlyAssignedStyle(property);
			
			if (value === undefined) value = findAncestorStyle(property);

			if (value === undefined) value = _defaultStyles[property];

			_styleCache[property] = value;
			
			return value;
		}
		
		/**
		 * Sets a list of default styles, which are referred to, if no
		 * actual style could be found for a property.
		 * 
		 * <p>You need to set a default value for each style property, if
		 * you want to get notifications about value changes for that
		 * property.</p>
		 * 
		 * <p>Setting default styles to a yet initialised client should
		 * not be possible and not offered by the clients implementation.</p>
		 * 
		 * <p>You pass an array to this method of this form: [prop1, value1,
		 * prop2, value2, ..., propN, valueN]. The array.length must be a
		 * factor of 2 then.</p>
		 * 
		 * @param defaultStyles An array of style declarations.
		 */
		public function setDefaultStyles(defaultStyles : Array) : void {
			for (var i : int = 0; i < defaultStyles.length; i += 2) {
				_defaultStyles[defaultStyles[i]] = defaultStyles[i + 1];
			}
		}

		/**
		 * Returns a list of all default style properties.
		 * 
		 * <p>Can be used for a complete style lookup. Returns
		 * only the properties not the values.</p> 
		 * 
		 * @return The default styles.
		 */
		public function getDefaultStyles() : Array {
			var definedStyles : Array = new Array();
			for (var property : String in _defaultStyles) {
				definedStyles.push(property);
			}
			definedStyles.sort();
			return definedStyles;
		}

		/**
		 * Sets a style to a client.
		 * 
		 * <p>It is possible to set a contextual style within a parent client.
		 * In this case the style value set affects only clients that match
		 * the given context.</p>
		 * 
		 * <p>It is also possible to set a contextual exclude style within a
		 * parent client. In this case the style value set does not affect
		 * clients that match the given context.</p>
		 * 
		 * @param property The name of the style.
		 * @param value The value of the style.
		 * @param selectorChain An array of selectors.
		 * @param excludeChain An array of exclude selectors.
		 */
		public function setStyle(property : String, value : *, selectorChain : Array = null, excludeChain : Array = null) : void {
			
			/*
			 * Terminology
			 * 
			 * styleSelectors - An array of selectors for the given property
			 * [styleSelector, styleSelector, styleSelector, ...]
			 * 
			 * styleSelector - A single style selector of the form:
			 * {"value" : value, "selectorChain" : selectorChain, "excludeChain" : excludeChain}
			 */

			/*
			 * Initialise default values.
			 */
			
			// no style set yet
			var styleSelectors : Array = _styles[property];

			if (!styleSelectors) {
				styleSelectors = new Array();
				_styles[property] = styleSelectors;
			}

			/*
			 * Check if an item should be updated or is about to be replaced
			 * with the same value (then return).
			 */

			var styleSelector : Object;
			var styleSelectorUpdatedAt : int = -1;
		
			for (var i : int = 0; i < styleSelectors.length; i++) {
				styleSelector = styleSelectors[i];
				if (arraysEqual(selectorChain, styleSelector["selectorChain"])) {

					// if the same value is already set for the style property
					// the item and all children defining that property already
					// have received that value and do not need to be notified again.
					if (value === styleSelector["value"]) return; // nothing updated
					
					// array of values
					if (value is Array && styleSelector["value"] is Array) {
						if (arraysEqual(value, styleSelector["value"])) {
							return; // nothing updated
						}
					}

					// reuse the original selectorChain reference to enable caching
					selectorChain = styleSelector["selectorChain"];
					
					styleSelectorUpdatedAt = i;
					break;
				}
			}
		
			if (styleSelectorUpdatedAt > -1) {
				styleSelectors.splice(styleSelectorUpdatedAt, 1)[0];
			}
			
			/*
			 * Add new selector item at and of the list.
			 */

			styleSelectors.push({
				selectorChain: selectorChain,
				excludeChain: excludeChain,
				value: value
			});

			/*
			 * Notify display list.
			 */

			notifyStyleChanged(_client, selectorChain, property, value);
		}
		
		/**
		 * Convenience method to set a number of styles values at once.
		 * 
		 * <p>You pass an array to this method of this form: [prop1, value1,
		 * prop2, value2, ..., propN, valueN]. The array.length must be a
		 * factor of 2 then.</p>
		 * 
		 * <p>It is possible to set a contextual style within a parent client.
		 * In this case the style value set affects only to clients that match
		 * with the given context.</p>
		 * 
		 * <p>It is also possible to set a contextual exclude style within a
		 * parent client. In this case the style value set does not affect
		 * clients that match the given context.</p>
		 * 
		 * @param styles An array of style declarations.
		 * @param selectorChain An array of selectors.
		 * @param excludeChain An array of exclude selectors.
		 */
		public function setStyles(styles : Array, selectorChain : Array = null, excludeChain : Array = null) : void {
			for (var i : int = 0; i < styles.length; i += 2) {
				setStyle(styles[i], styles[i + 1], selectorChain, excludeChain);
			}
		}

		/*
		 * Private
		 */

		/**
		 * Notifies the client and its children about a style change.
		 */
		private function notifyStyleChanged(client : IStyleManagerClient, selectorChain : Array, property : String, value : *) : void {
			
			if (!selectorChain) selectorChain = new Array();
			
			/*
			 * We notify the client, if all selectors of the given chain did match.
			 * In this case the chain will be empty. A client should be notified
			 * only, if it defines the given style property and if the style value
			 * did change compared to the last value retrieved (and stored in _styleCache).
			 */

			if (!selectorChain.length
				&& client.styleManager._defaultStyles[property] !== undefined
				&& client.styleManager._styleCache[property] !== value
			) {
				client.styleManager._styleCache[property] = value;
				client.styleManagerStyleChangeHandler(property, value);
			}
			
			if (!(client is DisplayObjectContainer)) return;
			
			/*
			 * Traverse the entire display hierarchy starting from the
			 * client the style is set to.
			 * 
			 * If a client matchs the first selector of the chain,
			 * its children will be checked with a copy of the chain
			 * where the first element has been removed.
			 * One by one the chain will be emptied this way.
			 */

			var numChildren : uint = DisplayObjectContainer(client).numChildren;
			if (client is IPopUpControl) numChildren++;
			
			var i : int = -1;
			var child : DisplayObject;
			while (++i < numChildren) {
				
				if (client is IPopUpControl && i == numChildren - 1) {
					child = IPopUpControl(client).popUp as DisplayObject;
				} else {
					child = DisplayObjectContainer(client).getChildAt(i);
				}
				
				// exclude arbitrary display objects
				if (!(child is IStyleManagerClient)) continue;

				var nextChain : Array = new Array();

				if (selectorChain.length) {

					/*
					 * The current child's type matchs the current selector.
					 * Advance selector and check children with a copy of the chain.
					 */
					if (selectorChain[0] is Class && child is selectorChain[0]) {
						nextChain = selectorChain.slice(1);

					/*
					 * The current child's name matchs the current selector.
					 * Advance selector and check children with a copy of the chain.
					 */
					} else if (selectorChain[0] is String && child.name == selectorChain[0]) {
						nextChain = selectorChain.slice(1);

					/*
					 * The current child does not match, check children with the
					 * same chain.
					 */
					} else {
						nextChain = selectorChain;
					}
				}
				
				notifyStyleChanged(IStyleManagerClient(child), nextChain, property, value);
			}
			
		}

		/**
		 * Returns a directly assigned style value, if any.
		 */
		private function getDirectlyAssignedStyle(property : String) : * {
			if (_styles[property] !== undefined) {
				return getFirstMatchingStyle(_styles[property], [_client]);
			}
		}
		
		/**
		 * Iterates through the parentChain from top to the bottom. The bottom
		 * is always the current client.
		 * 
		 * If a parent has set a value for the given property, its selectors
		 * will be checked, whether they match the clients instance.
		 * 
		 * The selectors are iterated in the reverse order they were defined.
		 * If the selector matchs, its value will be returned.
		 */
		private function findAncestorStyle(property : String) : * {
			var parentChain : Array = getStyleClientParentChain();

			var parentChainIndex : int = parentChain.length - 1; // top most ancestor
			var client : IStyleManagerClient;

			var styleSelectors : Array;
			var value : *;
			
			while (parentChainIndex >= 0) {
				client = parentChain[parentChainIndex];
					
				if (client.styleManager._styles[property] !== undefined) {
					styleSelectors = client.styleManager._styles[property];
					value = getFirstMatchingStyle(styleSelectors, parentChain);
					if (value !== undefined) return value;
				}
				parentChainIndex--;
				
			}
			return value;
		}
		
		/**
		 * Returns the value of the first style selector that matchs
		 * the clients parent chain. 
		 */
		private function getFirstMatchingStyle(styleSelectors : Array, parentChain : Array) : * {
			var selectorChain : Array;
			var excludeChain : Array;
			var styleSelectorIndex : int = styleSelectors.length - 1;
			
			while (styleSelectorIndex >= 0) {

				// Test, if the client should be excluded
				excludeChain = styleSelectors[styleSelectorIndex]["excludeChain"];
				if (excludeChain && selectorChainMatchs(excludeChain, parentChain)) {
					// style should not be applied by exclusion rule

				// Test, if the style can be applied
				} else {
					selectorChain = styleSelectors[styleSelectorIndex]["selectorChain"];
					if (selectorChain) {
						if (selectorChainMatchs(selectorChain, parentChain)) {
							return styleSelectors[styleSelectorIndex]["value"];
						} else {
							// selector does not match
						}
					} else {
						return styleSelectors[styleSelectorIndex]["value"];
					}

				}
				
				styleSelectorIndex--;
			}
						
			return undefined;
		}
			
		/**
		 * The selector stores its entries from ancestors to descendants.
		 * The parent chain in the reverse order from descendant to ancestors. 
		 * 
		 * Iterate the selector chain from the left to the right.
		 * For each selector entry: Forward the parent chain to the
		 * first element that matchs the selector entry. If no such
		 * element exists, the selector does not match.
		 * 
		 * The parent chain at least consists of the current client.
		 */
		private function selectorChainMatchs(selectorChain : Array, parentChain : Array = null) : Boolean {
			
			// If there is no selector chain, the client matchs anyway.
			if (!selectorChain.length) return true;
			
			var cacheResult : int = getCachedSelectorChainMatchingResult(selectorChain);
			if (cacheResult != -1) {
				return cacheResult ? true : false;
			}
			
			/*
			 * Test the last selector if it matchs with the _client.
			 * If it matchs, we remove the last selector and delegate
			 * the chain to the _clients parent.
			 */
			//var selectorChainToTest : Array = selectorChain.concat();


			if (selectorMatchs(selectorChain[selectorChain.length - 1])) {
				// there was only 1 selector in the chain and it did match.
				if (selectorChain.length == 1) {
					cacheSelectorChainMatchingResult(selectorChain, 1);
					return true;
				}
				selectorChain = selectorChain.slice(0, -2);
			}
			
			// selector chain not empty - test parent
			if (!parentChain) parentChain = getStyleClientParentChain();
			if (parentChain.length >= 2) { // first item is the current client
				var matches : Boolean = IStyleManagerClient(parentChain[1]).styleManager.selectorChainMatchs(selectorChain);
				cacheSelectorChainMatchingResult(selectorChain, matches ? 1 : 0);
				return matches;
			}
			
			// selector chain not empty but no parent
			cacheSelectorChainMatchingResult(selectorChain, 0);
			return false;
		}
			
		/**
		 * Tests if a selector matchs the current client.
		 */
		private function selectorMatchs(selector : *) : Boolean {
			/*
			 * If the selector item is a Class, check if the current
			 * chain item inherits from that class.
			 */
			if (selector is Class && _client is selector) {
				return true;

			/*
			 * If the selector item is a String, we test if the current chain item's
			 * name is part of that selector name. We do not match the name exactly
			 * since sub views may given a concatenation of the parents name
			 * and a particular sub view name.
			 * In this case the item matchs the selector, if its parent item matchs
			 * to the selector.
			 */
			} else if (selector is String && _client.name == selector) {
				return true;
			}

			return false;
		}
		
		/**
		 * Caches a selector matching result for a higher performance.
		 */
		private function cacheSelectorChainMatchingResult(selectorChain : Array, result : uint) : void {
			/*
			 * A cache entry is written only if no cache result could be
			 * returned by getSelectorChainMatchingResult. Its safe not to
			 * check for duplicates.
			 */

			_selectorMatchingResults[selectorChain] = result;
		}

		/**
		 * Returns the result of an already performed selector matching test.
		 */
		private function getCachedSelectorChainMatchingResult(selectorChain : Array) : int {
			// check if chain is already cached
			var cachedChain : Array;
			for (var key : * in _selectorMatchingResults) {
				cachedChain = key;
				if (arraysEqual(selectorChain, cachedChain)) {
					return _selectorMatchingResults[cachedChain];
				}
			}
			return -1;
		}

		/**
		 * The parent chain contains the current client as well as all
		 * IStyleManagerClient ancestors.
		 */
		private function getStyleClientParentChain() : Array {
			if (!_parentChain) {
				_parentChain = new Array();
				var displayObject : DisplayObject = _client as DisplayObject;
				
				while (displayObject) {
					if (displayObject is IStyleManagerClient) {
						_parentChain.push(displayObject);
					}
					
					if (displayObject is IPopUpControlPopUp) {
						displayObject = IPopUpControlPopUp(displayObject).popUpControl as DisplayObject;
					} else {
						displayObject = displayObject.parent;
					}
				}
			}

			return _parentChain;			
		}

		/**
		 * Helper function.
		 */
		private function arraysEqual(array1 : Array, array2 : Array) : Boolean {
			if (array1 == array2) return true; // both are null or strictly equal
			if (!array1 || !array2) return false; // one of both is null

			var i : Number = array1.length;
			if (i != array2.length) {
				return false;
			}
			while (i--) {
				if (array1[i] !== array2[i]) {
					return false;
				}
			}
			return true;
		}
		
	}
}
