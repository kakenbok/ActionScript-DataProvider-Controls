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
package com.sibirjak.asdpcbeta.window {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Cubic;
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpcbeta.tabbar.TabBar;
	import com.sibirjak.asdpcbeta.window.core.ITitleBar;
	import com.sibirjak.asdpcbeta.window.core.TitleBar;
	import com.sibirjak.asdpcbeta.window.core.WindowPosition;
	import com.sibirjak.asdpcbeta.window.skins.MinimiseIconSkin;
	import com.sibirjak.asdpcbeta.window.skins.WindowSkin;

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IMapIterator;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jes 25.11.2009
	 */
	public class Window extends View {

		/* style declarations */
		public static var style : WindowStyles = new WindowStyles();

		/* constants */
		public static const TWEEN_POSITION : uint = 1 << 0;
		public static const TWEEN_ALPHA : uint = 1 << 2;

		/* children */
		protected var _shadowSkin : WindowSkin;
		protected var _backgroundSkin : WindowSkin;
		protected var _titleBar : ITitleBar;
		protected var _tabBar : TabBar;
		
		/* properties */
		protected var _title : String = "";
		protected var _document : DisplayObject;
		protected var _documents : LinkedMap;
		protected var _tabNameToSelect : String;

		protected var _moveable : Boolean = true;

		protected var _minimiseOnClickOutside : Boolean;
		protected var _minimiseTriggerButton : DisplayObject;

		protected var _minimised : Boolean;
		protected var _minimisePosition : WindowPosition;
		protected var _restorePosition : WindowPosition;


		/* internal */
		protected var _diffPosition : Point;
		protected var _isMoving : Boolean = false;
		protected var _minimiseTween : GTween;
		
		/* assets */
		[Embed(source="skins/window.gif")]
		protected var _windowIconSkin : Class;

		
		public function Window() {
			
			// default size
			setDefaultSize(200, 240);
			
			setDefaultStyles([
				style.titleBar, true,
				style.titleBarSize, 22,
				
				style.padding, 2,

				style.shadow, true,
				style.titleBarAlphaMoving, .7,

				style.windowIcon, true,
				style.windowIconSkin, _windowIconSkin,

				style.minimiseButton, true,
				style.minimiseIconSkin, MinimiseIconSkin,
				style.minimiseOnDoubleClick, true,
				
				style.minimiseDuration, .2,
				style.restoreDuration, .2,
				
				style.minimiseTweenProperties, TWEEN_ALPHA + TWEEN_POSITION,
				style.restoreTweenProperties, TWEEN_ALPHA + TWEEN_POSITION
				
			]);
			
			_documents = new LinkedMap();

			_minimiseTween = new GTween(this);
			_minimiseTween.ease = Cubic.easeInOut;
			_minimiseTween.paused = true;
		}
		
		/*
		 * IWindow
		 */

		public function set title(title : String) : void {
			_title = title;
		}

		public function get title() : String {
			return _title ? _title : "";
		}
		
		public function set document(document : DisplayObject) : void {
			_document = document;
		}

		public function get document() : DisplayObject {
			return _document;
		}

		public function set documents(documents : Array) : void {
			for (var i : int = 0; i < documents.length; i += 2) {
				_documents.add(documents[i], documents[i + 1]);
			}
		}

		public function get documents() : Array {
			return _documents.toArray();
		}
		
		public function set selectedTabName(name : String) : void {
			if (!_initialised) {
				_tabNameToSelect = name;
				return;
			}
			
			_tabBar.selectedTabName = name;
		}
		
		public function set moveable(moveable : Boolean) : void {
			_moveable = moveable;
		}
		
		public function set minimised(minimised : Boolean) : void {
			if (_initialised) return;
			
			_minimised = minimised;
		}

		public function get minimised() : Boolean {
			return _minimised;
		}
		
		public function set minimiseOnClickOutside(minimiseOnClickOutside : Boolean) : void {
			_minimiseOnClickOutside = minimiseOnClickOutside;  
		}
		
		public function set minimiseTriggerButton(minimiseTriggerButton : DisplayObject) : void {
			_minimiseTriggerButton = minimiseTriggerButton;
		}

		public function set minimisePosition(minimisePosition : WindowPosition) : void {
			_minimisePosition = minimisePosition;
		}

		public function get minimisePosition() : WindowPosition {
			return _minimisePosition;
		}

		public function minimise() : void {
			
			if (!_initialised) return;
			
			mouseChildren = false;
			
			if (_minimiseOnClickOutside) {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, stageMouseDownHandler);
			}
			
			/*
			 * Tween
			 */

			var endPosition : Point = _minimisePosition.point;

			_minimiseTween.duration = getStyle(style.minimiseDuration);

			_minimiseTween.resetValues();

			if (shouldTween(TWEEN_ALPHA)) _minimiseTween.setValue("alpha", 0);
			if (shouldTween(TWEEN_POSITION)) {
				_minimiseTween.setValue("x", endPosition.x);
				_minimiseTween.setValue("y", endPosition.y);
				_minimiseTween.setValue("scaleX", 0);
				_minimiseTween.setValue("scaleY", 0);

				// accelerate minimising
				// <= 100 -> 1, 500 -> 1/2, 900 -> 1/3
				var distAbs : Number = Point.distance(new Point(x, y), endPosition);
				if (distAbs > 100) {
					_minimiseTween.timeScale = 400 / ((distAbs - 100) + 400);
				} else {
					_minimiseTween.timeScale = 1;
				}
			}
			
			_minimiseTween.onComplete = function(tween:GTween) : void {
				_minimised = true;
				scaleX = scaleY = 1; // reset scale to enable embedded font operations in the window
				visible = false;
				
				onMinimise();
				
				dispatchEvent(new WindowEvent(WindowEvent.MINIMISED));
			};
			
			dispatchEvent(new WindowEvent(WindowEvent.MINIMISE_START));
		}
		
		private function shouldTween(property : uint, minimiseTween : Boolean = true) : Boolean {
			if (minimiseTween) return (getStyle(style.minimiseTweenProperties) & property) == property;
			return (getStyle(style.restoreTweenProperties) & property) == property;
		}
		
		public function set restorePosition(restorePosition : WindowPosition) : void {
			_restorePosition = restorePosition;
		}

		public function get restorePosition() : WindowPosition {
			return _restorePosition;
		}

		public function restore(tween : Boolean = true, position : WindowPosition = null) : void {
			
			if (!_initialised) return;
			
			var endPosition : Point = position ? position.point : _restorePosition.point;
			visible = true;

			if (!tween) {
				x = endPosition.x;
				y = endPosition.y;
				alpha = scaleX = scaleY = 1;

				dispatchEvent(new WindowEvent(WindowEvent.RESTORE_START));
				dispatchEvent(new WindowEvent(WindowEvent.RESTORED));
				return;
			}
			
			// move window to the minimised position since
			// the minimise position may have changed in the meantime
			// _window.minismised can be only true if no
			// tween is running. if a tween is running, we
			// simply want the client to change its direction
			// to the new target.

			if (_minimised) {
				var startPosition : Point;
				
				if (shouldTween(TWEEN_ALPHA, false)) alpha = 0;
				if (shouldTween(TWEEN_POSITION, false)) {
					startPosition = _minimisePosition.point;
					scaleX = 0;
					scaleY = 0;
				} else {
					startPosition = endPosition;
				}

				x = startPosition.x;
				y = startPosition.y;
			}

			_minimised = false;

			mouseChildren = false;

			/*
			 * Tween
			 */

			_minimiseTween.duration = getStyle(style.restoreDuration);

			_minimiseTween.resetValues();
			_minimiseTween.setValue("x", endPosition.x);
			_minimiseTween.setValue("y", endPosition.y);
			_minimiseTween.setValue("alpha", 1);
			_minimiseTween.setValue("scaleX", 1);
			_minimiseTween.setValue("scaleY", 1);
			
			_minimiseTween.timeScale = 1;

			_minimiseTween.onComplete = function(tween : GTween) : void {
				if (_minimiseOnClickOutside) {
					stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
					stage.addEventListener(MouseEvent.MOUSE_WHEEL, stageMouseDownHandler);
				}

				mouseChildren = true;
				
				onRestore();
				
				dispatchEvent(new WindowEvent(WindowEvent.RESTORED));
			};

			dispatchEvent(new WindowEvent(WindowEvent.RESTORE_START));
		}

		public function startMoving() : void {
			if (!_moveable) return;

			if (_titleBar) _titleBar.alpha = getStyle(style.titleBarAlphaMoving);
			if (_shadowSkin) _shadowSkin.visible = false;

			mouseChildren = false;

			_diffPosition = new Point(stage.mouseX - x, stage.mouseY - y);
			
			_isMoving = true;

			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			windowStartsMoving();
			
			dispatchEvent(new WindowEvent(WindowEvent.START_DRAG));
		}

		/*
		 * View life cycle
		 */
		
		override protected function init() : void {
			
			if (!_restorePosition) {
				_restorePosition = new WindowPosition(x, y);
			}
			
			if (!_minimisePosition) {
				_minimisePosition = new WindowPosition(x + _width / 2, y + _height / 2);
			}
			
			if (!_minimised && _minimiseOnClickOutside) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, stageMouseDownHandler);
			}
			
		}
		
		override protected function draw() : void {
			if (getStyle(style.shadow)) {
				_shadowSkin = new WindowSkin();
				DisplayObjectAdapter.setSize(_shadowSkin, _width, _height);
				_shadowSkin.setStyles([
					WindowSkin.style_border, false,
					WindowSkin.style_backgroundLightColor, 0x000000,
					WindowSkin.style_backgroundDarkColor, 0x000000
				]);
				_shadowSkin.alpha = .05;
				_shadowSkin.moveTo(6, 6);
				_shadowSkin.mouseEnabled = false;
				_shadowSkin.mouseChildren = false;
				addChild(DisplayObject(_shadowSkin));
			}
			
			_backgroundSkin = new WindowSkin();
			DisplayObjectAdapter.setSize(_backgroundSkin, _width, _height);
			addChild(DisplayObject(_backgroundSkin));
			
			/*
			 * TitleBar
			 */
			
			var documentY : uint = 1; // top border if no title bar

			if (getStyle(style.titleBar)) {
				_titleBar = new (getTitleBarClass())();
				var titleBarDimensions : Rectangle = getTitleBarDimensions();
				_titleBar.setSize(titleBarDimensions.width, titleBarDimensions.height);
				_titleBar.window = this;
				addChild(DisplayObject(_titleBar));
				
				documentY = titleBarDimensions.height;
			}
			
			/*
			 * Documents
			 */
			
			var padding : uint = getStyle(style.padding);

			if (_documents.size) {
				_tabBar = new TabBar();
				_tabBar.setSize(_width - 2, 22);
				_tabBar.tabs = _documents.keysToArray();
				_tabBar.bindProperty(TabBar.BINDABLE_PROPERTY_SELECTED_TAB_NAME, tabBarSetSelectedTabName);
				_tabBar.moveTo(1, documentY);
				if (_tabNameToSelect) _tabBar.selectedTabName = _tabNameToSelect;
				addChild(_tabBar);
				
				var iterator : IMapIterator = _documents.iterator() as IMapIterator;
				var document : DisplayObject;
				var tabName : String;
				while (iterator.hasNext()) {
					document = iterator.next();
					tabName = iterator.key;
					
					if (document) {
						DisplayObjectAdapter.setSize(
							document,
							_width - 2 * (padding + 1),
							height - documentY - _tabBar.height - 1 - 2 * padding
						);
						DisplayObjectAdapter.moveTo(
							document,
							padding + 1,
							documentY + _tabBar.height + padding
						);
						document.visible = tabName == _tabBar.selectedTabName;
						addChild(document);
					}
				}
				
			} else if (_document) {
				DisplayObjectAdapter.setSize(
					_document,
					_width - 2 * (padding + 1),
					height - documentY - 1 - 2 * padding
				);
				DisplayObjectAdapter.moveTo(
					_document,
					padding + 1,
					documentY + padding
				);
				addChild(_document);
			}
			
			/*
			 * Set minimised here and not in init
			 */

			if (_minimised) {
				
				var position : Point;
				
				// nullify all properties that should be tweened with the restore tween
				if (shouldTween(TWEEN_ALPHA, false)) alpha = 0;
				if (shouldTween(TWEEN_POSITION, false)) {
					position = _minimisePosition.point;
					scaleX = scaleY = 0;
				} else {
					position = _restorePosition.point;
				}

				x = position.x;
				y = position.y;
			}

		}
		
		override protected function update() : void {
			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				if (_shadowSkin) DisplayObjectAdapter.setSize(_shadowSkin, _width, _height);
				DisplayObjectAdapter.setSize(_backgroundSkin, _width, _height);

				var documentY : uint = 1; // top border if no title bar

				if (_titleBar) {
					var titleBarDimensions : Rectangle = getTitleBarDimensions();
					_titleBar.setSize(titleBarDimensions.width, titleBarDimensions.height);

					documentY = titleBarDimensions.height;
				}

				if (_document) {
					var padding : uint = getStyle(style.padding);

					DisplayObjectAdapter.setSize(
						_document,
						_width - 2 * (padding + 1),
						height - documentY - 1 - 2 * padding
					);

				}
			}

			if (_shadowSkin) DisplayObjectAdapter.validateNow(_backgroundSkin);
			DisplayObjectAdapter.validateNow(_backgroundSkin);
			if (_titleBar) _titleBar.validateNow();

		}

		override protected function cleanUpCalled() : void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, stageMouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}

		/*
		 * Protected
		 */

		protected function getTitleBarClass() : Class {
			return TitleBar;
		}
			
		protected function getTitleBarDimensions() : Rectangle {
			return new Rectangle(0, 0, _width, getStyle(style.titleBarSize));
		}

		protected function windowStartsMoving() : void {
		}

		protected function windowMoves() : void {
		}

		protected function windowStopsMoving() : void {
		}

		protected function onRestore() : void {
		}

		protected function onMinimise() : void {
		}

		/*
		 * Events
		 */

		private function stageMouseDownHandler(event : MouseEvent) : void {
			if (hitTestPoint(stage.mouseX, stage.mouseY)) {
				return;
			}
			if (_minimiseTriggerButton && _minimiseTriggerButton.hitTestPoint(stage.mouseX, stage.mouseY)) {
				return;
			}

			minimise();

			dispatchEvent(new WindowEvent(WindowEvent.AUTO_MINIMISE_START));
		}

		private function mouseMoveHandler(event : MouseEvent) : void {
			x = Math.round(stage.mouseX - _diffPosition.x);
			y = Math.round(stage.mouseY - _diffPosition.y);
			
			windowMoves();
			
			event.updateAfterEvent(); // update display soon
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			_isMoving = false;

			if (_titleBar) _titleBar.alpha = 1;
			if (_shadowSkin) _shadowSkin.visible = true;

			mouseChildren = true;

			windowStopsMoving();

			var stopEvent : WindowEvent = new WindowEvent(WindowEvent.STOP_DRAG);
			stopEvent.restorePosition = new WindowPosition(Math.round(x), Math.round(y));

			dispatchEvent(stopEvent);
			
			// a listener is able to prevent the set of the new position as the
			// restore position. this can be useful e.g. if a window is dragged
			// into a recycler and should be restored to the last committed position
			// rather than the position of the recycling bin.
			if (stopEvent.restorePosition) _restorePosition = stopEvent.restorePosition;
		}
		
		private function tabBarSetSelectedTabName(name : String) : void {
			var iterator : IMapIterator = _documents.iterator() as IMapIterator;
			var document : DisplayObject;
			var tabName : String;
			while (iterator.hasNext()) {
				document = iterator.next();
				if (document) {
					tabName = iterator.key;
					document.visible = tabName == name;
				}
			}
		}

	}
}
