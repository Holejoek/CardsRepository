//
//  StartScreen.swift
//  Cards
//
//  Created by mac on 28.10.2021.
//

import UIKit

class StartScreen: UIViewController {
    let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupStartView()
    }
    private func setupStartView() {
        view.backgroundColor = UIColor(red: 118/255, green: 230/255, blue: 196/255, alpha: 1)
        setupStartGameButton()
        setupSetupGameButton()
        setupContinueGameButton()
    }
    private func setupSetupGameButton() {
        let button = UIButton(frame: CGRect(x: 0, y: Int(view.bounds.height)/3 + 30 , width: Int(view.bounds.width)/3*2, height: 30))
        button.center.x = view.center.x
        button.backgroundColor = UIColor.clear
        button.setTitle("Настройки", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.addTarget(nil, action: #selector(goToSetupGameController), for: .touchUpInside)
        view.addSubview(button)
    }
    @objc func goToSetupGameController(_ sender: UIButton) {
        let setupGameVc = storyboardInstance.instantiateViewController(withIdentifier: "SetupScreen")
        navigationController?.pushViewController(setupGameVc, animated: true )
    }
    
    private func setupStartGameButton() {
        let button = UIButton(frame: CGRect(x: 0, y: Int(view.bounds.height)/3 , width: Int(view.bounds.width)/3*2, height: 30))
        button.center.x = view.center.x
        button.backgroundColor = UIColor.clear
        button.setTitle("Начать игру", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.addTarget(nil, action: #selector(goToBoardGameController), for: .touchUpInside)
        view.addSubview(button)
    }
    @objc func goToBoardGameController(_ sender: UIButton) {
        let boardGameVc = storyboardInstance.instantiateViewController(withIdentifier: "BoardGameController")
        navigationController?.pushViewController(boardGameVc, animated: true )
    }
    
    private func setupContinueGameButton() {
        let button = UIButton(frame: CGRect(x: 0, y: Int(view.bounds.height)/3 + 60 , width: Int(view.bounds.width)/3*2, height: 30))
        button.center.x = view.center.x
        button.backgroundColor = UIColor.clear
        button.setTitle("Продолжить игру", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.addTarget(nil, action: #selector(continueGame), for: .touchUpInside)
        view.addSubview(button)
    }
    @objc func continueGame(_ sender: UIButton) {
        let storage = ProgressStorage()
        guard !storage.isExistProgress() else {
            showContinueGameAlert()
            return
        }
        let boardGameVc = storyboardInstance.instantiateViewController(withIdentifier: "BoardGameController") as! BoardGameController
        
        guard let loadedProgress = storage.load() else { return }
        let loadedStepProgress = storage.loadCurrentStep()
        boardGameVc.gameStepProgress = loadedStepProgress
        boardGameVc.cardProgress = loadedProgress
        boardGameVc.isContinuation = true
        navigationController?.pushViewController(boardGameVc, animated: true )
    }
    
    func showContinueGameAlert(){
        let alert = UIAlertController(title: "Нету незаконченных игр", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

