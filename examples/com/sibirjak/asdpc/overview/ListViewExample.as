package com.sibirjak.asdpc.overview {
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.listview.ListItemEvent;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.textfield.Label;

	public class ListViewExample extends Example {
		private var _label : Label;

		public function ListViewExample() {
			var listView : ListView = new ListView();
			listView.setSize(160, 120);
			listView.dataSource = [
				"Item1", "Item2", "Item3", "Item4",
				"Item5", "Item6", "Item7", "Item8",
				"Item9", "Item10"
			];
			listView.addEventListener(ListItemEvent.SELECTION_CHANGED, selectHandler);
			addChild(listView);
			
			_label = new Label();
			_label.text = "No item selected";
			_label.moveTo(0, 130);
			addChild(_label);
		}
		
		private function selectHandler(event : ListItemEvent) : void {
			if (event.selected) {
				_label.text = event.item + " selected";
			} else {
				_label.text = "No item selected";
			}
		}
	}
}