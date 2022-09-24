//
//  Piece.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

import Foundation

struct Piece: CustomStringConvertible, Equatable {
    let color: PieceColor
    let type: PieceType
    var description: String {
        color.rawValue + String(describing: type)
    }
    init(color: PieceColor, type: PieceType) {
        self.color = color
        self.type = type
    }
    init?(literal: String) {
        let pattern = "^(Black|White)(Rook|Knight|Bishop|Queen|King|Pawn)(\\d)?$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: literal, range: NSRange(location: 0, length: literal.count))
        guard let match = matches.first else {
            return nil
        }
        let color = PieceColor(rawValue: String(literal[match.range(at: 1)]))
        let index = match.range(at: 3).location != NSNotFound ? Int(String(literal[match.range(at: 3)])) : nil
        guard let coreType = CoreType(rawValue: String(literal[match.range(at: 2)])) else {
            return nil
        }
        let pieceType = PieceType(coreType: coreType, id: index ?? 0)
        guard let color = color else {
            return nil
        }
        self.color = color
        self.type = pieceType
    }
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        lhs.color == rhs.color && lhs.type == rhs.type
    }
}
