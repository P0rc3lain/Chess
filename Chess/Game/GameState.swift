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
    init(previous: GameState?,
         board: Board,
         selectedPiece: Piece?,
         turn: PieceColor,
         expectation: UserExpectation) {
        self.previous = previous
        self.board = board
        self.selectedPiece = selectedPiece
        self.turn = turn
        self.expectation = expectation
    }
    static var initial: GameState {
        GameState(previous: nil,
                  board: .initial,
                  selectedPiece: nil,
                  turn: .white,
                  expectation: .piecePick)
    }
}
