//
//  Field+Tests.swift
//  ChessTests
//
//  Created by Mateusz Stompór on 13/09/2022.
//

import XCTest
@testable import Chess

//final class FieldTests: XCTestCase {
//    func testStringify() throws {
//        XCTAssertEqual(String(describing: Field(0, 0)), "a1")
//    }
//    func testMinimalRange() throws {
//        let field = Field(literal: "a1")
//        XCTAssertEqual(field?.row, 0)
//        XCTAssertEqual(field?.column, 0)
//    }
//    func testMaximalRange() throws {
//        let field = Field(literal: "h8")
//        XCTAssertEqual(field?.row, 7)
//        XCTAssertEqual(field?.column, 7)
//    }
//    func testOrder() throws {
//      let field = Field(literal: "a8")
//      XCTAssertEqual(field?.row, 0)
//      XCTAssertEqual(field?.column, 7)
//    }
//    func testRowOutOfBounds() throws {
//      let field = Field(literal: "a8")
//      XCTAssertEqual(field?.row, 0)
//      XCTAssertEqual(field?.column, 7)
//    }
//    func testColumnOutOfBounds() throws {
//        let field = Field(literal: "a8")
//        XCTAssertEqual(field?.row, 0)
//        XCTAssertEqual(field?.column, 7)
//    }
//    func testSingleLetter() throws {
//        XCTAssertNil(Field(literal: "a"))
//    }
//    func testEmptyString() throws {
//        XCTAssertNil(Field(literal: ""))
//    }
//    func testTooManyLetters() throws {
//        XCTAssertNil(Field(literal: "a88"))
//    }
//}
