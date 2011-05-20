package com.sibirjak.asdpc.common.interfacedemo.windows.info {
	import org.as3commons.collections.SortedSet;

	/**
	 * @author jes 29.01.2010
	 */
	public class StyleContainer extends SortedSet {
		public var name : String = "styles";
		public function StyleContainer() {
			super(new StyleComparator());
		}
	}
}

import com.sibirjak.asdpc.common.interfacedemo.windows.info.Style;

import org.as3commons.collections.utils.StringComparator;

internal class StyleComparator extends StringComparator {
	override public function compare(item1 : *, item2 : *) : int {
		return super.compare(Style(item1).property, Style(item2).property);
	}
}
