//
//  Card.swift
//  Cards
//
//  Created by mac on 24.10.2021.
//

import Foundation
import UIKit
 // CaseIterable - протокол позвоялющий работать с колекцией перечисления. Например: .allCases - перебор всех кейсов (как for in)  .allCases.randomElemen()!
enum CardType: String, CaseIterable {
    case circle
    case cross
    case square
    case fill
    case circleUnfill
}
enum BackCardType: String, CaseIterable {
    case circle
    case line
}
enum CardColor: String, CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}
// игральная карточка
typealias Card = (type: CardType, color: CardColor )
