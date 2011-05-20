package com.sibirjak.asdpc.treeview {
	import com.sibirjak.asdpc.common.Example;
	import com.sibirjak.asdpc.treeview.renderer.DirectoryIcon;
	import com.sibirjak.asdpc.treeview.renderer.DisclosureButton;

	public class DynamicIconExample extends Example {

		[Embed(source="assets/plus.png")]
		private var _plus : Class;
		[Embed(source="assets/minus.png")]
		private var _minus : Class;

		[Embed(source="assets/document.png")]
		private var _document : Class;
		[Embed(source="assets/folder.png")]
		private var _folder : Class;
		[Embed(source="assets/folder_open.png")]
		private var _folder_open : Class;

		[Embed(source="assets/as.png")]
		private var _as : Class;
		[Embed(source="assets/html.png")]
		private var _html : Class;
		[Embed(source="assets/php.png")]
		private var _php : Class;
		[Embed(source="assets/pdf.png")]
		private var _pdf : Class;
		[Embed(source="assets/htdocs.png")]
		private var _htdocs : Class;
		[Embed(source="assets/htdocs_open.png")]
		private var _htdocs_open : Class;

		public function DynamicIconExample() {

			var treeView : TreeView = new TreeView();
			treeView.setSize(260, 160);

			treeView.dataSource = new XML(
				<folder name="C:\\">
					<folder name="documents">
						<file name="serialz.txt" />
						<file name="asdoc.pdf" />
						<file name="images.zip" />
					</folder>
					<folder name="htdocs">
						<file name="index.php" />
						<file name="contact.html" />
						<file name="popup.html" />
					</folder>
					<file name="manual.pdf" />
					<file name="asdpc.exe" />
				</folder>
			);

			// disclosure buttons
			
			treeView.setStyles([
				DisclosureButton.style_collapsedIconSkin, _plus,
				DisclosureButton.style_expandedIconSkin, _minus,
				DisclosureButton.style_size, 16]);

			// default icons
			
			treeView.setStyles([
				DirectoryIcon.style.branchClosedIconSkin, _folder,
				DirectoryIcon.style.branchOpenIconSkin, _folder_open,
				DirectoryIcon.style.leafIconSkin, _document
			]);

			// dynamic icons
			
			var iconFunction : Function = function (data : TreeNodeData) : Class {
				var label : String = XML(data.item).attribute("name");

				if (label.indexOf(".as") > -1) return _as;
				else if (label.indexOf(".php") > -1) return _php;
				else if (label.indexOf(".pdf") > -1) return _pdf;
				else if (label.indexOf(".html") > -1) return _html;
				else if (label.indexOf("htdocs") > -1) {
					if (data.isExpanded) return _htdocs_open;
					return _htdocs;
				}
				return null; // else use default icon
			};

			treeView.setStyle(DirectoryIcon.style.iconSkinFunction, iconFunction);
			treeView.expandNodeAt(0);
			addChild(treeView);
		}
	}
}