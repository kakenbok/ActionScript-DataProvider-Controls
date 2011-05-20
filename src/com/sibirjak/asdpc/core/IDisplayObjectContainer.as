package com.sibirjak.asdpc.core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * Interface to many of the native Flash DisplayObjectContainer methods.
	 * 
	 * @author jes 27.01.2010
	 */
	public interface IDisplayObjectContainer extends IDisplayObject {

		/*
		 * Mouse
		 */

		function set mouseChildren(mouseChildren : Boolean) : void; 

		/*
		 * Display hierarchy
		 */

		function addChild(child : DisplayObject) : DisplayObject;

		function addChildAt(child : DisplayObject, index : int) : DisplayObject;

		function removeChild(child : DisplayObject) : DisplayObject;

		function removeChildAt(index : int) : DisplayObject;

		function contains(child : DisplayObject) : Boolean;

		function getChildAt(index : int) : DisplayObject;

		function get parent() : DisplayObjectContainer;

		function get numChildren() : int;

	}
}
