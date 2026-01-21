//
//  Piece.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

import Foundation

struct Piece: Equatable, Codable {
    let color: PieceColor
    let type: PieceType
    init(color: PieceColor, type: PieceType) {
        self.color = color
        self.type = type
    }
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        lhs.color == rhs.color && lhs.type == rhs.type
    }
}
