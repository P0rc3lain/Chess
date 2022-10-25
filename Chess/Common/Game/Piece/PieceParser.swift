//
//  PieceParser.swift
//  Chess
//
//  Created by Mateusz Stompór on 28/09/2022.
//

import Foundation

struct PieceParser {
    func create(literal: String) -> Piece? {
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
        return Piece(color: color, type: pieceType)
    }
    func dump(piece: Piece) -> String {
        piece.color.rawValue + String(describing: piece.type)
    }
}
