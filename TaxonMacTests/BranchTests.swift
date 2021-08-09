//
//  BranchTests.swift
//  TaxonMacTests
//
//  Created by Dylan Elliott on 6/8/21.
//

import XCTest
@testable import TaxonMac

class BranchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test() throws {
        let branch = Branch(value: "1", children: [:])
        _ = branch.addChild("2", at: [1])
        _ = branch.addChild("3", at: [2])
        
        XCTAssertEqual(branch.children, [
            1: Branch(value: "2", children: [:]),
            2: Branch(value: "3", children: [:])
        ])
    }
    
    func testTreeBit() {
        let branch = Branch(value: "1", children: [:])
        _ = branch.addChild("2", at: [1])
        _ = branch.addChild("3", at: [2])
        
        XCTAssertEqual(branch.treeBit, .branch("1", [
            .leaf("2"), .leaf("3")
        ]))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
