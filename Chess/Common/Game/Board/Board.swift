//
//  Board.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

struct Board {
    let fields: [[Piece?]]
    init(fields: [[Piece?]]) {
        self.fields = fields
    }
    static var initial: Board {
        var fields: [[Piece?]] = Array(repeating: [], count: 8)
        fields[0] = [
            Piece(color: .white, type: .rook(1)),
            Piece(color: .white, type: .pawn(7)),
            nil,
            nil,
            //
            nil,
            nil,
            Piece(color: .black, type: .pawn(0)),
            Piece(color: .black, type: .rook(0))
        ]
        fields[1] = [
            Piece(color: .white, type: .knight(1)),
            Piece(color: .white, type: .pawn(6)),
            nil,
            nil,
            //
            nil,
            nil,
            Piece(color: .black, type: .pawn(1)),
            Piece(color: .black, type: .knight(0))
        ]
        fields[2] = [
            Piece(color: .white, type: .bishop(1)),
            Piece(color: .white, type: .pawn(5)),
            nil,
            nil,
            //
            nil,
            nil,
            Piece(color: .black, type: .pawn(2)),
            Piece(color: .black, type: .bishop(0))
        ]
        fields[3] = [
            Piece(color: .white, type: .king),
            Piece(color: .white, type: .pawn(4)),
            nil,
            nil,
            //
            nil,
            nil,
            Piece(color: .black, type: .pawn(3)),
            Piece(color: .black, type: .king)
        ]
        fields[4] = [
            Piece(color: .white, type: .queen(0)),
            Piece(color: .white, type: .pawn(3)),
            nil,
            nil,
            //
            nil,
            nil,
            Piece(color: .black, type: .pawn(4)),
            Piece(color: .black, type: .queen(0))
        ]
        fields[5] = [
            Piece(color: .white, type: .bishop(0)),
            Piece(color: .white, type: .pawn(2)),
            nil,
            nil,
            //
            nil,
            nil,
            Piece(color: .black, type: .pawn(5)),
            Piece(color: .black, type: .bishop(1))
        ]
        fields[6] = [
            Piece(color: .white, type: .knight(0)),
            Piece(color: .white, type: .pawn(1)),
            nil,
            nil,
            //
            nil,
            nil,
            Piece(color: .black, type: .pawn(6)),
            Piece(color: .black, type: .knight(1))
        ]
        fields[7] = [
            Piece(color: .white, type: .rook(0)),
            Piece(color: .white, type: .pawn(0)),
            nil,
            nil,
            //
            nil,
            nil,
            Piece(color: .black, type: .pawn(7)),
            Piece(color: .black, type: .rook(1))
        ]
        return Board(fields: fields)
    }
}
