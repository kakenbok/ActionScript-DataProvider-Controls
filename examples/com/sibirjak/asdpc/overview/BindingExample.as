package com.sibirjak.asdpc.overview {
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;

	public class BindingExample extends Example {
		public function BindingExample() {
			var checkBox : CheckBox = new CheckBox();
			checkBox.label = "Hidden";
			checkBox.selectedLabel = "Visible";
			checkBox.moveTo(0, 1);
			addChild(checkBox);
			
			var label : Label = new Label();
			label.text = "I am visible";
			label.moveTo(80, 0);
			addChild(label);

			checkBox.bindProperty("selected", label, "visible");
		}
	}
}