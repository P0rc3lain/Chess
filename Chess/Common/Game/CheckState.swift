//
//  CheckState.swift
//  Chess
//
//  Created by Mateusz Stompór on 26/09/2022.
//

enum CheckState: Codable {
    case unknown
    case noCheck
    case check
    case stalemate
    case checkmate
}
