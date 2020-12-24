//
// Copyright 2018 Vinicius Jorge Vendramini
//
// Licensed under the Hippocratic License, Version 2.1;
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://firstdonoharm.dev/version/2/1/license.md
//
// To the full extent allowed by law, this software comes "AS IS,"
// WITHOUT ANY WARRANTY, EXPRESS OR IMPLIED, and licensor and any other
// contributor shall not be liable to anyone for any damages or other
// liability arising from, out of, or in connection with the sotfware
// or this license, under any kind of legal claim.
// See the License for the specific language governing permissions and
// limitations under the License.
//

@testable import GryphonLib
import XCTest

class PerformanceTest: XCTestCase {
	static let toolchain: String? = nil
	static let swiftVersion: String = try! TranspilationContext.getVersionOfToolchain(toolchain)
	static let shouldUseSwiftSyntax = true

	func testSwiftSyntaxDecoder() {
		guard PerformanceTest.shouldUseSwiftSyntax else {
			return
		}

		let tests = TestUtilities.testCases

		let pathsAndContexts: List<(String, TranspilationContext)> = tests.map { testName in
			let testCasePath = TestUtilities.testCasesPath + testName + ".swift"
			let context = try! TranspilationContext(
				toolchainName: PerformanceTest.toolchain,
				indentationString: "\t",
				defaultsToFinal: testName.contains("-default-final"),
				isUsingSwiftSyntax: true,
				compilationArguments: TranspilationContext.SwiftCompilationArguments(
					absoluteFilePathsAndOtherArguments: [
						SupportingFile.gryphonTemplatesLibrary.absolutePath,
						testCasePath, ]),
				xcodeProjectPath: nil,
				target: nil)
			return (testCasePath, context)
		}

		measure {
			for (path, context) in pathsAndContexts {
				do {
					let decoder = try Compiler.generateSwiftSyntaxDecoder(
						fromSwiftFile: path,
						withContext: context)
					_ = try Compiler.generateGryphonRawASTUsingSwiftSyntax(
						usingFileDecoder: decoder,
						asMainFile: true,
						withContext: context)
				}
				catch let error {
					XCTFail("🚨 Test failed with error:\n\(error)")
				}
			}
		}
	}

	func testFirstTranspilationPasses() {
		let tests = TestUtilities.testCases

		let rawASTsAndContexts = tests.map
			{ (testName: String) -> (GryphonAST, TranspilationContext) in
				let testCasePath = TestUtilities.testCasesPath + testName + ".swift"
				let astDumpFilePath = SupportingFile.pathOfSwiftASTDumpFile(
					forSwiftFile: testName,
					swiftVersion: PerformanceTest.swiftVersion)
				let context = try! TranspilationContext(
					toolchainName: PerformanceTest.toolchain,
					indentationString: "\t",
					defaultsToFinal: testName.contains("-default-final"),
					isUsingSwiftSyntax: PerformanceTest.shouldUseSwiftSyntax,
					compilationArguments: TranspilationContext.SwiftCompilationArguments(
						absoluteFilePathsAndOtherArguments: [
							SupportingFile.gryphonTemplatesLibrary.absolutePath,
							testCasePath, ]),
					xcodeProjectPath: nil,
					target: nil)
				let rawAST = try! Compiler.transpileGryphonRawASTs(
					fromInputFiles: [testCasePath],
					fromASTDumpFiles: [astDumpFilePath],
					withContext: context)
				return (rawAST[0], context)
			}

		measure {
			for (rawAST, context) in rawASTsAndContexts {
				do {
					_ = try Compiler.generateGryphonASTAfterFirstPasses(
						fromGryphonRawAST: rawAST,
						withContext: context)
				}
				catch let error {
					XCTFail("🚨 Test failed with error:\n\(error)")
				}
			}
		}
	}

	func testSecondTranspilationPasses() {
		let tests = TestUtilities.testCases

		let semiRawASTsAndContexts = tests.map
			{ (testName: String) -> (GryphonAST, TranspilationContext) in
				let testCasePath = TestUtilities.testCasesPath + testName + ".swift"
				let astDumpFilePath = SupportingFile.pathOfSwiftASTDumpFile(
					forSwiftFile: testName,
					swiftVersion: PerformanceTest.swiftVersion)
				let context = try! TranspilationContext(
					toolchainName: PerformanceTest.toolchain,
					indentationString: "\t",
					defaultsToFinal: testName.contains("-default-final"),
					isUsingSwiftSyntax: PerformanceTest.shouldUseSwiftSyntax,
					compilationArguments: TranspilationContext.SwiftCompilationArguments(
						absoluteFilePathsAndOtherArguments: [
							SupportingFile.gryphonTemplatesLibrary.absolutePath,
							testCasePath, ]),
					xcodeProjectPath: nil,
					target: nil)
				let rawAST = try! Compiler.transpileGryphonRawASTs(
					fromInputFiles: [testCasePath],
					fromASTDumpFiles: [astDumpFilePath],
					withContext: context)
				let semiRawAST = try! Compiler.generateGryphonASTAfterFirstPasses(
					fromGryphonRawAST: rawAST[0],
					withContext: context)
				return (semiRawAST, context)
			}

		measure {
			for (semiRawAST, context) in semiRawASTsAndContexts {
				do {
					_ = try Compiler.generateGryphonASTAfterSecondPasses(
						fromGryphonRawAST: semiRawAST,
						withContext: context)
				}
				catch let error {
					XCTFail("🚨 Test failed with error:\n\(error)")
				}
			}
		}
	}

