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
    let expectation: PickExpectation
    let checkState: CheckState
    init(previous: GameState?,
         board: Board,
         selectedPiece: Piece?,
         turn: PieceColor,
         expectation: PickExpectation,
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
                  expectation: .piece,
                  checkState: .noCheck)
    }
}
