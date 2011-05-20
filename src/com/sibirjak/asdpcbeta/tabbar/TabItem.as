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
package com.sibirjak.asdpcbeta.tabbar {
	import com.sibirjak.asdpc.core.DisplayObjectAdapter;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.textfield.Label;

	import flash.display.DisplayObject;

	/**
	 * @author jes 03.12.2009
	 */
	public class TabItem extends View {
		
		/* constants */
		public static const SKIN_NAME: String = "skin";
		public static const SELECTED_SKIN_NAME: String = "selectedSkin";

		/* properties */
		private var _tabBar : TabBar;
		private var _text : String;
		private var _selected : Boolean;

		/* children */
		private var _skin : DisplayObject;
		private var _selectedSkin : DisplayObject;
		private var _label : Label;

		public function TabItem() {
		}
		
		public function set tabBar(tabBar : TabBar) : void {
			_tabBar = tabBar;
		}

		public function set label(label : String) : void {
			_text = label;

			if (!_initialised) return;
			
			_label.text = label;
		}
		
		public function get label() : String {
			return _text;
		}

		public function set selected(selected : Boolean) : void {
			_selected = selected;
			
			if (!_initialised) return;

			_skin.visible = !_selected;
			_selectedSkin.visible = _selected;
			
			var color : uint = _selected ? 0x666666 : 0x444444;
			_label.setStyle(Label.style.color, color);
		}

		public function get selected() : Boolean {
			return _selected;
		}
		
		/*
		 * View life cycle
		 */

		override protected function draw() : void {
			
			var skinClass : Class = _tabBar.getStyle(TabBar.style.tabItemSkin);
			_skin  = new skinClass();
			_skin.name = SKIN_NAME;
			DisplayObjectAdapter.setSize(_skin, _width, _height);
			DisplayObjectAdapter.addChild(_skin, this);
			_skin.visible = !_selected;
			
			skinClass = _tabBar.getStyle(TabBar.style.selectedTabItemSkin);
			_selectedSkin = new skinClass();
			_selectedSkin.name = SELECTED_SKIN_NAME;
			DisplayObjectAdapter.setSize(_selectedSkin, _width, _height);
			DisplayObjectAdapter.addChild(_selectedSkin, this);
			_selectedSkin.visible = _selected;
			
			_label = new Label();
//			_label.setSize(_width - 6, _height);
			_label.setSize(_width, _height);
			_label.setStyle(Label.style.horizontalAlign, Position.CENTER);
			_label.setStyle(Label.style.verticalAlign, Position.BOTTOM);
			

			var color : uint = _selected ? 0x666666 : 0x444444;
			_label.setStyle(Label.style.color, color);

			_label.text = _text.toUpperCase();

//			_label.moveTo(6, 0);
			_label.moveTo(0, 0);
			addChild(_label);
		}
		
	}
}
