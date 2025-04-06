//
//  PawnMoveGenerator+Tests.swift
//  ChessTests
//
//  Created by Mateusz Stompór on 02/10/2022.
//

import XCTest
@testable import Chess

final class PawnMoveGeneratorTests: XCTestCase {
    let generator = PawnMoveGenerator()
    func testInitialStatePawn() throws {
        let piece = Piece(color: .white, type: .pawn(0))
        let actions = generator.potentialActions(piece: piece, state: GameState(previous: nil,
                                                                                board: .initial,
                                                                                selectedPiece: piece,
                                                                                turn: .white,
                                                                                expectation: .field,
                                                                                checkState: .noCheck))
        XCTAssertEqual(actions.count, 2)
        XCTAssertEqual(actions[0].mainMove.from, Field(7, 1))
        XCTAssertEqual(actions[0].mainMove.to, Field(7, 2))
        XCTAssertTrue(actions[0].piecesToAdd.isEmpty)
        XCTAssertTrue(actions[0].piecesToRemove.isEmpty)
        XCTAssertTrue(actions[0].sideEffects.isEmpty)
        XCTAssertEqual(actions[1].mainMove.from, Field(7, 1))
        XCTAssertEqual(actions[1].mainMove.to, Field(7, 3))
        XCTAssertTrue(actions[1].piecesToAdd.isEmpty)
        XCTAssertTrue(actions[1].piecesToRemove.isEmpty)
        XCTAssertTrue(actions[1].sideEffects.isEmpty)
    }
}
