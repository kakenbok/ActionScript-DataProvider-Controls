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
package com.sibirjak.asdpc.treeview.renderer {
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.View;

	import flash.display.DisplayObject;

	/**
	 * Connector.
	 * 
	 * @author jes 06.08.2009
	 */
	public class Connector extends View {

		/* constants */
		
		/**
		 * Name constant defining a top connection.
		 */
		public static const TOP : uint = 1 << 0;

		/**
		 * Name constant defining a right connection.
		 */
		public static const RIGHT : uint = 1 << 1;

		/**
		 * Name constant defining a bottom connection.
		 */
		public static const BOTTOM : uint = 1 << 2;

		/**
		 * Name constant defining a left connection.
		 */
		public static const LEFT : uint = 1 << 3;

		/**
		 * Name constant defining the top connection name.
		 */
		public static const TOP_NAME : String = "top";

		/**
		 * Name constant defining the right connection name.
		 */
		public static const RIGHT_NAME : String = "right";

		/**
		 * Name constant defining the bottom connection name.
		 */
		public static const BOTTOM_NAME : String = "bottom";

		/**
		 * Name constant defining the left connection name.
		 */
		public static const LEFT_NAME : String = "left";
		
		/* changeable properties or styles */

		/**
		 * Name constant for the extended height invalidation property.
		 */
		private const UPDATE_PROPERTY_EXTENDED_HEIGHT : String = "extended_height";

		/* properties */
		
		/**
		 * The bottom position of the bottom connection.
		 */
		private var _extendedHeight : uint;

		/**
		 * The y position of the bottom connection.
		 */
		private var _bottomY : uint;

		/* internal */
		
		/**
		 * The connections.
		 */
		private var _connections : Array;

		/**
		 * The visible connections binary sum.
		 */
		private var _visibleConnections : uint;

		/**
		 * The connector skin.
		 */
		private var _skinClass : Class;

		/**
		 * Connector constructor.
		 */
		public function Connector() {
		}

		/**
		 * If this value is set, the bottom connector should reach
		 * the _height + extendedHeight position. 
		 */
		public function set extendedHeight(height : uint) : void {
			if (height == _extendedHeight) return;
			
			_extendedHeight = height;
			invalidateProperty(UPDATE_PROPERTY_EXTENDED_HEIGHT);
		}

		/**
		 * If this value is set, the bottom connector should start
		 * at the specified position. 
		 */
		public function set bottomY(bottomY : uint) : void {
			if (bottomY == _bottomY) return;

			_bottomY = bottomY;
			invalidateProperty(UPDATE_PROPERTY_EXTENDED_HEIGHT);
		}

		/**
		 * Updates the connections visibility.
		 * 
		 * @param visibleConnections A binary sum of all visible connections.
		 */
		public function show(visibleConnections : uint) : void {
			_visibleConnections = visibleConnections;
			
			if (_initialised) showConnections();
		}
		
		/**
		 * Sets a connection skin.
		 */
		public function set skinClass(skinClass : Class) : void {
			_skinClass = skinClass;
		}
		
		/*
		 * View life cycle.
		 */

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			createConnections();
			showConnections();
		}

		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			
			var resizeAll : Boolean = false;
			var resizeBottom : Boolean = false;
			
			if (isInvalid(UPDATE_PROPERTY_EXTENDED_HEIGHT)) {
				IConnectorSkin(_connections[2]).extendedHeight = _extendedHeight;
				IConnectorSkin(_connections[2]).bottomY = _bottomY;
				
				resizeBottom = true;
			}
			
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				resizeAll = true;
			}
			
			if (resizeAll) {
				setConnectionSize();
				
			} else if (resizeBottom) {
				DisplayObjectAdapter.validateNow(_connections[2]); // be consistent with a possible reposition
			}
			
		}
		
		/*
		 * Private
		 */

		/**
		 * Creates all connections.
		 */
		private function createConnections() : void {
			_connections = new Array();
			var connectionNames : Array = [TOP_NAME, RIGHT_NAME, BOTTOM_NAME, LEFT_NAME];
			var connection : IConnectorSkin;
			for each (var connectionName : String in connectionNames) {
				connection = new _skinClass();
				connection.name = connectionName;

				DisplayObjectAdapter.setSize(DisplayObject(connection), _width, _height);

				if (connectionName == BOTTOM_NAME) {
					connection.extendedHeight = _extendedHeight;
					connection.bottomY = _bottomY;
				}

				DisplayObjectAdapter.addChild(DisplayObject(connection), this);

				_connections.push(connection);
			}
		}

		/**
		 * Resizes all connections.
		 */
		private function setConnectionSize() : void {
			for each (var connection : DisplayObject in _connections) {
				DisplayObjectAdapter.setSize(connection, _width, _height);
				DisplayObjectAdapter.validateNow(connection); // be consistent with a possible reposition
			}
		}

		/**
		 * Shows all connections depending on the _visibleConnections value.
		 */
		private function showConnections() : void {
			for (var i : uint = 0; i < _connections.length; i++) {
				DisplayObject(_connections[i]).visible = (_visibleConnections & 1 << i) == 1 << i;
			}
		}

	}
}
