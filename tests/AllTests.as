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
package {
	import flexunit.framework.TestSuite;

	import com.sibirjak.asdpc.core.AllTests;
	import com.sibirjak.asdpc.listview.AllTests;
	import com.sibirjak.asdpc.treeview.AllTests;

	/**
	 * @author jes 11.02.2009
	 */
	public class AllTests {

		public static function getAllTests() : TestSuite {
			
			var testSuite : TestSuite = new TestSuite();

			var coreTests : com.sibirjak.asdpc.core.AllTests = new com.sibirjak.asdpc.core.AllTests();
			testSuite.addTest(coreTests);

			var treeViewTests : com.sibirjak.asdpc.treeview.AllTests = new com.sibirjak.asdpc.treeview.AllTests();
			testSuite.addTest(treeViewTests);

			var listViewTests : com.sibirjak.asdpc.listview.AllTests = new com.sibirjak.asdpc.listview.AllTests();
			testSuite.addTest(listViewTests);

			return testSuite;

		}
	}
}
