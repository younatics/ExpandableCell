//
//  ExpandableProcessorTests.swift
//  ExpandableCellTests
//
//  Deterministic unit tests for the index-path bookkeeping that powers
//  expand/collapse. These exercise ExpandableProcessor directly (no UI host),
//  so they run headlessly on the simulator and pin the library's core logic.
//

import XCTest
import UIKit
@testable import ExpandableCell

@MainActor
final class ExpandableProcessorTests: XCTestCase {

    private func makeCells(_ count: Int) -> [UITableViewCell] {
        (0..<count).map { _ in UITableViewCell() }
    }

    func testInsertIncreasesExpandedRowCount() {
        let processor = ExpandableProcessor()
        XCTAssertEqual(processor.numberOfExpandedRowsInSection(section: 0), 0)

        let inserted = processor.insert(
            indexPath: IndexPath(row: 1, section: 0),
            expandedCells: makeCells(2),
            expandedHeights: [44, 44],
            isExpandCellSelectable: false
        )

        XCTAssertTrue(inserted)
        XCTAssertEqual(processor.numberOfExpandedRowsInSection(section: 0), 2)
    }

    func testExpandedRowsAreTrackedAndParentIsNotExpandable() {
        let processor = ExpandableProcessor()
        let cells = makeCells(2)
        _ = processor.insert(
            indexPath: IndexPath(row: 1, section: 0),
            expandedCells: cells,
            expandedHeights: [44, 88],
            isExpandCellSelectable: false
        )

        // The opened parent row can no longer be expanded again.
        XCTAssertFalse(processor.isExpandable(at: IndexPath(row: 1, section: 0)))

        // Rows immediately after the parent are the expanded rows (row + i + 1).
        XCTAssertTrue(processor.isExpandedCell(at: IndexPath(row: 2, section: 0)).isExpandedCell)
        XCTAssertTrue(processor.isExpandedCell(at: IndexPath(row: 3, section: 0)).isExpandedCell)
        XCTAssertFalse(processor.isExpandedCell(at: IndexPath(row: 1, section: 0)).isExpandedCell)

        // Expanded cell/height lookups return exactly what was inserted, in order.
        XCTAssertIdentical(processor.expandedCell(at: IndexPath(row: 2, section: 0)), cells[0])
        XCTAssertIdentical(processor.expandedCell(at: IndexPath(row: 3, section: 0)), cells[1])
        XCTAssertEqual(processor.expandedHeight(at: IndexPath(row: 2, section: 0)), 44)
        XCTAssertEqual(processor.expandedHeight(at: IndexPath(row: 3, section: 0)), 88)
    }

    func testIndexPathsWhereReturnsExpandedIndexPaths() {
        let processor = ExpandableProcessor()
        _ = processor.insert(
            indexPath: IndexPath(row: 1, section: 0),
            expandedCells: makeCells(2),
            expandedHeights: [10, 10],
            isExpandCellSelectable: false
        )

        XCTAssertEqual(
            processor.indexPathsWhere(indexPath: IndexPath(row: 1, section: 0)),
            [IndexPath(row: 2, section: 0), IndexPath(row: 3, section: 0)]
        )
    }

    func testOriginalMapsDisplayRowBackToDataRow() {
        let processor = ExpandableProcessor()
        _ = processor.insert(
            indexPath: IndexPath(row: 1, section: 0),
            expandedCells: makeCells(2),
            expandedHeights: [10, 10],
            isExpandCellSelectable: false
        )

        // The parent row itself is unchanged...
        XCTAssertEqual(processor.original(indexPath: IndexPath(row: 1, section: 0)), IndexPath(row: 1, section: 0))
        // ...but a display row after the 2 inserted rows maps back by -2.
        XCTAssertEqual(processor.original(indexPath: IndexPath(row: 4, section: 0)), IndexPath(row: 2, section: 0))
    }

    func testDeleteRemovesExpansionAndRecordsRemovedIndexPaths() {
        let processor = ExpandableProcessor()
        _ = processor.insert(
            indexPath: IndexPath(row: 1, section: 0),
            expandedCells: makeCells(2),
            expandedHeights: [10, 10],
            isExpandCellSelectable: false
        )

        processor.delete(indexPath: IndexPath(row: 1, section: 0))

        XCTAssertEqual(processor.numberOfExpandedRowsInSection(section: 0), 0)
        XCTAssertTrue(processor.isExpandable(at: IndexPath(row: 1, section: 0)))
        XCTAssertEqual(
            processor.willRemovedIndexPaths,
            [IndexPath(row: 2, section: 0), IndexPath(row: 3, section: 0)]
        )
    }

    func testIsSelectablePropagatesInsertedFlag() {
        let processor = ExpandableProcessor()
        _ = processor.insert(
            indexPath: IndexPath(row: 0, section: 0),
            expandedCells: makeCells(1),
            expandedHeights: [10],
            isExpandCellSelectable: true
        )

        // The opened parent reports the flag it was inserted with,
        // regardless of the caller's default.
        XCTAssertTrue(processor.isSelectable(at: IndexPath(row: 0, section: 0), defaultValue: false))
    }

    func testDeleteAllIndexPathsClearsEverySection() {
        let processor = ExpandableProcessor()
        _ = processor.insert(
            indexPath: IndexPath(row: 0, section: 0),
            expandedCells: makeCells(1),
            expandedHeights: [10],
            isExpandCellSelectable: false
        )
        _ = processor.insert(
            indexPath: IndexPath(row: 0, section: 1),
            expandedCells: makeCells(2),
            expandedHeights: [10, 10],
            isExpandCellSelectable: false
        )

        let result = processor.deleteAllIndexPaths()

        XCTAssertEqual(result.expandedIndexPaths.count, 3)
        XCTAssertTrue(processor.expandableDatasPerSection.isEmpty)
        XCTAssertEqual(processor.numberOfExpandedRowsInSection(section: 0), 0)
        XCTAssertEqual(processor.numberOfExpandedRowsInSection(section: 1), 0)
    }
}
