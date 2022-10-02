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
//    func testEnPassant() throws {
//        var fields = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
//        fields[7][4] = Piece(color: .white, type: .pawn(0))
//        fields[6][6] = Piece(color: .black, type: .pawn(0))
//        var current = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
//        current[7][4] = Piece(color: .white, type: .pawn(0))
//        current[6][4] = Piece(color: .black, type: .pawn(0))
//        let previous = GameState(previous: nil,
//                                 board: Board(fields: fields),
//                                 selectedPiece: nil,
//                                 turn: .white, expectation: ., checkState: <#T##CheckState#>)
//        
//        
//        let actions = generator.potentialActions(piece: Piece(color: .white, type: .pawn(0)),
//                                                 board: Board(fields: current),
//                                                 previousBoard: Board(fields: fields))
//        let action = actions.first(where: { $0.mainMove.to == Field(6, 5) })
//        XCTAssertEqual(actions.count, 2)
//        XCTAssertEqual(action?.mainMove.from, Field(7, 4))
//        XCTAssertEqual(action?.mainMove.to, Field(6, 5))
//        XCTAssertEqual(action?.piecesToRemove, [Piece(color: .black, type: .pawn(0))])
//    }
}
