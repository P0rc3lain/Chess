//
//  FieldCreator.swift
//  Chess
//
//  Created by Mateusz Stompór on 26/09/2022.
//

import Foundation

struct FieldCreator {
    func create(literal: String) -> Field? {
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
        return Field(Int(row) - 97, column - 1)
    }
    func dump(field: Field) -> String {
        guard let number = UnicodeScalar(97 + field.row) else {
            fatalError("Invalid state")
        }
        return String(Character(number)) + String(field.column + 1)
    }
}
