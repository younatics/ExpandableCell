//
//  MemoryLeakTest.swift
//  ExpandableCellTests
//
//  Created by Lena Brusilovski on 17/10/2018.
//  Copyright © 2018 SeungyounYi. All rights reserved.
//

import XCTest
@testable import ExpandableCellDemo
class MemoryLeakTest: XCTestCase {

    weak var viewController: ViewController?
    weak var navigationController: UINavigationController?
    override func setUp() {
        if let nav = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController) {
            self.navigationController = nav
            self.viewController = nav.visibleViewController as? ViewController
        }
        
        XCTAssertNotNil(self.navigationController)
        XCTAssertNotNil(self.viewController)
    }

    override func tearDown() {
        self.viewController = nil
        self.navigationController = nil
    }

    func testNotLeakingExpandableDelegate() {
        XCTAssertNotNil(self.viewController?.tableView.expandableDelegate)
        self.viewController?.performSegue(withIdentifier: "replace", sender: nil)
        let expectation = self.expectation(description: "wait for view controller to load")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let visibleVC = self.navigationController?.visibleViewController
            XCTAssertTrue(visibleVC != self.viewController)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
        XCTAssertNil(self.viewController?.tableView.expandableDelegate)
        
    }


}
