//
//  EditColorController.swift
//  Cards
//
//  Created by Иван Тиминский on 02.11.2021.
//

import UIKit

typealias ColorDescription = (card: CardColor, color: UIColor, description: String)

class EditColorController: UITableViewController {
    var colors: [CardColor] = []
    var doAfterColorSelected: (([CardColor]) -> Void)?
    private let colorDescription: [ColorDescription] = [(card:.black, color:.black, description:"Черный"), (card:.brown, color:.brown, description:"Коричневый"), (card:.gray, color:.gray, description:"Серый"),(card:.green, color:.green, description:"Зеленый"),(card:.orange, color:.orange, description:"Оранжевый"),(card:.purple, color:.purple, description:"Фиолетовый"),(card:.red, color:.red, description:"Красный"),(card:.yellow, color:.yellow, description:"Желтый")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        self.title = "Выберите цвета"
    }
    @objc func back(_ sender: UIBarButtonItem) {
        guard colors.count > 0 else {
            let alert = UIAlertController(title: "Внимание", message: "Выберете хотя бы один цвет", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return }
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CardColor.allCases.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorTypeCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = colorDescription[indexPath.row].description
        if colors.contains(colorDescription[indexPath.row].card) {
            cell.accessoryType = .checkmark
            configuration.secondaryText = "Цвет выбран"
        } else {
            cell.accessoryType = .none
            configuration.secondaryText = "Цвет не выбран"
        }
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectColor = colorDescription[indexPath.row].card
        if colors.contains(selectColor) {
            guard let firstIndex = colors.firstIndex(of: selectColor) else { return }
            colors.remove(at: firstIndex)
            tableView.reloadData()
        }
        else {
            colors.append(selectColor)
            tableView.reloadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        doAfterColorSelected?(colors)
    }

}
