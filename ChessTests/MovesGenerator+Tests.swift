//
//  MovesGenerator+Tests.swift
//  ChessTests
//
//  Created by Mateusz Stompór on 13/09/2022.
//

import XCTest
@testable import Chess

final class MovesGeneratorTests: XCTestCase {
    let generator = MovesGenerator()
    func testInitialStatePawn() throws {
        let piece = Piece(color: .white, type: .pawn(0))
        let actions = generator.pawnActionsToPerform(piece: piece, board: .initial)
        XCTAssertEqual(actions.count, 2)
        XCTAssertEqual(actions[0].mainMove, Move(who: piece, from: Field(7, 1), to: Field(7, 2)))
        XCTAssertTrue(actions[0].piecesToAdd.isEmpty)
        XCTAssertTrue(actions[0].piecesToRemove.isEmpty)
        XCTAssertTrue(actions[0].sideEffects.isEmpty)
        XCTAssertEqual(actions[1].mainMove, Move(who: piece, from: Field(7, 1), to: Field(7, 3)))
        XCTAssertTrue(actions[1].piecesToAdd.isEmpty)
        XCTAssertTrue(actions[1].piecesToRemove.isEmpty)
        XCTAssertTrue(actions[1].sideEffects.isEmpty)
    }
}
