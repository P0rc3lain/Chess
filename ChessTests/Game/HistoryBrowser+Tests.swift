//
//  HistoryBrowser+Tests.swift
//  ChessTests
//
//  Created by Mateusz Stompór on 02/10/2022.
//

import XCTest
@testable import Chess

final class HistoryBrowserTests: XCTestCase {
    let browser = HistoryBrowser()
    let interactor = BoardInteractor()
    func testNotMoved() throws {
        let state = GameState.initial
        XCTAssertFalse(browser.wasEverMoved(piece: Piece(color: .white, type: .king), state: state))
    }
    func testMoved() throws {
        let state = GameState.initial
        let newBoard = interactor.perform(board: state.board, actions: [Action(mainMove: (Field(0, 1), Field(0, 3)),
                                                                               sideEffects: [],
                                                                               piecesToAdd: [],
                                                                               piecesToRemove: [])])
        let newState = GameState(previous: state,
                                 board: newBoard,
                                 selectedPiece: nil,
                                 turn: state.turn.toggled(),
                                 expectation: .piece,
                                 checkState: .noCheck)
        XCTAssertTrue(browser.wasEverMoved(piece: Piece(color: .white, type: .pawn(7)), state: newState))
    }
}
