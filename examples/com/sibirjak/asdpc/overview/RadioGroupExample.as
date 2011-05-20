package com.sibirjak.asdpc.overview {
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.radiobutton.RadioButton;
	import com.sibirjak.asdpcbeta.radiobutton.RadioGroup;

	public class RadioGroupExample extends Example {
		private var _label : Label;

		public function RadioGroupExample() {
			var yes : RadioButton = new RadioButton();
			yes.label = "Yes";
			yes.value = true;
			yes.selected = true;
			addChild(yes);
			
			var no : RadioButton = new RadioButton();
			no.label = "No";
			no.value = false;
			no.moveTo(50, 0);
			addChild(no);
			
			var radioGroup : RadioGroup = new RadioGroup();
			radioGroup.setButtons([yes, no]);
			radioGroup.bindProperty(RadioGroup.BINDABLE_PROPERTY_SELECTED_VALUE, buttonSelected);

			_label = new Label();
			_label.text = "Yes is selected";
			_label.moveTo(0, 30);
			addChild(_label);
		}

		private function buttonSelected(value : Boolean) : void {
			if (_label) {
				var info : String = value ? "Yes" : "No";
				_label.text = (info + " is selected");
			}
		}
	}
}