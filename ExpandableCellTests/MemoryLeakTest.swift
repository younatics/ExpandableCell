//
//  MemoryLeakTest.swift
//  ExpandableCellTests
//
//  Created by Lena Brusilovski on 17/10/2018.
//  Copyright © 2018 SeungyounYi. All rights reserved.
//
//  Verifies `autoReleaseDelegate`: when the table view leaves its window it
//  drops the strong `expandableDelegate` reference, avoiding a retain cycle.
//  The original test drove this through the demo app + a segue + a timed wait,
//  which was flaky. This exercises the exact `willMove(toWindow:)` behavior
//  directly, so it is deterministic and needs no app host.
//

import XCTest
import UIKit
@testable import ExpandableCell

@MainActor
class MemoryLeakTest: XCTestCase {

    func testLeavingWindowReleasesDelegateByDefault() {
        let tableView = ExpandableTableView()
        let delegate = StubExpandableDelegate()
        tableView.expandableDelegate = delegate
        XCTAssertNotNil(tableView.expandableDelegate)

        // Simulate the table view being removed from the window hierarchy.
        tableView.willMove(toWindow: nil)

        XCTAssertNil(tableView.expandableDelegate, "autoReleaseDelegate should nil the delegate on window removal")
    }

    func testMovingToWindowKeepsDelegate() {
        let tableView = ExpandableTableView()
        let delegate = StubExpandableDelegate()
        tableView.expandableDelegate = delegate

        // Moving *into* a window must not clear the delegate.
        tableView.willMove(toWindow: UIWindow())

        XCTAssertNotNil(tableView.expandableDelegate)
    }

    func testAutoReleaseDelegateDisabledKeepsDelegate() {
        let tableView = ExpandableTableView()
        tableView.autoReleaseDelegate = false
        let delegate = StubExpandableDelegate()
        tableView.expandableDelegate = delegate

        tableView.willMove(toWindow: nil)

        XCTAssertNotNil(tableView.expandableDelegate, "delegate must survive window removal when autoReleaseDelegate is off")
    }

    func testDelegateIsHeldWeaklyElsewhereAndDeallocates() {
        weak var weakDelegate: StubExpandableDelegate?
        autoreleasepool {
            let tableView = ExpandableTableView()
            let delegate = StubExpandableDelegate()
            weakDelegate = delegate
            tableView.expandableDelegate = delegate
            tableView.willMove(toWindow: nil)
        }
        // Once the table view released it and the local ref is gone, nothing
        // should keep the delegate alive.
        XCTAssertNil(weakDelegate)
    }
}

/// Minimal `ExpandableDelegate` conformance for tests. Only the required
/// methods need bodies; the rest come from the protocol's default extension.
@MainActor
private final class StubExpandableDelegate: NSObject, ExpandableDelegate {
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        nil
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        nil
    }
}
