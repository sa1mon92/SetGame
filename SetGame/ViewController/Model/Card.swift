//
//  Card.swift
//  SetGame
//
//  Created by Дмитрий Садырев on 03.01.2023.
//

import Foundation

struct Card: Hashable, Equatable {
    
    private static var identifierFactory = 0
    private static func getUniqueId() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    private let id: Int
    let numberCharacters: Int
    let color: Color
    let form: Form
    let fillingType: FillingType
    
    init(numberCharacters: Int, color: Color, form: Form, fillingType: FillingType) {
        self.id = Card.getUniqueId()
        self.numberCharacters = numberCharacters
        self.color = color
        self.form = form
        self.fillingType = fillingType
    }
    
    enum Form: CaseIterable {
        case circle
        case square
        case triangle
    }
    
    enum Color: CaseIterable {
        case green
        case red
        case blue
    }
    
    enum FillingType: CaseIterable {
        case filled
        case translucent
        case empty
    }
}
