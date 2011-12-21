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
package com.sibirjak.asdpcbeta.slider {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.core.BindableView;
	import com.sibirjak.asdpc.core.constants.Direction;
	import com.sibirjak.asdpc.core.skins.GlassFrame;
	import com.sibirjak.asdpcbeta.slider.core.SliderThumb;
	import com.sibirjak.asdpcbeta.slider.skins.SliderThumbSkin;
	import com.sibirjak.asdpcbeta.slider.skins.SliderTrackSkin;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author jes 01.12.2009
	 */
	public class Slider extends BindableView {

		/* style declarations */
		public static var style : SliderStyles = new SliderStyles();

		/* constants */
		public static const BINDABLE_PROPERTY_VALUE : String = "value";
		
		public static const TRACK_NAME : String = "sliderTrack";
		public static const THUMB_NAME : String = "sliderThumb";

		public static const VIEW_PROPERTY_SLIDER_DIRECTION : String = "sliderDirection";

		/* properties */
		private var _direction : String = Direction.HORIZONTAL;
		private var _value : Number;

		private var _minValue : Number = 0;
		private var _maxValue : Number = 0;

		private var _enabled : Boolean = true;
		private var _liveDragging : Boolean = true;
		private var _snapInterval : uint = 1;
		private var _mouseWheelDelta : uint = 3;
		
		/* changeable properties or styles */
		private const UPDATE_PROPERTY_ACTIVATION : String = "activation";
		private const UPDATE_PROPERTY_VALUE : String = "value";

		/* cached style values */
		private var _thumbSize : uint;
		private var _thumbPadding : uint;
		private var _trackSize : uint;

		/* children */
		private var _track : IButton;
		private var _clickArea : GlassFrame;
		private var _thumb : SliderThumb;

		public function Slider() {
			
			setDefaultSize(100, 16); // horizontal default size

			setBindableProperties([BINDABLE_PROPERTY_VALUE]);
			
			setDefaultStyles([
				style.thumbSize, 9,
				style.thumbPadding, 0,
				style.trackSize, 3,
			]);
			
		}

		/*
		 * ISlider
		 */

		public function set direction(direction : String) : void {
			if (_initialised) return;
			
			_direction = direction;

			// default size
			if (_direction == Direction.VERTICAL) setDefaultSize(16, 100);
			else setDefaultSize(100, 16);

		}
		
		public function get direction() : String {
			return _direction;
		}
		
		public function set minValue(minValue : Number) : void {
			if (minValue == _minValue) return;

			_minValue = minValue;

			if (_value < _minValue) {
				_value = snapValue(_value);
				invalidateProperty(UPDATE_PROPERTY_ACTIVATION);
				updateBindingsForProperty(BINDABLE_PROPERTY_VALUE);
			}

			invalidateProperty(UPDATE_PROPERTY_VALUE);
		}
		
		public function get minValue() : Number {
			return _minValue;
		}
		
		public function set value(value : Number) : void {
			if (value == _value) return;

			_value = value;
			
			invalidateProperty(UPDATE_PROPERTY_VALUE);

			updateBindingsForProperty(BINDABLE_PROPERTY_VALUE);
		}
		
		public function get value() : Number {
			return _value;
		}
		
		public function set maxValue(maxValue : Number) : void {
			if (maxValue == _maxValue) return;

			_maxValue = maxValue;
			
			if (_value > _maxValue) {
				_value = snapValue(_value);
				invalidateProperty(UPDATE_PROPERTY_ACTIVATION);
				updateBindingsForProperty(BINDABLE_PROPERTY_VALUE);
			}

			invalidateProperty(UPDATE_PROPERTY_VALUE);

		}

		public function get maxValue() : Number {
			return _maxValue;
		}
		
		public function set enabled(enabled : Boolean) : void {
			_enabled = enabled;
			
			invalidateProperty(UPDATE_PROPERTY_ACTIVATION);
		}

		public function get enabled() : Boolean {
			return _enabled;
		}
		
		public function set liveDragging(liveDragging : Boolean) : void {
			_liveDragging = liveDragging;
		}

		public function get liveDragging() : Boolean {
			return _liveDragging;
		}
		
		public function set snapInterval(snapInterval : uint) : void {
			_snapInterval = snapInterval;
		}

		public function get snapInterval() : uint {
			return _snapInterval;
		}
		
		public function set mouseWheelDelta(mouseWheelDelta : uint) : void {
			_mouseWheelDelta = mouseWheelDelta;
		}
		
		public function get mouseWheelDelta() : uint {
			return _mouseWheelDelta;
		}

		/*
		 * View life cycle
		 */

		override protected function init() : void {
			setViewProperty(VIEW_PROPERTY_SLIDER_DIRECTION, _direction);

			if (isNaN(_value)) _value = _minValue;
			
			_thumbSize = getStyle(style.thumbSize);
			_thumbPadding = getStyle(style.thumbPadding);
			_trackSize = getStyle(style.trackSize);

			addEventListener(MouseEvent.MOUSE_WHEEL, mouseScrollHandler);
		}

		override protected function draw() : void {

			// track

			_track = new Button();
			_track.name = TRACK_NAME; // set name to enable selective styling
			
			_track.setDefaultStyles([
				Button.style.upSkin, SliderTrackSkin,
				Button.style.overSkinName, Button.UP_SKIN_NAME, // use up skin
				Button.style.downSkinName, Button.UP_SKIN_NAME, // use up skin
				Button.style.disabledSkin, SliderTrackSkin
			]);

			_track.enabled = sliderEnabled;
			_track.autoRepeat = true;
			_track.setSize(trackWidth, trackHeight);
			_track.moveTo(trackX, trackY);

			addChildAt(DisplayObject(_track), 0);
			
			// click area
			
			_clickArea = new GlassFrame();
			_clickArea.setSize(_width, _height);
			_clickArea.addEventListener(MouseEvent.MOUSE_DOWN, clickAreaMouseDownHandler);
			addChild(_clickArea);

			// thumb

			_thumb = new SliderThumb();
			_thumb.name = THUMB_NAME; // set name to enable selective styling
			
			_thumb.setDefaultStyles([
				Button.style.upSkin, SliderThumbSkin,
				Button.style.overSkin, SliderThumbSkin,
				Button.style.downSkinName, Button.OVER_SKIN_NAME,
				Button.style.disabledSkin, SliderThumbSkin
			]);

			_thumb.enabled = sliderEnabled;
			_thumb.setSize(thumbWidth, thumbHeight);
			_thumb.boundaryRect = thumbBoundaryRect;
			_thumb.position = valueToThumbPosition(_value);

			_thumb.addEventListener(SliderThumb.EVENT_THUMB_RELEASED, thumbReleasedHandler);
			_thumb.addEventListener(SliderThumb.EVENT_THUMB_MOVE, thumbMoveHandler);
			addChild(DisplayObject(_thumb));

		}

		override protected function initialised() : void {
			updateAllBindings();
		}

		override protected function update() : void {
			
			var setPosition : Boolean = false;
			
			if (isInvalid(UPDATE_PROPERTY_VALUE)) {
				setPosition = true;
			}
			
			if (isInvalid(UPDATE_PROPERTY_ACTIVATION)) {
				setPosition = true;

				_thumb.enabled = sliderEnabled;
				_track.enabled = sliderEnabled;
			}
			
			if (setPosition) {
				_thumb.position = valueToThumbPosition(_value);
			}

		}

		override protected function cleanUpCalled() : void {
			super.cleanUpCalled();

			removeEventListener(MouseEvent.MOUSE_WHEEL, mouseScrollHandler);

			_clickArea.removeEventListener(MouseEvent.MOUSE_DOWN, clickAreaMouseDownHandler);

			_thumb.removeEventListener(SliderThumb.EVENT_THUMB_RELEASED, thumbReleasedHandler);
			_thumb.removeEventListener(SliderThumb.EVENT_THUMB_MOVE, thumbMoveHandler);
		}

		/*
		 * Events
		 */

		private function mouseScrollHandler(event : MouseEvent) : void {
			if (!sliderEnabled) return;
			
			var eventDelta : int = event.delta / Math.abs(event.delta);

			var value : Number = snapValue(_value - (eventDelta * _mouseWheelDelta) * _snapInterval);

			// always snap thumb position
			_thumb.position = valueToThumbPosition(value);

			if (value == _value) return;

			_value = value;

			dispatchChange();
			dispatchEvent(new SliderEvent(SliderEvent.RELEASE, _value));
		}

		private function thumbMoveHandler(event : Event) : void {
			var value : Number = thumbPositionToValue();
			
			// always snap thumb position
			_thumb.position = valueToThumbPosition(value);

			if (value == _value) return;

			_value = value;
			
			if (_liveDragging) {
				dispatchChange();
			}
		}
		
		private function thumbReleasedHandler(event : Event) : void {
			if (!_liveDragging) {
				dispatchChange();
			}
			dispatchEvent(new SliderEvent(SliderEvent.RELEASE, _value));
		}

		private function snapValue(value : Number) : Number {
			
			// max snap value would be 9.3 for min:7 max:100 and interval:10
			// we never get the thumb to 100 this way
			if (value == _maxValue) return maxValue;

			var snapCount : Number = (value - _minValue) / _snapInterval;
			snapCount = Math.max(0, snapCount);
			
			// .3 => 0 snaps, .6 => 1 snap
			if (snapCount - Math.floor(snapCount) >= .5) {
				snapCount = Math.floor(snapCount) + 1;
			} else {
				snapCount = Math.floor(snapCount);
			}
			
			var snappedValue : Number = _minValue + snapCount * _snapInterval;

			// may become greater than max => snapCount 9.6 => 10
			return Math.min(snappedValue, _maxValue);

		}
		
		private function clickAreaMouseDownHandler(event : Event) : void {
			if (!_enabled) return;
			
			var ratio : Number;
			var size : uint = sliderSize - _thumbSize - 2 * _thumbPadding; 

			if (isHorizontal) {
				ratio = (mouseX - _thumbSize / 2 - _thumbPadding) / size;
			} else {
				ratio = (mouseY - _thumbSize / 2 - _thumbPadding) / size;
			}
			
			var value : Number = snapValue(_minValue + (_maxValue - _minValue) * ratio);
			_thumb.tweenToPosition(valueToThumbPosition(value));
		}
		
		private function dispatchChange() : void {
			updateBindingsForProperty(BINDABLE_PROPERTY_VALUE);
			dispatchEvent(new SliderEvent(SliderEvent.CHANGE, _value));
		}
		
		/*
		 * Private
		 */

		private function get sliderEnabled() : Boolean {
			return _enabled && _minValue <= _maxValue;
		}

		private function get isHorizontal() : Boolean {
			return _direction == Direction.HORIZONTAL;
		}

		/*
		 * Thumb position
		 */
		
		private function valueToThumbPosition(value : Number) : Point {
			var position : Point = new Point();
			var ratio : Number = (value - _minValue) / (_maxValue - _minValue);
			var rect : Rectangle = _thumb.boundaryRect;
			
			if (sliderEnabled && _minValue != _maxValue) {
				if (isHorizontal) {
					position.x = Math.round(rect.x + (rect.width - rect.x) * ratio);
				} else {
					position.y = Math.round(rect.y + (rect.height - rect.y) * ratio);
				}
			} else {
				if (isHorizontal) {
					position.x = Math.round((_width - thumbWidth) / 2);
				} else {
					position.y = Math.round((_height - thumbHeight) / 2);
				}
			}
			
			return position;
		}

		private function thumbPositionToValue() : Number {
			var ratio : Number;
			var rect : Rectangle = _thumb.boundaryRect;

			if (isHorizontal) {
				ratio = (_thumb.x - rect.x) / (rect.width - rect.x);
			} else {
				ratio = (_thumb.y - rect.y) / (rect.height - rect.y);
			}
			
			return snapValue(_minValue + (_maxValue - _minValue) * ratio);
		}

		/*
		 * State distinction
		 */
		
		/* slider */
		
		private function get sliderSize() : uint {
			return isHorizontal ? _width : _height;
		}

		/* track */
		
		private function get trackWidth() : uint {
			return isHorizontal ? _width : _trackSize;
		}

		private function get trackHeight() : uint {
			return isHorizontal ? _trackSize : _height;
		}

		private function get trackX() : uint {
			return isHorizontal ? 0 : Math.round((_width - _trackSize) / 2);
		}

		private function get trackY() : uint {
			return isHorizontal ? Math.round((_height - _trackSize) / 2) : 0;
		}

		/* thumb */
		
		private function get thumbWidth() : uint {
			var thumbWidth : uint = isHorizontal ? _thumbSize : _width;
			return thumbWidth % 2 ? thumbWidth : thumbWidth + 1;
		}

		private function get thumbHeight() : uint {
			var thumbHeight : uint = isHorizontal ? _height : _thumbSize;
			return thumbHeight % 2 ? thumbHeight : thumbHeight + 1;
		}
		
		private function get thumbBoundaryRect() : Rectangle {
			var rectangle : Rectangle = new Rectangle();
			
			if (isHorizontal) {
				rectangle.x = _thumbPadding;
				rectangle.width = _width - _thumbSize - _thumbPadding;
			} else {
				rectangle.y = _thumbPadding;
				rectangle.height = _height - _thumbSize - _thumbPadding;
			}
			
			return rectangle;
		}

	}
}
