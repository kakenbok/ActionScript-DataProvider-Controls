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
package com.sibirjak.asdpc.listview.interfacedemo.windows.configuration {
	import com.sibirjak.asdpc.common.interfacedemo.ControlPanelBase;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.listview.IListView;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;

	/**
	 * @author jes 19.01.2010
	 */
	public class BehaviourTab extends ControlPanelBase {

		/* internal */
		private const SELECTION_GROUP : String = "selectionGroup";
		private const DESELECTION_PROPERTIES : String = "deselectionProperties";
		private const SELECTION_EVENT_PROPERTIES : String = "selectionEventProperties";

		public function BehaviourTab(view : IView) {
			super.view = view;
		}

		override protected function draw() : void {
			
			addChild(
			
				document(

					headline("Selection"),
					
					hLayout(
					
						label("Multiplicity"),
					
						radioGroup("selectModeGroup", setSelectionMode),
						
						radioButton({
							group: "selectModeGroup",
							value: "Select",
							selected: true,
							label: "Singleselect",
							tip: "Single item selectable"
						}),
					
						radioButton({
							group: "selectModeGroup",
							value: "Multiselect",
							selected: false,
							label: "Multiselect",
							tip: "Multiple items selectable"
						})

					),

					hLayout(
					
						SELECTION_EVENT_PROPERTIES,
						
						label("Event"),
						
						hLayout(
						
							radioGroup("selectionEvent", setSelectionEvent),
							
							radioButton({
								group: "selectionEvent",
								value: false,
								selected: true,
								label: "Mouse down",
								tip: "Mouse down selects or deselects item"
							}),
						
							radioButton({
								group: "selectionEvent",
								value: true,
								selected: false,
								label: "Click",
								tip: "Click selects or deselects item"
							})
	
						)
					),

					vLayout(
					
						SELECTION_GROUP,

						hLayout(
							
							checkBox({
								selected: true,
								label: "Select",
								tip: "Enable item selection",
								change: setSelect
							})

						),
	
						hLayout(
						
							checkBox({
								selected: true,
								label: "Deselect",
								tip: "Enable item deselection",
								change: setDeselect
							}),
							
							hLayout(
							
								DESELECTION_PROPERTIES,
							
								checkBox({
									selected: true,
									label: "Ctrl key",
									tip: "Ctrl key needs to be pressed for a deselection",
									change: setDeselectViaClick
								})

							)
						)

					)
					
				)
			
			);
			
		}

		override protected function viewVisibilityChanged() : void {
			getView(SELECTION_GROUP).x = 2;
		}

		/*
		 * Binding events
		 */

		private function setSelect(select : Boolean) : void {
			IListView(_view).select = select;
			setViewVisibility(SELECTION_EVENT_PROPERTIES, IListView(_view).select || IListView(_view).deselect);
		}

		private function setSelectionMode(mode : String) : void {
			IListView(_view).multiselect = mode == "Multiselect";
		}

		private function setDeselect(deselect : Boolean) : void {
			IListView(_view).deselect = deselect;

			setViewVisibility(DESELECTION_PROPERTIES, deselect);
			setViewVisibility(SELECTION_EVENT_PROPERTIES, IListView(_view).select || IListView(_view).deselect);
		}

		private function setDeselectViaClick(viaClick : Boolean) : void {
			_view.setStyle(ListItemRenderer.style.ctrlKeyDeselection, viaClick);
		}

		private function setSelectionEvent(clickSelection : Boolean) : void {
			_view.setStyle(ListItemRenderer.style.clickSelection, clickSelection);
		}

	}
}
