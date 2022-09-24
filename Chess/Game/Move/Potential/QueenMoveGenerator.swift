//
//  QueenMoveGenerator.swift
//  Chess
//
//  Created by Mateusz Stompór on 24/09/2022.
//

class QueenMoveGenerator {
    private let bishopGenerator = BishopMoveGenerator()
    private let rookGenerator = RookMoveGenerator()
    func potentialActions(piece: Piece, board: Board) -> [Action] {
        bishopGenerator.potentialActions(piece: piece, board: board) +
        rookGenerator.potentialActions(piece: piece, board: board)
    }
}
