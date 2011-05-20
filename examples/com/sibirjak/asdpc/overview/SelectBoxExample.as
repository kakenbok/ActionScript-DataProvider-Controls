package com.sibirjak.asdpc.overview {
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.selectbox.SelectBox;

	public class SelectBoxExample extends Example {
		private var _label : Label;
		private var _selectBox : SelectBox;

		public function SelectBoxExample() {
			_selectBox = new SelectBox();
			_selectBox.dataSource = ["a", "b", "c", "d", "e", "f"];
			_selectBox.setStyle(SelectBox.style.maxVisibleItems, 4);
			_selectBox.bindProperty(
				SelectBox.BINDABLE_PROPERTY_SELECTED_ITEM, itemSelected
			);
			addChild(_selectBox);

			_label = new Label();
			_label.text = "No item selected";
			_label.moveTo(0, 30);
			addChild(_label);
		}
				
		private function itemSelected(item : String) : void {
			if (_label) {
				_label.text = (
					item + " is selected"
					+ " at " + _selectBox.selectedIndex
				);
			}
		}
	}
}