//
//  QueenMoveGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 24/09/2022.
//

class QueenMoveGenerator {
    private let interactor = BoardInteractor()
    func potentialActions(piece: Piece, board: Board) -> [Action] {
        BishopMoveGenerator().potentialActions(piece: piece, board: board) +
        RookMoveGenerator().potentialActions(piece: piece, board: board)
    }
}
