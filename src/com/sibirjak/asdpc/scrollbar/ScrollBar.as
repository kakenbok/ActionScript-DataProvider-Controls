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
package com.sibirjak.asdpc.scrollbar {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.button.IButton;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Direction;
	import com.sibirjak.asdpc.core.constants.Visibility;
	import com.sibirjak.asdpc.scrollbar.core.Thumb;
	import com.sibirjak.asdpc.scrollbar.skins.ScrollButtonIconSkin;
	import com.sibirjak.asdpc.scrollbar.skins.ScrollThumbIconSkin;
	import com.sibirjak.asdpc.scrollbar.skins.ScrollTrackSkin;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/*
	 * Styles
	 */
	
	/**
	 * @copy ScrollBarStyles#scrollButtonVisibility
	 */
	[Style(name="scrollBar_scrollButtonVisibility", type="String", enumeration="visible, auto, hidden")]

	/**
	 * @copy ScrollBarStyles#ctrlKeyWheel
	 */
	[Style(name="scrollBar_ctrlKeyWheel", type="Boolean")]

	/*
	 * ScrollEvent
	 */

	/**
	 * @eventType com.sibirjak.asdpc.scrollbar.ScrollEvent.SCROLL
	 */
	[Event(name="scrollBar_scroll", type="com.sibirjak.asdpc.scrollbar.ScrollEvent")]

	/**
	 * ScrollBar component.
	 * 
	 * @author jes 16.06.2009
	 */
	public class ScrollBar extends View implements IScrollBar {
		
		/* style declarations */

		/**
		 * Central accessor to all ScrollBar style property definitions.
		 */
		public static var style : ScrollBarStyles = new ScrollBarStyles();

		/* constants */

		/**
		 * Name constant defining the scroll up button name.
		 */
		public static const UP_BUTTON_NAME: String = "scrollBarUpButton";

		/**
		 * Name constant defining the scroll down button name.
		 */
		public static const DOWN_BUTTON_NAME : String = "scrollBarDownButton";

		/**
		 * Name constant defining the scroll track name.
		 */
		public static const TRACK_NAME : String = "scrollBarTrack";

		/**
		 * Name constant defining the scroll thumb name.
		 */
		public static const THUMB_NAME : String = "scrollBarThumb";

		/**
		 * Name constant defining the scrollbar direction view property.
		 */
		public static const VIEW_PROPERTY_SCROLLBAR_DIRECTION : String = "scrollBarDirection";

		/**
		 * Name constant defining the view scrollbar button view property.
		 */
		public static const VIEW_PROPERTY_SCROLLBAR_BUTTON : String = "scrollBarButton";
		
		/**
		 * Name constant defining the minimum thumb size.
		 */
		private const MIN_THUMB_SIZE : uint = 11;

		/* changeable properties or styles */

		/**
		 * Name constant for the document size invalidation property.
		 */
		private const UPDATE_PROPERTY_DOCUMENT_SIZE : String = "document_size";

		/**
		 * Name constant for the document position invalidation property.
		 */
		private const UPDATE_PROPERTY_DOCUMENT_POSITION : String = "document_position";

		/**
		 * Name constant for the scroll invalidation property.
		 */
		private const UPDATE_PROPERTY_SCROLL : String = "scroll";

		/**
		 * Name constant for the thumb scroll invalidation property.
		 */
		private const UPDATE_PROPERTY_THUMB_SCROLL : String = "thumb_scroll";

		/**
		 * Name constant for the activation invalidation property.
		 */
		private const UPDATE_PROPERTY_ACTIVATION : String = "activation";

		/**
		 * Name constant for the button visibility invalidation property.
		 */
		private const UPDATE_PROPERTY_BUTTON_VISIBILITY : String = "button_visibility";

		/* properties */
		
		/**
		 * The scrollbar owner.
		 */
		private var _owner : DisplayObject;

		/**
		 * The scrollbar direction.
		 */
		private var _direction : String = Direction.VERTICAL;

		/**
		 * The owner's document size.
		 */
		private var _documentSize : uint;

		/**
		 * Button scroll amount.
		 */
		private var _buttonScroll : uint;

		/**
		 * Thumb scroll amount.
		 */
		private var _thumbScroll : uint;

		/**
		 * Track scroll amount.
		 */
		private var _trackScroll : uint;

		/**
		 * Current document position.
		 */
		private var _documentPosition : int;

		/**
		 * Enabled flag.
		 */
		private var _enabled : Boolean = true;

		/* styles */

		/**
		 * Scroll button visibility.
		 */
		private var _scrollButtonVisibility : String;
		
		/* children */

		/**
		 * Up button.
		 */
		private var _upButton : IButton;

		/**
		 * Down button.
		 */
		private var _downButton : IButton;

		/**
		 * Track.
		 */
		private var _track : IButton;

		/**
		 * Thumb.
		 */
		private var _thumb : Thumb;

		/**
		 * ScrollBar constructor.
		 */
		public function ScrollBar() {
			
			setDefaultSize(14, 240); // vertical default size

			setDefaultStyles([
				style.scrollButtonVisibility, Visibility.AUTO,

				style.ctrlKeyWheel, false
			]);
			
		}
		
		/*
		 * IScrollBar
		 */

		/**
		 * @inheritDoc
		 */
		public function set owner(owner : DisplayObject) : void {
			if (_initialised) return;

			_owner = owner;
		}

		/**
		 * @inheritDoc
		 */
		public function setScrollProperties(
			buttonScroll : uint,
			thumbScroll : uint,
			trackScroll : uint
		) : void {
			_buttonScroll = buttonScroll;
			_thumbScroll = thumbScroll;
			_trackScroll = trackScroll;
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
		public function set direction(direction : String) : void {
			if (_initialised) return;
			
			_direction = direction;

			if (_direction == Direction.HORIZONTAL) {
				setDefaultSize(240, 14); // vertical default size
			} else {
				setDefaultSize(14, 240); // vertical default size
			}
		}

		/**
		 * @inheritDoc
		 */
		public function set documentSize(documentSize : uint) : void {
			_documentSize = documentSize;

			invalidateProperty(UPDATE_PROPERTY_DOCUMENT_SIZE);
		}

		/**
		 * @inheritDoc
		 */
		public function get documentSize() : uint {
			return _documentSize;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(enabled : Boolean) : void {
			_enabled = enabled;
			
			invalidateProperty(UPDATE_PROPERTY_ACTIVATION);
		}

		/**
		 * @inheritDoc
		 */
		public function get enabled() : Boolean {
			return _enabled;
		}

		/**
		 * @inheritDoc
		 */
		public function scrollTo(documentPosition : int) : int {
			documentPosition = minMaxDocumentPosition(documentPosition);
			if (documentPosition == _documentPosition) return documentPosition;
			_documentPosition = documentPosition;

			invalidateProperty(UPDATE_PROPERTY_DOCUMENT_POSITION);
			
			return _documentPosition;
		}

		/**
		 * @inheritDoc
		 */
		public function get documentPosition() : int {
			return _documentPosition;
		}

		/*
		 * View life cycle
		 */

		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			if (!_owner) _owner = new Sprite();
			
			setViewProperty(VIEW_PROPERTY_SCROLLBAR_DIRECTION, _direction);

			_scrollButtonVisibility = getStyle(style.scrollButtonVisibility);

			addEventListener(MouseEvent.MOUSE_WHEEL, mouseScrollHandler);
			_owner.addEventListener(MouseEvent.MOUSE_WHEEL, mouseScrollHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			// up button

			_upButton = new Button();
			_upButton.setViewProperty(VIEW_PROPERTY_SCROLLBAR_BUTTON, UP_BUTTON_NAME);
			_upButton.name = UP_BUTTON_NAME; // set name to enable selective styling
			
			_upButton.setSize(buttonSize, buttonSize);

			_upButton.setDefaultStyles([
				Button.style.upIconSkin, ScrollButtonIconSkin,
				Button.style.disabledIconSkin, ScrollButtonIconSkin,
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME, // use up icon
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME, // use up icon
			]);

			_upButton.enabled = scrollingEnabled;
			_upButton.autoRepeat = true;
			_upButton.visible = scrollButtonsVisible;
			_upButton.addEventListener(ButtonEvent.MOUSE_DOWN, buttonScrollHandler);
			updateAutomatically(DisplayObject(_upButton));
			addChild(DisplayObject(_upButton));

			// down button

			_downButton = new Button();
			_downButton.setViewProperty(VIEW_PROPERTY_SCROLLBAR_BUTTON, DOWN_BUTTON_NAME);
			_downButton.name = DOWN_BUTTON_NAME; // set name to enable selective styling

			_downButton.setSize(buttonSize, buttonSize);

			_downButton.setDefaultStyles([
				Button.style.upIconSkin, ScrollButtonIconSkin,
				Button.style.disabledIconSkin, ScrollButtonIconSkin,
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME, // use up icon
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME, // use up icon
			]);

			_downButton.enabled = scrollingEnabled;
			_downButton.autoRepeat = true;
			_downButton.visible = scrollButtonsVisible;
			_downButton.moveTo(downButtonX, downButtonY);
			_downButton.addEventListener(ButtonEvent.MOUSE_DOWN, buttonScrollHandler);
			updateAutomatically(DisplayObject(_downButton));
			addChild(DisplayObject(_downButton));

			// track

			_track = new Button();
			_track.name = TRACK_NAME; // set name to enable selective styling
			
			_track.setSize(trackWidth, trackHeight);

			_track.setDefaultStyles([
				Button.style.upSkin, ScrollTrackSkin,
				Button.style.overSkinName, Button.UP_SKIN_NAME, // use up skin
				Button.style.downSkinName, Button.UP_SKIN_NAME, // use up skin
				Button.style.disabledSkinName, Button.UP_SKIN_NAME // use up skin
			]);

			_track.enabled = scrollingEnabled;
			_track.autoRepeat = true;
			_track.moveTo(trackX, trackY);

			_track.addEventListener(ButtonEvent.MOUSE_DOWN, trackScrollHandler);
			updateAutomatically(DisplayObject(_track));
			addChild(DisplayObject(_track));

			// thumb

			_thumb = new Thumb();
			_thumb.name = THUMB_NAME; // set name to enable selective styling
			
			_thumb.setSize(thumbWidth, thumbHeight);

			_thumb.setDefaultStyles([
				Button.style.overSkinName, Button.UP_SKIN_NAME, // use up skin
				Button.style.downSkinName, Button.UP_SKIN_NAME, // use up skin
				Button.style.disabledSkinName, Button.UP_SKIN_NAME, // use up skin

				Button.style.upIconSkin, ScrollThumbIconSkin,
				Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME, // use up icon
				Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME, // use up icon
				// if not enabled, thumb is invisible
			]);

			_thumb.direction = _direction;
			_thumb.visible = scrollingEnabled;
			_thumb.minPosition = trackPosition;
			_thumb.maxPosition = pageSize - thumbSize - trackPosition;
			_thumb.scroll = _documentPosition / maxScrollPosition;

			_thumb.addEventListener(Thumb.EVENT_THUMB_SCROLL, thumbScrollHandler);
			updateAutomatically(_thumb);
			addChild(DisplayObject(_thumb));

		}

		/**
		 * @inheritDoc
		 */
		override protected function update() : void {
			
			var enableButtons : Boolean = false;
			var resizeThumb : Boolean = false;
			var positionThumb : Boolean = false;
			var resizeTrack : Boolean = false;
			var setButtonVisibility : Boolean = false;
			var dispatchScrollEvent : Boolean = false;
			
			// scrollbar size changed

			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				_upButton.setSize(buttonSize, buttonSize);

				resizeTrack = true;
				
				_downButton.setSize(buttonSize, buttonSize);
				_downButton.moveTo(downButtonX, downButtonY);

				resizeThumb = true;
				positionThumb = true;
			}
			
			// scrollbar enabled / disabled

			if (isInvalid(UPDATE_PROPERTY_ACTIVATION)) {
				// enable buttons and show them if Visibility.AUTO
				enableButtons = true;
				
				// buttons appear - resize track
				if (_scrollButtonVisibility == Visibility.AUTO) {
					setButtonVisibility = true;
					resizeTrack = true;
				}
			}

			// button visibility style changed

			if (isInvalid(UPDATE_PROPERTY_BUTTON_VISIBILITY)) {
				setButtonVisibility = true;

				// track has to move
				resizeTrack = true;

				resizeThumb = true;
				positionThumb = true;
			}

			// document size has changed

			if (isInvalid(UPDATE_PROPERTY_DOCUMENT_SIZE)) {
				
				// validate scroll position is in range
				var documentPosition : int = minMaxDocumentPosition(_documentPosition);
				if (documentPosition != _documentPosition) {
					_documentPosition = documentPosition;
					dispatchScrollEvent = true;
				}
				
				// thumb size changed
				resizeThumb = true;
				positionThumb = true;

				// scrollbar may become enabled/disabled
				if (_upButton.enabled != scrollingEnabled) {
					enableButtons = true;
					// if enabled changed and auto -> show buttons
					if (_scrollButtonVisibility == Visibility.AUTO) {
						if (_upButton.visible != scrollButtonsVisible) {
							setButtonVisibility = true;
							resizeTrack = true;
						}
					}
				}
			}
			
			// scroll position

			if (isInvalid(UPDATE_PROPERTY_DOCUMENT_POSITION)) { // programmatic scroll
				positionThumb = true;
			}
			
			if (isInvalid(UPDATE_PROPERTY_SCROLL)) { // button, track, wheel scroll
				positionThumb = true;
				
				dispatchScrollEvent = true;
			}
			
			if (isInvalid(UPDATE_PROPERTY_THUMB_SCROLL)) { // thumb scroll
				dispatchScrollEvent = true;
			}
			
			// actions
			
			if (resizeThumb) {
				_thumb.setSize(thumbWidth, thumbHeight);
				_thumb.minPosition = trackPosition;
				_thumb.maxPosition = pageSize - thumbSize - trackPosition;
			}
			
			if (positionThumb) {
				_thumb.scroll = _documentPosition / maxScrollPosition;
			}

			if (resizeTrack) {
				_track.setSize(trackWidth, trackHeight);
				_track.moveTo(trackX, trackY);
			}
			
			if (setButtonVisibility) {
				_upButton.visible = scrollButtonsVisible;
				_downButton.visible = scrollButtonsVisible;
			}

			if (enableButtons) {
				_upButton.enabled = scrollingEnabled;
				_downButton.enabled = scrollingEnabled;

				_track.enabled = scrollingEnabled;
				_thumb.visible = scrollingEnabled;
			}
			
			if (dispatchScrollEvent) {
				dispatchScroll();
			}
			
		}

		/**
		 * @inheritDoc
		 */
		override protected function styleChanged(property : String, value : *) : void {
			if (property == style.scrollButtonVisibility) {
				_scrollButtonVisibility = value;
				invalidateProperty(UPDATE_PROPERTY_BUTTON_VISIBILITY);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			removeEventListener(MouseEvent.MOUSE_WHEEL, mouseScrollHandler);
			_owner.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseScrollHandler);

			_upButton.removeEventListener(ButtonEvent.MOUSE_DOWN, buttonScrollHandler);
			_downButton.removeEventListener(ButtonEvent.MOUSE_DOWN, buttonScrollHandler);
			_thumb.removeEventListener(Thumb.EVENT_THUMB_SCROLL, thumbScrollHandler);
			_track.removeEventListener(ButtonEvent.MOUSE_DOWN, trackScrollHandler);
		}

		/*
		 * Events
		 */

		/**
		 * Mouse scroll handler.
		 */
		private function mouseScrollHandler(event : MouseEvent) : void {
			
			if (getStyle(style.ctrlKeyWheel)) {
				if (!event.ctrlKey) return;
			} else {
				if (event.ctrlKey) return;
			}
			
			if (!scrollingEnabled) return;
			
			scrollBy(event.delta * _buttonScroll);
		}

		/**
		 * Thumb scroll handler.
		 */
		private function thumbScrollHandler(event : Event) : void {
			var documentPosition : int = maxScrollPosition * _thumb.scroll;
			documentPosition = Math.round(documentPosition / _thumbScroll) * _thumbScroll;

			if (documentPosition == _documentPosition) return;

			_documentPosition = documentPosition;

			invalidateProperty(UPDATE_PROPERTY_THUMB_SCROLL);
		}

		/**
		 * Button scroll handler.
		 */
		private function buttonScrollHandler(event : ButtonEvent) : void {
			var scrollDirection : int = event.target == _upButton ? 1 : -1;
			scrollBy(scrollDirection * _buttonScroll);
		}
		
		/**
		 * Track scroll handler.
		 */
		private function trackScrollHandler(event : Event) : void {
			var position : Number = isHorizontal ? mouseX : mouseY;
			var scrollDirection : int = 0;
			
			if (position < _thumb.position) {
				scrollDirection = 1;
			} else if (position > _thumb.position + thumbSize) {
				scrollDirection = -1;
			}

			scrollBy(scrollDirection * _trackScroll);
		}
		
		/*
		 * Private
		 */

		/**
		 * Dispatchs a scroll event.
		 */
		private function dispatchScroll() : void {
			dispatchEvent(new ScrollEvent(_documentPosition));
		}
		
		/**
		 * Scrolls by the specific amout of pixels.
		 */
		private function scrollBy(delta : int) : void {
			var documentPosition : int = _documentPosition + delta;
			documentPosition = Math.round(documentPosition / _buttonScroll) * _buttonScroll;
			documentPosition = minMaxDocumentPosition(documentPosition);

			if (documentPosition == _documentPosition) return;

			_documentPosition = documentPosition;

			invalidateProperty(UPDATE_PROPERTY_SCROLL);
		}
		
		/**
		 * Returns the max scroll position.
		 */
		private function get maxScrollPosition() : int {
			return Math.min(0, - (_documentSize - pageSize));
		}

		/**
		 * Returns true, if scrolling is enabled.
		 */
		private function get scrollingEnabled() : Boolean {
			return _enabled && _documentSize > pageSize;
		}
		
		/**
		 * Returns true, if the scroll buttons should be visible.
		 */
		private function get scrollButtonsVisible() : Boolean {
			if (scrollingEnabled) {
				return _scrollButtonVisibility != Visibility.HIDDEN;
			}
			return _scrollButtonVisibility == Visibility.VISIBLE;
		}

		/**
		 * Returns true, if the scrollbar is a horizontal scrollbar.
		 */
		private function get isHorizontal() : Boolean {
			return _direction == Direction.HORIZONTAL;
		}
		
		/**
		 * Ranges a given document position.
		 */
		private function minMaxDocumentPosition(documentPosition : int) : int {
			documentPosition = Math.max(documentPosition, maxScrollPosition);
			return Math.min(0, documentPosition);
		}
			
		
		/*
		 * State distinction
		 */
		
		/* page */
		
		/**
		 * Returns the owner's visible size.
		 */
		private function get pageSize() : uint {
			return isHorizontal ? _width : _height;
		}

		/* track */
		
		/**
		 * Returns the track size.
		 */
		private function get trackSize() : uint {
			var trackSize : uint = pageSize;
			if (scrollButtonsVisible) trackSize -= 2 * buttonSize;
			return trackSize; 
		}

		/**
		 * Returns the track position.
		 */
		private function get trackPosition() : uint {
			var trackPosition : uint = 0;
			if (scrollButtonsVisible) trackPosition = buttonSize;
			return trackPosition; 
		}

		/**
		 * Returns the track width.
		 */
		private function get trackWidth() : uint {
			return isHorizontal ? trackSize : _width;
		}

		/**
		 * Returns the track height.
		 */
		private function get trackHeight() : uint {
			return isHorizontal ? _height : trackSize;
		}

		/**
		 * Returns the track x position.
		 */
		private function get trackX() : uint {
			return isHorizontal ? trackPosition : 0;
		}

		/**
		 * Returns the track y position.
		 */
		private function get trackY() : uint {
			return isHorizontal ? 0 : trackPosition;
		}

		/* thumb */
		
		/**
		 * Returns the thumb size.
		 */
		private function get thumbSize() : uint {
			if (!_documentSize) return MIN_THUMB_SIZE;
			if (!_documentSize) return MIN_THUMB_SIZE;
			var thumbSize : uint = pageSize * trackSize / _documentSize;
			thumbSize = Math.max(MIN_THUMB_SIZE, thumbSize); // make thumb min 11px height			
			return Math.min(trackSize, thumbSize); // make thumb max track height			
		}
		
		/**
		 * Returns the thumb width.
		 */
		private function get thumbWidth() : uint {
			return isHorizontal ? thumbSize : _width;
		}

		/**
		 * Returns the thumb height.
		 */
		private function get thumbHeight() : uint {
			return isHorizontal ? _height : thumbSize;
		}

		/* button */
		
		/**
		 * Returns the button size.
		 */
		private function get buttonSize() : uint {
			return isHorizontal ? _height : _width;
		}

		/**
		 * Returns the down button x position.
		 */
		private function get downButtonX() : uint {
			return isHorizontal ? _width - _height : 0;
		}

		/**
		 * Returns the down button y position.
		 */
		private function get downButtonY() : uint {
			return isHorizontal ? 0 : _height - _width;
		}
		
	}
}
