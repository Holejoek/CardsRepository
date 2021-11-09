//
//  Cards.swift
//  Cards
//
//  Created by mac on 24.10.2021.
//

import Foundation
import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
    func justFlip()
    
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
   
    // Не уверен что в View можно производить загрузку из UserDefaults, в рамках архитектуры MVC. Другого способа выгрузить массив доступных рубашек пока не нашел
    // соединил userDefaults с методом getBackSideView
    private let gameDefaults = UserDefaultsStorage()
    var isFlipped: Bool = false {
        didSet {
            // теперь при каждом изменении данного свойства будет отмечаться экземпляр вью как требующий обновления (обновляется в следующем цикле обновления(60 или 120 Гц))
            self.setNeedsDisplay()
        }
    }
    var color: UIColor!
    var flipCompletionHandler: ((FlippableView) -> Void)?
    var cornerRadius = 20
    //внутренний отступ проедставления
    private let margin: Int = 10
    //представление с лицевой и обратной стороны карты
    lazy var frontSideView: UIView = self.getFrontSideView()
    lazy var backSideView: UIView = self.getBackSideView()
    
    //MARK: Animation
    // justFlip используется для реализации функции переворота всех карточек без запуска flipCompletionHandler
    func justFlip() {
        // определяем, между какими представлениями осуществить переход (front - фигура)
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        // запускаем анимированный переход
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop])
        isFlipped = !isFlipped  // либо isFlipped.toggle()
    }
    
    
    func flip() {
        // определяем, между какими представлениями осуществить переход (front - фигура)
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        // запускаем анимированный переход
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop]) { _ in
            // обработчик переворота
            self.flipCompletionHandler?(self)
        }
        isFlipped = !isFlipped  // либо isFlipped.toggle()
    }
 
    //MARK: Перемещение игральных карточек
    private var startTouchPoint: CGPoint!
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var isNeedToMoveAtStartPoint: Bool = false
    
    // Свойство ниже создано для определения границ View.frame премещаемой карточки (угловых точек)
    var bordersMoveToCoordinates = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        startTouchPoint = frame.origin
    }
   
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        bordersMoveToCoordinates = (CGFloat(frame.minX), CGFloat(frame.minY), CGFloat(frame.maxX), CGFloat(frame.maxY))
        if (bordersMoveToCoordinates.0 < self.window?.bounds.minX ?? 10) || (bordersMoveToCoordinates.1 < self.window?.bounds.minY ?? 10) || (bordersMoveToCoordinates.2 > superview?.bounds.width ?? 10)  || (bordersMoveToCoordinates.3 > superview?.bounds.height ?? 10) {
            // если крание точки выходят за пределы view на котором они находятся,мы иницируем отмену касаний (touchesCancelled) и в дальнейшем настравиваем этот метод
                self.touchesCancelled(touches, with: event)
        } else {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
        }
    }
    // настраиваем отмену касаний
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isUserInteractionEnabled = false
        self.isNeedToMoveAtStartPoint = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // если это просто касание
        if self.frame.origin == self.startTouchPoint{
            self.flip()
            // или если это движение принудительно завершенно (touchesCancelled)
        } else if self.isNeedToMoveAtStartPoint {
            UIView.animate(withDuration: 0.5) {
            self.frame.origin = self.startTouchPoint
        }
        }
        self.isUserInteractionEnabled = true
        self.isNeedToMoveAtStartPoint = false
    }
    // Предполагаю, что в этом методе надо будет реализовать сохранение прогресса при каждом взаимодействии.
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    print(self.responderChain())
//    }
    
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        let shapeView = UIView(frame: CGRect(x: margin , y: margin, width: Int(self.bounds.width) - margin*2, height: Int(self.bounds.height) - margin*2))
        view.addSubview(shapeView)
        //  создание слоя с фигурой
        // этот момент немного непонятен. class CardView<ShapeType: ShapeLayerProtocol> . Я обращаюсь к типу дженерика ShapeLayerProtocol?
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    
    
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        //MARK: РУБАШКИ. выбор случайного узора для рубашки
        switch gameDefaults.load().backTypes.randomElement() ?? BackCardType.allCases.randomElement()! {
        case .circle :
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case .line:
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        }
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        setupBorders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: DRAW
    // Эта функция использауется при каждой генерации представлений
    override func draw(_ rect: CGRect) {
        //удаляем добавленные ранее дочерние представления
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        //добавляем новые представления
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     print("touchesBegan card")
     }
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     print("touchesMoved card")
     }
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     print("TouchesEnded card")
     }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     print(self.responderChain())
     }
     */
}
