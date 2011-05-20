package com.sibirjak.asdpcbeta.scrollbar {
	import com.sibirjak.asdpc.core.IView;

	import flash.display.DisplayObject;

	/**
	 * ScrollPane public interface.
	 * 
	 * @author jes 11.03.2010
	 */
	public interface IScrollPane extends IView {

		/**
		 * @private
		 */
		function set document(document : DisplayObject) : void;

		/**
		 * Sets or returns the document assigned to this ScrollPane.
		 */
		function get document() : DisplayObject;

		/**
		 * Sets button, thumb and track scroll amounts.
		 * 
		 * @param buttonScroll The amout of pixels to scroll by a single button click.
		 * @param thumbScroll The minimal amout of pixels to scroll by moving the thumb.
		 * @param trackScroll The amout of pixels to scroll by click onto the scroll track.
		 */		
		function setScrollProperties(buttonScroll : uint, thumbScroll : uint, trackScroll : uint) : void;

		/**
		 * Nofifies the ScrollPane that its document size has changed.
		 * 
		 * <p>In response the ScrollPane displays or hides the scrollbars.</p>
		 */
		function documentSizeChanged() : void;

	}
}
