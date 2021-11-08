//
//  UserDefaultsStorage.swift
//  Cards
//
//  Created by Иван Тиминский on 01.11.2021.
//

import Foundation

typealias CardsDefaults = (frontTypes: [CardType], colors: [CardColor], backTypes: [BackCardType], pairsCount: Int)

protocol CardDefaultsProtocol {
    func load() -> CardsDefaults
    func save(_ newDefaults: CardsDefaults)
}

class UserDefaultsStorage: CardDefaultsProtocol {
  private let storageKey: String = "cards"
   private let standart: CardsDefaults = (CardType.allCases , CardColor.allCases, BackCardType.allCases, 8)
    
    private var storage = UserDefaults.standard

    func load() -> CardsDefaults {
        var loadedProp: CardsDefaults
        var loadedTypes: [CardType] = []
        var loadedColors: [CardColor] = []
        var loadedBackTypes: [BackCardType] = []
        if let object = storage.object(forKey: storageKey) as? [String:[String]] {
            guard let typesFromStorage = object[DefaultsKeys.frontTypes.rawValue],
                  let colorsFromStorage = object[DefaultsKeys.colors.rawValue],
                  let backTypesFromStorage = object[DefaultsKeys.backTypes.rawValue],
                    let pairsCount = object[DefaultsKeys.pairsCount.rawValue] else {
                      return standart
                  }
            for type in typesFromStorage {
                CardType.allCases.forEach { card in
                    if card.rawValue == type {
                        loadedTypes.append(card)
                    }
                }
            }
            for color in colorsFromStorage {
                CardColor.allCases.forEach { card in
                    if card.rawValue == color {
                        loadedColors.append(card)
                    }
                }
            }
            for backType in backTypesFromStorage {
                BackCardType.allCases.forEach { card in
                    if card.rawValue == backType {
                        loadedBackTypes.append(card)
                    }
                }
            }
            loadedProp.frontTypes = loadedTypes
            loadedProp.colors = loadedColors
            loadedProp.backTypes = loadedBackTypes
            loadedProp.pairsCount = Int(pairsCount.first ?? "8" ) ?? 8
            return loadedProp
                  } else {
            return standart
        }
    }
    func save(_ newDefaults: CardsDefaults) {
        var newElementOfStorage: [String:[String]] = [:]
        newElementOfStorage[DefaultsKeys.frontTypes.rawValue] = newDefaults.frontTypes.map({ card in
            card.rawValue
        })
        newElementOfStorage[DefaultsKeys.colors.rawValue] = newDefaults.colors.map({ card in
            card.rawValue
        })
        newElementOfStorage[DefaultsKeys.backTypes.rawValue] = newDefaults.backTypes.map({ card in
            card.rawValue
        })
        var arrayForPairsCount: [String] = []
        arrayForPairsCount.append(String(newDefaults.pairsCount))
        newElementOfStorage[DefaultsKeys.pairsCount.rawValue] = arrayForPairsCount
        storage.set(newElementOfStorage, forKey: storageKey)
    }
    private enum DefaultsKeys: String {
          case frontTypes
          case colors
          case backTypes
        case pairsCount
      }
}