	func testAllTranspilationPasses() {
		let tests = TestUtilities.testCases

		let rawASTsAndContexts = tests.map
			{ (testName: String) -> (GryphonAST, TranspilationContext) in
				let testCasePath = TestUtilities.testCasesPath + testName + ".swift"
				let astDumpFilePath = SupportingFile.pathOfSwiftASTDumpFile(
					forSwiftFile: testName,
					swiftVersion: PerformanceTest.swiftVersion)
				let context = try! TranspilationContext(
					toolchainName: PerformanceTest.toolchain,
					indentationString: "\t",
					defaultsToFinal: testName.contains("-default-final"),
					isUsingSwiftSyntax: PerformanceTest.shouldUseSwiftSyntax,
					compilationArguments: TranspilationContext.SwiftCompilationArguments(
						absoluteFilePathsAndOtherArguments: [
							SupportingFile.gryphonTemplatesLibrary.absolutePath,
							testCasePath, ]),
					xcodeProjectPath: nil,
					target: nil)
				let rawAST = try! Compiler.transpileGryphonRawASTs(
					fromInputFiles: [testCasePath],
					fromASTDumpFiles: [astDumpFilePath],
					withContext: context)
				return (rawAST[0], context)
			}

		measure {
			for (rawAST, context) in rawASTsAndContexts {
				do {
					_ = try Compiler.generateGryphonAST(
						fromGryphonRawAST: rawAST,
						withContext: context)
				}
				catch let error {
					XCTFail("🚨 Test failed with error:\n\(error)")
				}
			}
		}
	}

	func testKotlinTranslator() {
		let tests = TestUtilities.testCases

		let astsAndContexts = tests.map
			{ (testName: String) -> (GryphonAST, TranspilationContext) in
				let testCasePath = TestUtilities.testCasesPath + testName + ".swift"
				let astDumpFilePath = SupportingFile.pathOfSwiftASTDumpFile(
					forSwiftFile: testName,
					swiftVersion: PerformanceTest.swiftVersion)
				let context = try! TranspilationContext(
					toolchainName: PerformanceTest.toolchain,
					indentationString: "\t",
					defaultsToFinal: testName.contains("-default-final"),
					isUsingSwiftSyntax: PerformanceTest.shouldUseSwiftSyntax,
					compilationArguments: TranspilationContext.SwiftCompilationArguments(
						absoluteFilePathsAndOtherArguments: [
							SupportingFile.gryphonTemplatesLibrary.absolutePath,
							testCasePath, ]),
					xcodeProjectPath: nil,
					target: nil)
				let rawAST = try! Compiler.transpileGryphonASTs(
					fromInputFiles: [testCasePath],
					fromASTDumpFiles: [astDumpFilePath],
					withContext: context)
				return (rawAST[0], context)
			}

		measure {
			for (ast, context) in astsAndContexts {
				do {
					_ = try Compiler.generateKotlinCode(
						fromGryphonAST: ast,
						withContext: context)
				}
				catch let error {
					XCTFail("🚨 Test failed with error:\n\(error)")
				}
			}
		}
	}

	func testFullTranspilation() {
		let tests = TestUtilities.testCases

		measure {
			for testName in tests {
				do {
					let testCasePath = TestUtilities.testCasesPath + testName + ".swift"
					let astDumpFilePath = SupportingFile.pathOfSwiftASTDumpFile(
						forSwiftFile: testCasePath,
						swiftVersion: PerformanceTest.swiftVersion)
					let context = try! TranspilationContext(
						toolchainName: PerformanceTest.toolchain,
						indentationString: "\t",
						defaultsToFinal: testName.contains("-default-final"),
						isUsingSwiftSyntax: PerformanceTest.shouldUseSwiftSyntax,
						compilationArguments: TranspilationContext.SwiftCompilationArguments(
							absoluteFilePathsAndOtherArguments: [
								SupportingFile.gryphonTemplatesLibrary.absolutePath,
								testCasePath, ]),
						xcodeProjectPath: nil,
						target: nil)
					_ = try Compiler.transpileKotlinCode(
						fromInputFiles: [testCasePath],
						fromASTDumpFiles: [astDumpFilePath],
						withContext: context)
				}
				catch let error {
					XCTFail("🚨 Test failed with error:\n\(error)")
				}
			}
		}
	}

	static var allTests = [
		("testFirstTranspilationPasses", testFirstTranspilationPasses),
		("testSecondTranspilationPasses", testSecondTranspilationPasses),
		("testAllTranspilationPasses", testAllTranspilationPasses),
		("testKotlinTranslator", testKotlinTranslator),
		("testFullTranspilation", testFullTranspilation),
	]

	override static func setUp() {
		do {
			try TestUtilities.updateASTsForTestCases()
		}
		catch let error {
			print(error)
			fatalError("Failed to update test files.")
		}
	}
}
