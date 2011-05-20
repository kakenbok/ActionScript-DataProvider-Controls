package com.sibirjak.asdpcbeta.scrollbar {
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Direction;
	import com.sibirjak.asdpc.core.constants.Visibility;
	import com.sibirjak.asdpc.core.skins.GlassFrame;
	import com.sibirjak.asdpc.scrollbar.IScrollBar;
	import com.sibirjak.asdpc.scrollbar.ScrollBar;
	import com.sibirjak.asdpc.scrollbar.ScrollEvent;

	import flash.display.DisplayObject;
	import flash.display.Shape;

	/**
	 * @copy ScrollPaneStyles#scrollBarVisibility
	 */
	[Style(name="scrollPane_scrollBarVisibility", type="String", enumeration="visible, auto, hidden")]

	/**
	 * @copy ScrollPaneStyles#hScrollBar
	 */
	[Style(name="scrollPane_hScrollBar", type="Boolean")]

	/**
	 * @copy ScrollPaneStyles#vScrollBar
	 */
	[Style(name="scrollPane_vScrollBar", type="Boolean")]

	/**
	 * @copy ScrollPaneStyles#scrollBarSize
	 */
	[Style(name="scrollPane_scrollBarSize", type="uint", format="Size")]

	/**
	 * @author jes 01.02.2010
	 */
	public class ScrollPane extends View implements IScrollPane {
		
		/* style declarations */

		/**
		 * Central accessor to all ScrollPane style property definitions.
		 */
		public static var style : ScrollPaneStyles = new ScrollPaneStyles();

		/* constants */

		/**
		 * Name constant defining the horizontal scrollbar name.
		 */
		public static const H_SCROLLBAR_NAME: String = "hScrollBar";

		/**
		 * Name constant defining the vertical scrollbar name.
		 */
		public static const V_SCROLLBAR_NAME: String = "vScrollBar";

		/* changeable properties or styles */

		/**
		 * Name constant for the document size invalidation property.
		 */
		private const UPDATE_PROPERTY_DOCUMENT_SIZE : String = "document_size";

		/**
		 * Name constant for the scrollbar visibility invalidation property.
		 */
		private const UPDATE_PROPERTY_SCROLLBAR_VISIBILITY : String = "scrollbar_visibility";

		/**
		 * Name constant for the document size invalidation property.
		 */
		private const UPDATE_PROPERTY_SCROLLBAR_SIZE : String = "scrollbar_size";

		/* properties */

		/**
		 * The scrollpane document.
		 */
		private var _document : DisplayObject;

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

		/* styles */

		/**
		 * Size of the scrollbars.
		 */
		private var _scrollBarSize : uint;
		
		/* children */
		
		/**
		 * Masks the document over the scrollpane area.
		 */
		private var _documentMask : GlassFrame;

		/**
		 * Horizontal scrollbar.
		 */
		private var _hScrollBar : IScrollBar;

		/**
		 * Vertical scrollbar.
		 */
		private var _vScrollBar : IScrollBar;
		
		/**
		 * ScrollPane constructor.
		 */
		public function ScrollPane() {
			
			setDefaultStyles([
				style.scrollBarVisibility, Visibility.AUTO,
				style.hScrollBar, true,
				style.vScrollBar, true,
				style.scrollBarSize, 14
			]);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get document() : DisplayObject {
			return _document;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set document(document : DisplayObject) : void {
			if (_initialised) return;

			_document = document;
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
		public function documentSizeChanged() : void {
			invalidateProperty(UPDATE_PROPERTY_DOCUMENT_SIZE);
		}

		/*
		 * View life cycle
		 */
		
		/**
		 * @inheritDoc
		 */
		override protected function init() : void {
			if (!_document) _document = new Shape();
			
			_scrollBarSize = getStyle(style.scrollBarSize);
			
			if (!_buttonScroll) _buttonScroll = 20;
			if (!_thumbScroll) _thumbScroll = 1;
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw() : void {
			
			addChild(_document);
			
			createVScrollBar();
			createHScrollBar();

			_documentMask = new GlassFrame();
			setMaskSize();
			_documentMask.name = "documentMask";
			_document.mask = _documentMask;
			addChildAt(_documentMask, 1);
		}

		/**
		 * @inheritDoc
		 */
		override protected function update() : void {

			// scrollpane size changed

			if (isInvalid(UPDATE_PROPERTY_SIZE)) {
				// show, hide, resize, move scrollbars
				// reset scroll position
				// resize mask
			}

			// document size has changed

			if (isInvalid(UPDATE_PROPERTY_DOCUMENT_SIZE)) {
				
				// show, hide, resize scrollbars

				if (_hScrollBar.visible != hScrollBarVisible) {
					_hScrollBar.visible = !_hScrollBar.visible;

					if (_hScrollBar.visible) {
						_vScrollBar.setSize(_scrollBarSize, _height - _scrollBarSize);
					} else {
						_vScrollBar.setSize(_scrollBarSize, _height);
					}
				}
				
				if (_vScrollBar.visible != vScrollBarVisible) {
					_vScrollBar.visible = !_vScrollBar.visible;

					if (_vScrollBar.visible) {
						_hScrollBar.setSize(_width - _scrollBarSize, _scrollBarSize);
					} else {
						_hScrollBar.setSize(_width, _scrollBarSize);
					}
				}
				
				// reset scroll position
				
				_hScrollBar.validateNow();
				_vScrollBar.validateNow();

				_hScrollBar.documentSize = _document.width;
				_hScrollBar.validateNow();
				_vScrollBar.documentSize = _document.height;

				// reset mask size

				setMaskSize();
				
			}

			// scrollbar visibility styles have changed

			if (isInvalid(UPDATE_PROPERTY_SCROLLBAR_VISIBILITY)) {
				// show, hide scrollbars
			}

			// scrollbar size style has changed

			if (isInvalid(UPDATE_PROPERTY_SCROLLBAR_SIZE)) {
				// resize, move scrollbars
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

			if (property == style.scrollBarVisibility || property == style.hScrollBar || property == style.vScrollBar) {
				invalidateProperty(UPDATE_PROPERTY_SCROLLBAR_VISIBILITY);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function cleanUpCalled() : void {
			_hScrollBar.removeEventListener(ScrollEvent.SCROLL, hScrollHandler);
			_vScrollBar.removeEventListener(ScrollEvent.SCROLL, vScrollHandler);
		}

		/*
		 * Private
		 */

		/**
		 * Resizes the mask according to the current scrollbar visibilities.
		 */
		private function setMaskSize() : void {
			var maskWidth : uint = _width;
			var maskHeight : uint = _height;
			
			if (_vScrollBar.visible) maskWidth -= (_scrollBarSize + 1);
			if (_hScrollBar.visible) maskHeight -= (_scrollBarSize + 1);

			_documentMask.setSize(maskWidth, maskHeight);
		}

		/**
		 * Creates the vertical scrollbar.
		 */
		private function createVScrollBar() : void {
			_vScrollBar = new ScrollBar();

			if (hScrollBarVisible) {
				_vScrollBar.setSize(_scrollBarSize, _height - _scrollBarSize);
			} else {
				_vScrollBar.setSize(_scrollBarSize, _height);
			}

			_vScrollBar.owner = this;
			_vScrollBar.setScrollProperties(_buttonScroll, _thumbScroll, vTrackScroll);
			_vScrollBar.documentSize = _document.height;
			_vScrollBar.visible = vScrollBarVisible;

			updateAutomatically(DisplayObject(_vScrollBar));
			
			_vScrollBar.moveTo(_width - _scrollBarSize, 0);
			_vScrollBar.addEventListener(ScrollEvent.SCROLL, vScrollHandler);
			addChild(DisplayObject(_vScrollBar));
		}
		
		/**
		 * Creates the horizontal scrollbar.
		 */
		private function createHScrollBar() : void {
			_hScrollBar = new ScrollBar();

			if (vScrollBarVisible) {
				_hScrollBar.setSize(_width - _scrollBarSize, _scrollBarSize);
			} else {
				_hScrollBar.setSize(_width, _scrollBarSize);
			}

			_hScrollBar.setStyle(ScrollBar.style.ctrlKeyWheel, true);

			_hScrollBar.owner = this;
			_hScrollBar.direction = Direction.HORIZONTAL;
			_hScrollBar.setScrollProperties(_buttonScroll, _thumbScroll, hTrackScroll);
			_hScrollBar.documentSize = _document.width;
			_hScrollBar.visible = hScrollBarVisible;
			
			updateAutomatically(DisplayObject(_hScrollBar));
			
			_hScrollBar.moveTo(0, _height - _scrollBarSize);
			_hScrollBar.addEventListener(ScrollEvent.SCROLL, hScrollHandler);
			addChild(DisplayObject(_hScrollBar));
		}
		
		/**
		 * Calculates and returns the vTrackScroll.
		 * 
		 * <p>If not else specified, clicking the scroll track should scroll the
		 * document by 1 page.</p>
		 */
		private function get vTrackScroll() : uint {
			return _trackScroll
				? _trackScroll
				: hScrollBarVisible
					? _height - _scrollBarSize - 1
					: _height;
		}
			
		/**
		 * Calculates and returns the hTrackScroll.
		 * 
		 * <p>If not else specified, clicking the scroll track should scroll the
		 * document by 1 page.</p>
		 */
		private function get hTrackScroll() : uint {
			return _trackScroll
				? _trackScroll
				: vScrollBarVisible
					? _width - _scrollBarSize - 1
					: _width;
		}

		/**
		 * Returns the vScrollBar visibility.
		 */
		private function get vScrollBarVisible() : Boolean {
			if (getStyle(style.scrollBarVisibility) == Visibility.HIDDEN) return false;
			if (!getStyle(style.vScrollBar)) return false;
			return _document ? _document.height > _height : false;
		}

		/**
		 * Returns the hScrollBar visibility.
		 */
		private function get hScrollBarVisible() : Boolean {
			if (getStyle(style.scrollBarVisibility) == Visibility.HIDDEN) return false;
			if (!getStyle(style.hScrollBar)) return false;
			return _document ? _document.width > _width : false;
		}
		
		/*
		 * Scroll events
		 */

		/**
		 * vScrollBar scroll handler.
		 */
		private function vScrollHandler(event : ScrollEvent) : void {
			_document.y = event.documentPosition;
		}

		/**
		 * hScrollBar scroll handler.
		 */
		private function hScrollHandler(event : ScrollEvent) : void {
			_document.x = event.documentPosition;
		}
		
	}
}
