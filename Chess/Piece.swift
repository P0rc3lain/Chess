//
//  Piece.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

struct Piece: CustomStringConvertible {
    let color: PieceColor
    let type: PieceType
    var description: String {
        color.rawValue + String(describing: type)
    }
}
