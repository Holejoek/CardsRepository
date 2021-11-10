//
//  ProgressStorage.swift
//  Cards
//
//  Created by Иван Тиминский on 09.11.2021.
//

import Foundation

typealias CardProgress = (xCoordinate: Int, yCoordinate: Int, cardShape: CardType, cardColor: CardColor, tagOfView: Int)

protocol ProgressStorageProtocol {
    func load() -> [CardProgress]?
    func save(_ newValue: [CardProgress])
    func loadCurrentStep() -> Int
    func saveCurrentStep(_ newValue: Int)
}

class ProgressStorage: ProgressStorageProtocol {
    
    let storage = UserDefaults.standard
    private let storageKey = "progress"
    private let storageForStepsKey = "currentStep"
    private enum ProgressStorageKey: String {
        case xCoordinate
        case yCoordinate
        case cardShape
        case cardColor
        case tag
    }
    func loadCurrentStep() -> Int {
        let intFromStorage = storage.integer(forKey: storageForStepsKey)
      return intFromStorage
    }
    func saveCurrentStep(_ newValue: Int) {
        storage.set(newValue, forKey: storageForStepsKey)
    }
    
     func isExistProgress() -> Bool {
         let check = UserDefaults.standard.object(forKey: storageKey) as! [[String:String]]
         return check.isEmpty
    }
    
    func load() -> [CardProgress]? {
        var cardProgress: [CardProgress] = []
        let arrayFromStorage = storage.object(forKey: storageKey) as! [[String:String]]
        for oneDictioanry in arrayFromStorage {
            guard let xCoordinateFromStorage = Int(oneDictioanry[ProgressStorageKey.xCoordinate.rawValue] ?? "404"),
                  let yCoordinateFromStorage = Int(oneDictioanry[ProgressStorageKey.yCoordinate.rawValue] ?? "404"),
                  let cardShapeFromStorage = CardType.allCases.first(where: { card in
                      if card.rawValue == oneDictioanry[ProgressStorageKey.cardShape.rawValue] {
                          return true
                      }
                      return false
                  }) ,
                  let cardColorFromStorage = CardColor.allCases.first(where: { card in
                      if card.rawValue == oneDictioanry[ProgressStorageKey.cardColor.rawValue] {
                          return true
                      }
                      return false
                  }),
                  let tagOfViewFromStorage = Int(oneDictioanry[ProgressStorageKey.tag.rawValue] ?? "0")
                 
            else { return nil }
            cardProgress.append((xCoordinate: xCoordinateFromStorage, yCoordinate: yCoordinateFromStorage, cardShape: cardShapeFromStorage, cardColor: cardColorFromStorage, tagOfView: tagOfViewFromStorage ))
        }
        return cardProgress
    }
    
    func save(_ newValue: [CardProgress]) {
        var newElementOfStorage = [[String:String]] ()
        for oneValue in newValue {
            var oneCardProgress:[String:String] = [:]
            oneCardProgress[ProgressStorageKey.xCoordinate.rawValue] = String(oneValue.xCoordinate)
            oneCardProgress[ProgressStorageKey.yCoordinate.rawValue] = String(oneValue.yCoordinate)
            oneCardProgress[ProgressStorageKey.cardShape.rawValue] = oneValue.cardShape.rawValue
            oneCardProgress[ProgressStorageKey.cardColor.rawValue] = oneValue.cardColor.rawValue
            oneCardProgress[ProgressStorageKey.tag.rawValue] = String(oneValue.tagOfView)
            newElementOfStorage.append(oneCardProgress)
        }
        storage.set(newElementOfStorage, forKey: storageKey)
    }
}

