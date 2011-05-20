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
package com.sibirjak.asdpcbeta.layout {
	import com.sibirjak.asdpc.core.View;

	import org.as3commons.collections.Set;

	import flash.display.DisplayObject;

	/**
	 * @author jes 02.12.2009
	 */
	public class AbstractLayout extends View {
		
		/* style declarations */
		public static var style : LayoutStyles = new LayoutStyles();

		/* changeable properties or styles */
		private const UPDATE_PROPERTY_CHILD_LIST : String = "child_list";
		private const UPDATE_PROPERTY_LAYOUT : String = "layout";

		/* internal */
		protected var _childrenToAdd : Array;
		protected var _excludeList : Set;
		
		public function AbstractLayout() {
			
			setDefaultStyles([
				style.itemPadding, 0
			]);
			
			_childrenToAdd = new Array();
			_excludeList = new Set();
		}
		
		public function excludeFromLayout(child : DisplayObject, hide : Boolean = true) : void {
			_excludeList.add(child);
			if (hide) child.visible = false;
			invalidateProperty(UPDATE_PROPERTY_LAYOUT);
		}
			
		public function includeInLayout(child : DisplayObject, show : Boolean = true) : void {
			_excludeList.remove(child);
			if (show) child.visible = true;
			invalidateProperty(UPDATE_PROPERTY_LAYOUT);
		}
		
		public function childSizeChanged() : void {
			invalidateProperty(UPDATE_PROPERTY_LAYOUT);
			validateNow();
		}
		
		/*
		 * DisplayObjectContainer
		 */

		override public function addChild(child : DisplayObject) : DisplayObject {
			
			if (!_initialised) {
				_childrenToAdd.push(child);
				return null;
			}
			
			super.addChild(child);
			
			invalidateProperty(UPDATE_PROPERTY_CHILD_LIST);
			
			return child;
		}

		override public function removeChild(child : DisplayObject) : DisplayObject {
			super.removeChild(child);
			
			invalidateProperty(UPDATE_PROPERTY_CHILD_LIST);

			return child;
		}

		/*
		 * View life cycle
		 */

		override protected function init() : void {
			addChildren();
		}

		override protected function draw() : void {
			layoutChildren();
		}
		
		override protected function update() : void {
			if (isInvalid(UPDATE_PROPERTY_SIZE)
				|| isInvalid(UPDATE_PROPERTY_CHILD_LIST)
				|| isInvalid(UPDATE_PROPERTY_LAYOUT)) {
				layoutChildren();
				
				if (parent && parent is AbstractLayout) {
					AbstractLayout(parent).childSizeChanged();
				}
			}
		}

		override protected function styleChanged(property : String, value : *) : void {
			invalidateProperty(UPDATE_PROPERTY_LAYOUT);
		}

		/*
		 * Protected
		 */

		protected function layoutChildren() : void {
		}
		
		protected function addChildren() : void {
			while (_childrenToAdd.length) {
				super.addChild(_childrenToAdd.shift());
			}
		}
	}
}
