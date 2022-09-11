//
//  PieceColor.swift
//  Chess
//
//  Created by Mateusz Stompór on 07/09/2022.
//

enum PieceColor: String {
    case black = "Black"
    case white = "White"
    mutating func toggle() {
        self = self == .white ? .black : .white
    }
}
