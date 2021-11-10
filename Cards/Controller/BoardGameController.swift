//
//  BoardGameControllerViewController.swift
//  Cards
//
//  Created by mac on 24.10.2021.
//

import UIKit

class BoardGameController: UIViewController {
   
    // сущность "Игра"
    lazy var game: Game = getNewGame()
    private var flippedCards = [UIView]()
    var isFromContinueButton = false
    func getNewGame() -> Game {
        let game = Game()
        game.generateCards()
        return game
    }
    var cardProgress: [CardProgress]?
    var isContinuation: Bool = false
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boardGameView)
        view.addSubview(startButtonView)
        view.addSubview(flipAllCardsButtonView)
        view.addSubview(goBackButton)
        view.addSubview(setupButtonView)
        view.addSubview(currentScoreLabel)
        navigationController?.isNavigationBarHidden = true
        
        if isContinuation {
        var loadedCards: [Card] = []
        var loadedCGPointOfCards: [CGPoint] = []
            guard let progress = cardProgress else {
                print("ViewDidLoad isEmpty Progress")
                return }
        for oneCard in progress {
            loadedCards.append((oneCard.cardShape, oneCard.cardColor))
            loadedCGPointOfCards.append(CGPoint(x: oneCard.xCoordinate, y: oneCard.yCoordinate))
            
        }
        game = Game()
        game.getCardFromProgressStorage(progress)
        let cards = getCardByForStartScreen(modelData: loadedCards)
      placeCardsOnBoardWithCGPoint(cards: cards, with: loadedCGPointOfCards)
        }
    }
    
    //MARK: - Создание интерфейса сверху
    // Не уверен, что необходимо использовать "lazy"
    lazy var setupButtonView = getSetupButtonView()
    lazy var startButtonView = getStartButtonView()
    lazy var flipAllCardsButtonView = getFlipAllCardsButtonView()
    lazy var goBackButton = getBackButton()
    lazy var currentScoreLabel = getCurrentScoreLabel()
    
    private func getCurrentScoreLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: goBackButton.frame.maxX, y: startButtonView.frame.origin.y, width: (view.frame.width - startButtonView.frame.width - 10*2)/4, height: 50))
        
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .systemCyan
        return label
    }

    private func getSetupButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: flipAllCardsButtonView.frame.maxX  , y: startButtonView.frame.origin.y, width: (view.frame.width - startButtonView.frame.width - 10*2)/4, height: 50))
        let gearImage = UIImage(systemName: "gearshape")
        button.setImage(gearImage, for: .normal)
        button.imageView?.sizeToFit()
        button.backgroundColor = .clear
        button.addTarget(nil, action: #selector(goToSetupScreen), for: .touchUpInside)
        return button
    }
    @objc func goToSetupScreen(sender: UIButton) {
        let setupScreenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupScreen")
        navigationController?.pushViewController(setupScreenVC, animated: true)
    }
    
    
    private func getBackButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: startButtonView.frame.minX - ((view.frame.width - startButtonView.frame.width - 10*2)/4)*2, y: startButtonView.frame.origin.y, width: (view.frame.width - startButtonView.frame.width - 10*2)/4, height: 50))
        
        let backImage = UIImage(systemName: "arrowshape.turn.up.backward")
        button.setImage(backImage, for: .normal)
        button.addTarget(nil, action: #selector(goBack), for: .touchUpInside)
        return button
    }
    @objc func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true )
    }
    
    
    private func getFlipAllCardsButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: startButtonView.frame.maxX, y: startButtonView.frame.origin.y , width: (view.frame.width - startButtonView.frame.width - 10*2)/4, height: 50))
        let flipImage = UIImage(systemName: "rectangle.2.swap")
        button.setImage(flipImage, for: .normal)
        button.addTarget(nil, action: #selector(flipAllCards), for: .touchUpInside)
        return button
    }
    @objc func flipAllCards(_ sender: UIButton) {
        let cards = boardGameView.subviews
        var firstPackOfCards: [FlippableView] = []
        var secondPackOfCards: [FlippableView] = []
        if let cardsOnBoard = cards as? [FlippableView] {
            firstPackOfCards = cardsOnBoard.filter({ flipCard in
                return flipCard.isFlipped
            })
            secondPackOfCards = cardsOnBoard.filter({ flipCard in
                return !flipCard.isFlipped
            })
            if firstPackOfCards.count > secondPackOfCards.count {
                for card in firstPackOfCards {
                    card.justFlip()
                }
            } else {
                for card in secondPackOfCards {
                    card.justFlip()
                }
            }
        }
    }
    
    
    private func getStartButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3 - 10, height: 50))
        button.center.x = view.center.x
        
        // Ограничение от safe area (хочется найти новый способо получить safeAreaInsets)
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        
        button.frame.origin.y = topPadding
        button.setTitle("Начать игру", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        // button.addAction(UIAction(title: "", handler: { action in print("Button was pressed"}), for: .touchUpInside)  14+ iOS
        button.addTarget(self, action: #selector(startGame(_:)), for: .touchUpInside)
        return button
    }
    @objc func startGame(_ sender: UIButton) {
        boardGameView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        game = getNewGame()
        let cards = getCardBy(modelData: game.cards)
        placeCardsOnBoard(cards)
        currentScoreLabel.text = "0"
    }
    
    
    //MARK: - Игровое поле
    lazy var boardGameView = getBoardGameView()
    private func getBoardGameView() -> UIView {
        //отступ игрового поля от ближайших элементов
        let margin: CGFloat = 10
        
        let boardView = UIView()
        boardView.frame.origin.x = margin
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        boardView.frame.size.width = window.frame.width - 2*margin
        let botPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - botPadding
       
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.5, alpha: 0.3)
        return boardView
    }
    //MARK: генерация карточек
    
     func getCardBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        let cardViewFactory = CardViewFactory()
         
        for (index, modelCard) in modelData.enumerated() {
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        // добавляем всем картам обработчик переворотов
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
               
                // переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                //добавляем или удаляем карточку
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                    self.game.stepsCount += 1
                    self.currentScoreLabel.text = String(self.game.stepsCount)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                                        }
                }
                // если перевернуто 2 карточки
                if self.flippedCards.count == 2 {
                    // получаем карточки из данных модели
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    // если карточки одинаковые
                    if game.checkCards(firstCard, secondCard) {
                        // сперва анимированно скрываем их
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                        }) { _ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last?.removeFromSuperview()
                            self.flippedCards = []
                            if self.boardGameView.subviews.isEmpty {
                                let endGameAlert = UIAlertController(title: "Поздравляем!", message: "Вы завершили игру за \(String(self.game.stepsCount)) хода", preferredStyle: .alert)
                                endGameAlert.addAction(UIAlertAction(title: "Закончить игру", style: .default, handler: nil))
                                endGameAlert.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: { _ in
                                    game = getNewGame()
                                    let cards = getCardBy(modelData: game.cards)
                                    placeCardsOnBoard(cards)
                                }))
                                present(endGameAlert, animated: true, completion: nil)
                            }
                        }
                    } else {
                        // в ином случае
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                        }
                    }
                    
                }
                
                
            }
        }
        
        return cardViews
    }
    
    //MARK: Размещение карточек на игровом поле
    var cardViews = [UIView]()
    
    func placeCardsOnBoard(_ cards: [UIView]) {
        // удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        // перебираем карточки
        for card in cardViews {
            // для каждой карточки генерируем случайные координаты
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            boardGameView.addSubview(card)
        }
    }
    func placeCardsOnBoardWithCGPoint(cards array: [UIView], with cgPoint: [CGPoint]) {
        for i in 0...(array.count - 1) {
            let cardForBoard = array[i]
            cardForBoard.frame.origin = cgPoint[i]
            boardGameView.addSubview(cardForBoard)
        }
    }
    
        override func viewDidDisappear(_ animated: Bool) {
            
            let progressStorage = ProgressStorage()
            var progressToSave = [CardProgress]()
            for oneCard in boardGameView.subviews {
               let xCoordinateToSave = Int(oneCard.frame.origin.x)
               let yCoordinateToSave = Int(oneCard.frame.origin.y)
                let cardShapeToSave =  game.cards[oneCard.tag].type
               let cardColorToSave = game.cards[oneCard.tag].color
                let cardTagOfViewToSave = oneCard.tag
                progressToSave.append((xCoordinateToSave, yCoordinateToSave, cardShapeToSave,cardColorToSave,cardTagOfViewToSave ))
            }
            progressStorage.save(progressToSave)
        }
        

    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    // предельные координаты размещения карточек
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    
    func getCardByForStartScreen(modelData: [Card]) -> [UIView] {
       var cardViews = [UIView]()
       let cardViewFactory = CardViewFactory()
        var i = 0
       for  modelCard in modelData {
           
           let card = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
           guard let tagOfViewFromProgressStorage = cardProgress?[i].tagOfView else {
               print("tagOfViewFromProgressStorage - Empty")
               break
           }
           i += 1
           card.tag = tagOfViewFromProgressStorage
           cardViews.append(card)
       }
       // добавляем всем картам обработчик переворотов
       for card in cardViews {
           (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
               // переносим карточку вверх иерархии
               flippedCard.superview?.bringSubviewToFront(flippedCard)
               //добавляем или удаляем карточку
               if flippedCard.isFlipped {
                   self.flippedCards.append(flippedCard)
                   self.game.stepsCount += 1
                   self.currentScoreLabel.text = String(self.game.stepsCount)
               } else {
                   if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                       self.flippedCards.remove(at: cardIndex)
                                       }
               }
               // если перевернуто 2 карточки
               if self.flippedCards.count == 2 {
                   // получаем карточки из данных модели
                   let firstCard = game.cards[self.flippedCards.first!.tag]
                   let secondCard = game.cards[self.flippedCards.last!.tag]
                   // если карточки одинаковые
                   if game.checkCards(firstCard, secondCard) {
                       // сперва анимированно скрываем их
                       UIView.animate(withDuration: 0.3, animations: {
                           self.flippedCards.first!.layer.opacity = 0
                           self.flippedCards.last!.layer.opacity = 0
                       }) { _ in
                           self.flippedCards.first!.removeFromSuperview()
                           self.flippedCards.last?.removeFromSuperview()
                           self.flippedCards = []
                           if self.boardGameView.subviews.isEmpty {
                               let endGameAlert = UIAlertController(title: "Поздравляем!", message: "Вы завершили игру за \(String(self.game.stepsCount)) хода", preferredStyle: .alert)
                               endGameAlert.addAction(UIAlertAction(title: "Закончить игру", style: .default, handler: nil))
                               endGameAlert.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: { _ in
                                   game = getNewGame()
                                   let cards = getCardBy(modelData: game.cards)
                                   placeCardsOnBoard(cards)
                               }))
                               present(endGameAlert, animated: true, completion: nil)
                           }
                       }
                   } else {
                       // в ином случае
                       for card in self.flippedCards {
                           (card as! FlippableView).flip()
                       }
                   }
                   
               }
               
               
           }
       }
       
       return cardViews
   }
   
    
}


