//
//  PieceType.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

import Foundation

enum PieceType: CustomStringConvertible {
    case rook(Int)
    case knight(Int)
    case bishop(Int)
    case queen(Int)
    case king
    case pawn(Int)
    init?(type: String, index: Int?) {
        if type == "King" {
            self = .king
            return
        }
        guard let index = index else {
            return nil
        }
        switch type {
        case "Bishop":
            self = .bishop(index)
        case "Rook":
            self = .rook(index)
        case "Knight":
            self = .knight(index)
        case "Pawn":
            self = .pawn(index)
        case "Queen":
            self = .queen(index)
        default:
            return nil
        }
    }
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
