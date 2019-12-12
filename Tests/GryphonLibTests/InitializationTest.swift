//
// Copyright 2018 Vinícius Jorge Vendramini
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// gryphon output: Bootstrap/InitializationTest.kt

#if !IS_DUMPING_ASTS
@testable import GryphonLib
import XCTest
#endif

class InitializationTest: XCTestCase {
	// declaration: constructor(): super() { }

	public func getClassName() -> String { // annotation: override
		return "InitializationTest"
	}

	override public func runAllTests() { // annotation: override
		testInitialization()
	}

	static var allTests = [ // kotlin: ignore
		("testInitialization", testInitialization),
	]

	// MARK: - Tests
	func testInitialization() {
		// Delete old folder
		Utilities.deleteFolder(at: ".gryphon")

		// Create a new folder
		try! Driver.run(withArguments: ["init", "-no-xcode"])

		// Check the new folder's contents are right
		do {
			let templatesFileContents =
				try Utilities.readFile(".gryphon/StandardLibrary.template.swift")
			let xctestFileContents =
				try Utilities.readFile(".gryphon/GryphonXCTest.swift")
			let scriptFileContents =
				try Utilities.readFile(".gryphon/scripts/mapKotlinErrorsToSwift.swift")

			if templatesFileContents != standardLibraryTemplateFileContents {
				XCTFail("Library templates file's contents are wrong.")
			}
			if xctestFileContents != gryphonXCTestFileContents {
				XCTFail("Gryphon's XCTest file's contents are wrong.")
			}
			if scriptFileContents != kotlinErrorMapScriptFileContents {
				XCTFail("Error map script contents file's contents are wrong.")
			}

			//
			// Test cleanup
			try! Driver.run(withArguments: ["clean"])
			XCTAssertFalse(Utilities.fileExists(at: ".gryphon/StandardLibrary.template.swift"))

			// Create the folder again so other testing and development can continue
			try! Driver.run(withArguments: ["init", "-no-xcode"])
		}
		catch let error {
			XCTFail("Gryphon -init failed to read file: \(error)")
			return
		}
	}
}
