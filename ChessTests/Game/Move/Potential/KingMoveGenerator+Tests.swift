//
//  KingMoveGenerator+Tests.swift
//  ChessTests
//
//  Created by Mateusz Stompór on 02/10/2022.
//

import XCTest
@testable import Chess

final class KingMoveGeneratorTests: XCTestCase {
    let generator = KingMoveGenerator()
    func testLongCastling() throws {
        var fields = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
        let king = Piece(color: .white, type: .king)
        fields[3][0] = king
        fields[7][0] = Piece(color: .white, type: .rook(0))
        let state = GameState(previous: nil,
                              board: Board(fields: fields),
                              selectedPiece: Piece(color: .white, type: .king),
                              turn: .white,
                              expectation: .piece,
                              checkState: .noCheck)
        let actions = generator.potentialActions(piece: king, state: state)
        XCTAssertEqual(actions.count, 6)
    }
    func testShortCastling() throws {
        var fields = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
        let king = Piece(color: .white, type: .king)
        fields[3][0] = king
        fields[0][0] = Piece(color: .white, type: .rook(1))
        let state = GameState(previous: nil,
                              board: Board(fields: fields),
                              selectedPiece: Piece(color: .white, type: .king),
                              turn: .white,
                              expectation: .piece,
                              checkState: .noCheck)
        let actions = generator.potentialActions(piece: king, state: state)
        XCTAssertEqual(actions.count, 6)
    }
}
