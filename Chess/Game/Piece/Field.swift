//
//  Field.swift
//  Chess
//
//  Created by Mateusz Stompór on 11/09/2022.
//

import Foundation

struct Field {
    let row: Int
    let column: Int
    var tuple: (Int, Int) {
        (row, column)
    }
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
    init?(literal: String) {
        guard let regex = try? NSRegularExpression(pattern: "^([a-h])([1-8])$") else {
            return nil
        }
        let matches = regex.matches(in: literal)
        guard let match = matches.first else {
            return nil
        }
        guard let row = String(literal[match.range(at: 1)]).utf8CString.first,
              let column = Int(String(literal[match.range(at: 2)])) else {
            return nil
        }
        self.row = Int(row) - 97
        self.column = column - 1
    }
}
