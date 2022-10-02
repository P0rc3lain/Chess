//
//  FieldParser+Tests.swift
//  ChessTests
//
//  Created by Mateusz Stompór on 13/09/2022.
//

import XCTest
@testable import Chess

final class FieldParserTests: XCTestCase {
    let parser = FieldParser()
    func testStringify() throws {
        XCTAssertEqual(parser.dump(field: Field(0, 0 )), "a1")
    }
    func testMinimalRange() throws {
        let field = parser.create(literal: "a1")
        XCTAssertEqual(field?.row, 0)
        XCTAssertEqual(field?.column, 0)
    }
    func testMaximalRange() throws {
        let field = parser.create(literal: "h8")
        XCTAssertEqual(field?.row, 7)
        XCTAssertEqual(field?.column, 7)
    }
    func testOrder() throws {
        let field = parser.create(literal: "a8")
      XCTAssertEqual(field?.row, 0)
      XCTAssertEqual(field?.column, 7)
    }
    func testRowOutOfBounds() throws {
        XCTAssertNil(parser.create(literal: "i8"))
    }
    func testColumnOutOfBounds() throws {
        XCTAssertNil(parser.create(literal: "a9"))
    }
    func testSingleLetter() throws {
        XCTAssertNil(parser.create(literal: "a"))
    }
    func testEmptyString() throws {
        XCTAssertNil(parser.create(literal: ""))
    }
    func testTooManyLetters() throws {
        XCTAssertNil(parser.create(literal: "a88"))
    }
}
