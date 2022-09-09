//
//  PieceType.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

enum PieceType: CustomStringConvertible {
    case rook(Int)
    case knight(Int)
    case bishop(Int)
    case queen(Int)
    case king
    case pawn(Int)
    var description: String {
        switch (self) {
        case .rook(let v):
            return "Rook" + String(v)
        case .knight(let v):
            return "Knight" + String(v)
        case .bishop(let v):
            return "Bishop" + String(v)
        case .queen(let v):
            return "Queen" + String(v)
        case .king:
            return "King"
        case .pawn(let v):
            return "Pawn" + String(v)
        }
    }
}
