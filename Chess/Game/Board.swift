//
//  Board.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

class Board {
    var fields: [[Piece?]]
    init() {
        self.fields = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    }
    static var initial: Board {
        let board = Board()
        board.fields[0] = [
            Piece(color: .white, type: .rook(0)),
            Piece(color: .white, type: .knight(0)),
            Piece(color: .white, type: .bishop(0)),
            Piece(color: .white, type: .queen(0)),
            Piece(color: .white, type: .king),
            Piece(color: .white, type: .bishop(1)),
            Piece(color: .white, type: .knight(1)),
            Piece(color: .white, type: .rook(1))
        ]
        board.fields[1] = [
            Piece(color: .white, type: .pawn(0)),
            Piece(color: .white, type: .pawn(1)),
            Piece(color: .white, type: .pawn(2)),
            Piece(color: .white, type: .pawn(3)),
            Piece(color: .white, type: .pawn(4)),
            Piece(color: .white, type: .pawn(5)),
            Piece(color: .white, type: .pawn(6)),
            Piece(color: .white, type: .pawn(7))
        ]
        board.fields[7] = [
            Piece(color: .black, type: .rook(0)),
            Piece(color: .black, type: .knight(0)),
            Piece(color: .black, type: .bishop(0)),
            Piece(color: .black, type: .queen(0)),
            Piece(color: .black, type: .king),
            Piece(color: .black, type: .bishop(1)),
            Piece(color: .black, type: .knight(1)),
            Piece(color: .black, type: .rook(1))
        ]
        board.fields[6] = [
            Piece(color: .black, type: .pawn(0)),
            Piece(color: .black, type: .pawn(1)),
            Piece(color: .black, type: .pawn(2)),
            Piece(color: .black, type: .pawn(3)),
            Piece(color: .black, type: .pawn(4)),
            Piece(color: .black, type: .pawn(5)),
            Piece(color: .black, type: .pawn(7)),
            Piece(color: .black, type: .pawn(8))
        ]
        return board
    }
}
