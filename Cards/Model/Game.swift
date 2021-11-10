//
//  Game.swift
//  Cards
//
//  Created by mac on 24.10.2021.
//

import Foundation
import UIKit

class Game {
    
    private let storage = UserDefaultsStorage()
    var gameDefaults: CardsDefaults
    //  количество пар уникальных карточек
    var cardsCount: Int
    // Массив сгенерированных карточек
    var cards = [Card]()
    // массив доступных типов фигур 
    var availableShapeTypes: [CardType]
    // массив доступных цветов фигур
    var availableColors: [CardColor]
    //
    var availableBacks: [BackCardType]
    //
    var stepsCount: Int
    
    init(){
        gameDefaults = storage.load()
        cardsCount = gameDefaults.pairsCount
        availableShapeTypes = gameDefaults.frontTypes
        availableColors = gameDefaults.colors
        availableBacks = gameDefaults.backTypes
        stepsCount = 0
        
    }
    func getCardFromProgressStorage(_ source: [CardProgress] ){
        for i in 1...source.count {
            let card: Card = (type: source[i - 1].cardShape ,color: source[i - 1].cardColor)
            self.cards.append(card)
        }
        
    }
    // генерация массива случайных карт
    func generateCards() {
        // генерируем новый массив карточек
        var cards = [Card]()
        for _ in 1...cardsCount {
            let randomELement = ( type: availableShapeTypes.randomElement()! , color: CardColor.allCases.randomElement()!)
            cards.append(randomELement)
        }
        self.cards = cards
    }
    
    // проверка эквивалентности карточек
    func checkCards (_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        }
        return false
    }
}
