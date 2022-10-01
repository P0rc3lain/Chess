//
//  MovesGenerator+Tests.swift
//  ChessTests
//
//  Created by Mateusz Stompór on 13/09/2022.
//

import XCTest
@testable import Chess

final class MovesGeneratorTests: XCTestCase {
//    let generator = MovesGenerator()
//    let interactor = BoardInteractor()
//    func testInitialStatePawn() throws {
//        let piece = Piece(color: .white, type: .pawn(0))
//        let actions = generator.pawnActionsToPerform(piece: piece,
//                                                     board: .initial,
//                                                     previousBoard: nil)
//        XCTAssertEqual(actions.count, 2)
//        XCTAssertEqual(actions[0].mainMove.from, Field(7, 1))
//        XCTAssertEqual(actions[0].mainMove.to, Field(7, 2))
//        XCTAssertTrue(actions[0].piecesToAdd.isEmpty)
//        XCTAssertTrue(actions[0].piecesToRemove.isEmpty)
//        XCTAssertTrue(actions[0].sideEffects.isEmpty)
//        XCTAssertEqual(actions[1].mainMove.from, Field(7, 1))
//        XCTAssertEqual(actions[1].mainMove.to, Field(7, 3))
//        XCTAssertTrue(actions[1].piecesToAdd.isEmpty)
//        XCTAssertTrue(actions[1].piecesToRemove.isEmpty)
//        XCTAssertTrue(actions[1].sideEffects.isEmpty)
//    }
//    func testNotMoved() throws {
//        let state = GameState.initial
//        XCTAssertFalse(generator.wasEverMoved(piece: Piece(color: .white, type: .king), state: state))
//    }
//    func testMoved() throws {
//        let state = GameState.initial
//        let newBoard = interactor.perform(board: state.board, actions: [Action(mainMove: (Field(0, 1), Field(0, 3)),
//                                                                               sideEffects: [],
//                                                                               piecesToAdd: [],
//                                                                               piecesToRemove: [])])
//        let newState = GameState(previous: state,
//                                 board: newBoard,
//                                 selectedPiece: nil,
//                                 turn: state.turn.toggled(),
//                                 expectation: .piecePick)
//        XCTAssertTrue(generator.wasEverMoved(piece: Piece(color: .white, type: .pawn(7)), state: newState))
//    }
//    func testEnPassant() throws {
//        var fields = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
//        fields[7][4] = Piece(color: .white, type: .pawn(0))
//        fields[6][6] = Piece(color: .black, type: .pawn(0))
//        var current = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
//        current[7][4] = Piece(color: .white, type: .pawn(0))
//        current[6][4] = Piece(color: .black, type: .pawn(0))
//        let actions = generator.pawnActionsToPerform(piece: Piece(color: .white, type: .pawn(0)),
//                                                     board: Board(fields: current),
//                                                     previousBoard: Board(fields: fields))
//        let action = actions.first(where: { $0.mainMove.to == Field(6, 5) })
//        XCTAssertEqual(actions.count, 2)
//        XCTAssertEqual(action?.mainMove.from, Field(7, 4))
//        XCTAssertEqual(action?.mainMove.to, Field(6, 5))
//        XCTAssertEqual(action?.piecesToRemove, [Piece(color: .black, type: .pawn(0))])
//    }
//    func testCheck() throws {
//        var fields = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
//        fields[0][0] = Piece(color: .white, type: .king)
//        fields[7][7] = Piece(color: .black, type: .king)
//        fields[1][1] = Piece(color: .black, type: .pawn(0))
//        let state = GameState(previous: nil,
//                              board: Board(fields: fields),
//                              selectedPiece: Piece(color: .black, type: .pawn(0)),
//                              turn: .black,
//                              expectation: .fieldPick)
//        let whiteCheckingMoves = generator.checkingMoves(color: .white, state: state)
//        let blackCheckingMoves = generator.checkingMoves(color: .black, state: state)
//        XCTAssertEqual(blackCheckingMoves.count, 1)
//        XCTAssertEqual(blackCheckingMoves[0].mainMove.from, Field(1, 1))
//        XCTAssertEqual(blackCheckingMoves[0].mainMove.to, Field(0, 0))
//        XCTAssertTrue(whiteCheckingMoves.isEmpty)
//    }
//    func testShortCastling() throws {
//        var fields = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
//        let king = Piece(color: .white, type: .king)
//        fields[3][0] = king
//        fields[0][0] = Piece(color: .white, type: .rook(0))
//        let state = GameState(previous: nil,
//                              board: Board(fields: fields),
//                              selectedPiece: Piece(color: .white, type: .king),
//                              turn: .white,
//                              expectation: .fieldPick)
//        let actions = generator.kingActionsToPerform(piece: king, state: state)
//        XCTAssertEqual(actions.count, 6)
//    }
//    func testLongCastling() throws {
//        var fields = Array(repeating: Array<Piece?>(repeating: nil, count: 8), count: 8)
//        let king = Piece(color: .white, type: .king)
//        fields[3][0] = king
//        fields[7][0] = Piece(color: .white, type: .rook(1))
//        let state = GameState(previous: nil,
//                              board: Board(fields: fields),
//                              selectedPiece: Piece(color: .white, type: .king),
//                              turn: .white,
//                              expectation: .fieldPick)
//        let actions = generator.kingActionsToPerform(piece: king, state: state)
//        XCTAssertEqual(actions.count, 6)
//    }
}
