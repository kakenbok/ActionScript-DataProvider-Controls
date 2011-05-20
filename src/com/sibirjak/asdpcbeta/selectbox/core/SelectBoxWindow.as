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
package com.sibirjak.asdpcbeta.selectbox.core {
	import com.sibirjak.asdpc.core.managers.IPopUpControl;
	import com.sibirjak.asdpc.core.managers.IPopUpControlPopUp;
	import com.sibirjak.asdpc.listview.IListView;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpcbeta.selectbox.SelectBox;
	import com.sibirjak.asdpcbeta.window.Window;

	import flash.display.DisplayObject;

	/**
	 * @author jes 08.01.2010
	 */
	public class SelectBoxWindow extends Window implements IPopUpControlPopUp {

		/* properties */
		private var _selectBox : SelectBox;
		private var _list : IListView;

		public function SelectBoxWindow() {
			setStyles([
				Window.style.titleBar, false,

				Window.style.restoreDuration, 0.1,
				Window.style.minimiseDuration, 0.1,
				Window.style.minimiseTweenProperties, Window.TWEEN_ALPHA,

				Window.style.padding, 1
			]);
			
			minimiseOnClickOutside = true;
			
			_list = new ListView();
			_list.deselect = false;
			document = _list as DisplayObject;
		}

		public function get list() : IListView {
			return _list;
		}

		public function set selectBox(selectBox : SelectBox) : void {
			_selectBox = selectBox;
			minimiseTriggerButton = _selectBox;
		}

		/*
		 * IPopUpControlPopUp
		 */
		
		public function get popUpControl() : IPopUpControl {
			return _selectBox;
		}
		
	}
}
