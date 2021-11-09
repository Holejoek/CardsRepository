//
//  ProgressStorage.swift
//  Cards
//
//  Created by Иван Тиминский on 09.11.2021.
//

import Foundation

typealias CardProgress = (xCoordinate: Int, yCoordinate: Int, step: Int, cardShape: CardType, cardBack: BackCardType, flipInfo: FlippableView)

protocol ProgressStorageProtocol {
    func load() -> [CardProgress]
    func save(_ newValue: [CardProgress])
}

