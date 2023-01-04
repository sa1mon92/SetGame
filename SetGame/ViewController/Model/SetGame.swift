//
//  SetGame.swift
//  SetGame
//
//  Created by Дмитрий Садырев on 03.01.2023.
//

import UIKit

protocol SetGameOutput: AnyObject {
    func update()
}

protocol SetGameInput {
    var output: SetGameOutput? { get set }
    var score: Int { get }
    var cards: [(card: Card, borderColor: UIColor?)] { get }
    func selectCard(_ card: Card)
    func dealThreeCards()
    func getDeckCount() -> Int
    func backgroundTap()
}

class SetGame: SetGameInput {
    
    // MARK: - Properties
    
    weak var output: SetGameOutput?
    
    private var deck = Set<Card>()
    private var table = [Card]()
    private var selectedCards = Set<Card>()
    
    var score: Int = 0
    var cards: [(card: Card, borderColor: UIColor?)] {
        var cards = [(Card, UIColor?)]()
        table.forEach { card in
            if selectedCards.contains(card) {
                let color = getSelectedCardsColor()
                cards.append((card, color))
            } else {
                cards.append((card, nil))
            }
        }
        return cards
    }
    
    init() {
        setupDeck()
        firstDeal()
    }
    
    // MARK: - Methods
    
    func backgroundTap() {
        if selectedCards.count == 3 && checkMatch(cards: selectedCards) {
            selectedCards.forEach { card in
                if let index = table.firstIndex(where: { $0 == card }) {
                    table.remove(at: index)
                }
            }
            selectedCards.removeAll()
            dealThreeCards()
        }
    }
    
    func selectCard(_ card: Card) {
        if selectedCards.count == 3 {
            guard !selectedCards.contains(card) else { return }
            if checkMatch(cards: selectedCards) {
                selectedCards.forEach { card in
                    if let index = table.firstIndex(where: { $0 == card }) {
                        table.remove(at: index)
                    }
                }
                dealThreeCards()
                score += 3 - (table.count / 8 - 1)
            } else {
                score -= 5
            }
            selectedCards.removeAll()
            selectedCards.insert(card)
        } else if selectedCards.count < 3 {
            if selectedCards.contains(card) {
                selectedCards.remove(card)
                score -= 1
            } else {
                selectedCards.insert(card)
            }
        }
        output?.update()
    }
    
    func dealThreeCards() {
        guard table.count <= 21  && deck.count >= 3 else { return }
        for _ in 0..<3 {
            dealCard()
        }
        output?.update()
    }
    
    func getDeckCount() -> Int {
        deck.count
    }
    
    // MARK: - Private methods
    
    private func getSelectedCardsColor() -> UIColor? {
        guard selectedCards.count > 0 else { return nil }
        guard selectedCards.count == 3 else { return .orange }
        return checkMatch(cards: selectedCards) ? .green : .red
    }
    
    private func checkMatch(cards: Set<Card>) -> Bool {
        let count = cards.count
        let numberEqual = selectedCards.filter { $0.numberCharacters == selectedCards.first?.numberCharacters }.count == count
        let formEqual = selectedCards.filter { $0.form == selectedCards.first?.form }.count == count
        let colorEqual = selectedCards.filter { $0.color == selectedCards.first?.color }.count == count
        let fillingTypeEqual = selectedCards.filter { $0.fillingType == selectedCards.first?.fillingType }.count == count
        if numberEqual || formEqual || colorEqual || fillingTypeEqual {
            return true
        } else {
            return false
        }
    }
    
    private func setupDeck() {
        for _ in 0..<81 {
            guard let color = Card.Color.allCases.randomElement(),
                  let form = Card.Form.allCases.randomElement(),
                  let fillingType = Card.FillingType.allCases.randomElement()
            else { continue }
            let numberCharacters = Int.random(in: 1...3)
            let card = Card(numberCharacters: numberCharacters, color: color, form: form, fillingType: fillingType)
            deck.insert(card)
        }
        output?.update()
    }
    
    private func firstDeal() {
        guard deck.count >= 12 else { return }
        for _ in 0..<12 {
            dealCard()
        }
    }
    
    private func dealCard() {
        guard let card = deck.randomElement() else { return }
        table.append(card)
        deck.remove(card)
    }
}
