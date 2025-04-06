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
    let interactor = BoardInteractor()

    func testCheck() throws {
        var fields = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
        fields[0][0] = Piece(color: .white, type: .king)
        fields[7][7] = Piece(color: .black, type: .king)
        fields[1][1] = Piece(color: .black, type: .pawn(0))
        let state = GameState(previous: nil,
                              board: Board(fields: fields),
                              selectedPiece: Piece(color: .black, type: .pawn(0)),
                              turn: .black,
                              expectation: .field,
                              checkState: .check)
        let whiteCheckingMoves = generator.checkingMoves(color: .white, state: state)
        let blackCheckingMoves = generator.checkingMoves(color: .black, state: state)
        XCTAssertEqual(blackCheckingMoves.count, 4)
        XCTAssertEqual(blackCheckingMoves[0].mainMove.from, Field(1, 1))
        XCTAssertEqual(blackCheckingMoves[0].mainMove.to, Field(0, 0))
        XCTAssertTrue(whiteCheckingMoves.isEmpty)
    }
}
