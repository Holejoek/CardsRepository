//
//  CardViewFactory.swift
//  Cards
//
//  Created by mac on 25.10.2021.
//

import UIKit

class CardViewFactory {
        
    // Добавил функцию для передачи фигур на экран настройки доступных фигур
    func getForEditScreen(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        // на основе размеров определяем фрейм
        let frame = CGRect(origin: .zero, size: size)
        let viewColor = getViewColorBy(modelColor: color)
        switch shape {
        case .circle:
            return CardView<CircleShape>(frame: frame, color: viewColor).frontSideView
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor).frontSideView
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor).frontSideView
        case .fill:
            return CardView<FillShape>(frame: frame, color: viewColor).frontSideView
        case .circleUnfill:
            return CardView<CircleUnfillShape>(frame: frame, color: viewColor).frontSideView
        }
    }
    func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        // на основе размеров определяем фрейм
        let frame = CGRect(origin: .zero, size: size)
        // определяем UI-цвет на основе цвеа модели
        let viewColor = getViewColorBy(modelColor: color)
        
        // генерируем и возвращаем карточку
         
        switch shape {
        case .circle:
            return CardView<CircleShape>(frame: frame, color: viewColor)
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor)
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor)
        case .fill:
            return CardView<FillShape>(frame: frame, color: viewColor)
        case .circleUnfill:
            return CardView<CircleUnfillShape>(frame: frame, color: viewColor)
        }
    }
    
    private func getViewColorBy(modelColor: CardColor) -> UIColor {
        switch modelColor {
        case .red:
            return .red
        case .green:
            return .green
        case .black:
            return .black
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        }
    }
}


