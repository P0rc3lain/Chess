//
//  PieceColor.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

enum PieceColor: String, Codable {
    case black = "Black"
    case white = "White"
    mutating func toggle() {
        self = toggled()
    }
    func toggled() -> PieceColor {
        self == .white ? .black : .white
    }
}
