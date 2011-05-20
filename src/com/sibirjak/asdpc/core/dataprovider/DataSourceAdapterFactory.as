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
package com.sibirjak.asdpc.core.dataprovider {
	import com.sibirjak.asdpc.core.dataprovider.adapter.ArrayAdapter;
	import com.sibirjak.asdpc.core.dataprovider.adapter.GenericAdapter;
	import com.sibirjak.asdpc.core.dataprovider.adapter.ListAdapter;
	import com.sibirjak.asdpc.core.dataprovider.adapter.MapAdapter;
	import com.sibirjak.asdpc.core.dataprovider.adapter.SetAdapter;
	import com.sibirjak.asdpc.core.dataprovider.adapter.XMLAdapter;

	import org.as3commons.collections.framework.IDataProvider;
	import org.as3commons.collections.framework.IList;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.ISet;

	/**
	 * Factory to create an adapter to a non IDataProvider data source.  
	 * 
	 * @author jes 03.08.2009
	 */
	public class DataSourceAdapterFactory {

		/**
		 * Creates an adapter to a non IDataProvider data source.
		 * 
		 * <p>Supports by default the following types:</p>
		 * 
		 * <ul>
		 * <li>IDataProvider - simply returned, no adapter is created.</li>
		 * <li>IMap - a MapAdapter is returned. The MapAdapter internally maintains a Map item to index map.</li>
		 * <li>ISet - a SetAdapter is returned. The SetAdapter internally maintains a Set item to index map.</li>
		 * <li>IList - a ListAdapter is returned.</li>
		 * <li>Array - an ArrayAdapter is returned.</li>
		 * <li>XML - an XMLAdapter is returned.</li>
		 * <li>any other type - a GenericAdapter is returned.</li>
		 * </ul>
		 * 
		 * <p>The method accepts and evaluates a custom adapter factory function,
		 * which can be passed to create adapters for types not recognised here or
		 * to create different adapters for types handled by this method.</p>
		 * 
		 * @param dataSource The data source to adapt.
		 * @param dataSourceAdapterFunction A custom factory function.
		 * @return An adapter to the given data source or the data source itself, if it already implements IDataProvider.
		 */
		public static function getAdapter(dataSource : *, dataSourceAdapterFunction : Function = null) : IDataProvider {
			var dataProvider : IDataProvider;
			
			if (dataSourceAdapterFunction != null) {
				dataProvider = dataSourceAdapterFunction(dataSource);
			}
			
			if (!dataProvider) {
				if (dataSource is IDataProvider) {
					
					// exception for a list that currently does not dispatch
					// data provider events TODO
					
					if (dataSource is IList) {
						dataProvider = new ListAdapter(dataSource);
						
					} else {
						dataProvider = dataSource;
					}
					
				} else {
					
					if (dataSource is IMap) {
						dataProvider = new MapAdapter(dataSource);
	
					} else if (dataSource is ISet) {
						dataProvider = new SetAdapter(dataSource);
	
					} else if (dataSource is IList) {
						dataProvider = new ListAdapter(dataSource);
	
					} else if (dataSource is Array) {
						dataProvider = new ArrayAdapter(dataSource);
	
					} else if (dataSource is XML) {
						dataProvider = new XMLAdapter(dataSource);
	
					} else {
						dataProvider = new GenericAdapter(dataSource);
	
					}
				}
			}
			
			return dataProvider;
		}

	}
}
