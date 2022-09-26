//
//  GameState.swift
//  Chess
//
//  Created by Mateusz Stompór on 16/09/2022.
//

class GameState {
    let previous: GameState?
    let board: Board
    let selectedPiece: Piece?
    let turn: PieceColor
    let expectation: UserExpectation
    let checkState: CheckState
    init(previous: GameState?,
         board: Board,
         selectedPiece: Piece?,
         turn: PieceColor,
         expectation: UserExpectation,
         checkState: CheckState) {
        self.previous = previous
        self.board = board
        self.selectedPiece = selectedPiece
        self.turn = turn
        self.expectation = expectation
        self.checkState = checkState
    }
    static var initial: GameState {
        GameState(previous: nil,
                  board: .initial,
                  selectedPiece: nil,
                  turn: .white,
                  expectation: .piecePick,
                  checkState: .noCheck)
    }
}
