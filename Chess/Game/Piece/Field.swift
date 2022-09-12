//
//  Field.swift
//  Chess
//
//  Created by Mateusz Stompór on 11/09/2022.
//

import Foundation

struct Field: CustomStringConvertible {
    let row: Int
    let column: Int
    var tuple: (Int, Int) {
        (row, column)
    }
    var description: String {
        guard let number = UnicodeScalar(97 + row) else {
            fatalError("Invalid state")
        }
        return String(Character(number)) + String(column + 1)
    }
    init(_ row: Int, _ column: Int) {
        assert(row >= 0 && row < 8 && column >= 0 && column < 8)
        self.row = row
        self.column = column
    }
    init?(literal: String) {
        guard let regex = try? NSRegularExpression(pattern: "^([a-h])([1-8])$") else {
            return nil
        }
        guard let match = regex.firstMatch(in: literal) else {
            return nil
        }
        guard let row = String(literal[match.range(at: 1)]).utf8CString.first,
              let column = Int(String(literal[match.range(at: 2)])) else {
            return nil
        }
        self.init(Int(row) - 97, column - 1)
    }
}
