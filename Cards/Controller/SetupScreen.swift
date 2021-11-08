//
//  SetupScreen.swift
//  Cards
//
//  Created by Иван Тиминский on 30.10.2021.
//

import UIKit

class SetupScreen: UITableViewController {
    
    private let storage: CardDefaultsProtocol = UserDefaultsStorage()
    private var cardDefaults: CardsDefaults!
    
    @IBOutlet weak var pairsCountTextField: UITextField!
    @IBAction func saveDefaults(_ sender: Any) {
        
        if let pairsCount = Int(pairsCountTextField.text!) {
            if (2...15).contains(pairsCount) {
        cardDefaults.pairsCount = pairsCount
                pairsCountTextField.resignFirstResponder()
            } else {
                let alert = UIAlertController(title: "Внимание", message: "Вы ввели некоректное количество пар, возможное колличество пар -  от 2 до 15", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Продолжить ввод", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        storage.save(cardDefaults)
        let succesAlert = UIAlertController(title: "Успешно сохранено!", message: nil, preferredStyle: .alert)
        succesAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(succesAlert, animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationItem.backButtonDisplayMode = .minimal
        cardDefaults = storage.load()
        setupPairsCountTextField()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1 :
            self.performSegue(withIdentifier: "toEditShapeScreen", sender: nil)
        case 2 :
            self.performSegue(withIdentifier: "toEditColorScreen", sender: nil)
        case 3 :
            self.performSegue(withIdentifier: "toEditBackScreen", sender: nil)
        default: break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditShapeScreen" {
            let destination = segue.destination as! EditShapeController
            destination.availableShapes = cardDefaults.frontTypes
            destination.doAfterShapeSelected = { [unowned self] newDefaults in
                cardDefaults.frontTypes = newDefaults
            }
        }
        if segue.identifier == "toEditColorScreen" {
            let destination = segue.destination as! EditColorController
            destination.colors = cardDefaults.colors
            destination.doAfterColorSelected = { [unowned self] newDefaults in
                cardDefaults.colors = newDefaults
            }
        }
        if segue.identifier == "toEditBackScreen" {
            let destination = segue.destination as! EditBackController
            destination.selectedBacks = cardDefaults.backTypes
            destination.doAfterBackSelected = { [unowned self] newDefaults in
                cardDefaults.backTypes = newDefaults
            }
        }
        
    }
    
    private func setupPairsCountTextField(){
        pairsCountTextField.placeholder = "Сейчас - " + String(cardDefaults.pairsCount)
        
    }
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.isNavigationBarHidden = true
    }
    

   

}
