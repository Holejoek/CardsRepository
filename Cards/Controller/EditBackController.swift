//
//  EditBackController.swift
//  Cards
//
//  Created by Иван Тиминский on 04.11.2021.
//

import UIKit

typealias BackDescription = (description: String, backType: BackCardType , backView: ShapeLayerProtocol)

class EditBackController: UITableViewController {
    
    var selectedBacks: [BackCardType]!
    var doAfterBackSelected: (([BackCardType]) -> Void)?
    static private let cellHeight: CGFloat = 80
  private let backDescriptions: [BackDescription] = [(description: "Хаотичные круги", backType: BackCardType.circle, backView: BackSideCircle(size: CGSize(width: cellHeight, height: cellHeight), fillColor: UIColor.black.cgColor)),(description: "Хаотичные линии", backType: BackCardType.line, backView: BackSideLine(size: CGSize(width: cellHeight, height: cellHeight), fillColor: UIColor.black.cgColor) )]
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        let backCellNib = UINib(nibName:"BackCell", bundle: nil)
        tableView.register(backCellNib, forCellReuseIdentifier: "BackCell")
        self.title = "Выберите рубашки"
    }
    @objc func back(_ sender: UIBarButtonItem) {
        guard selectedBacks.count > 0 else {
            let alert = UIAlertController(title: "Внимание", message: "Выберете хотя бы одну рубашку", preferredStyle: .alert)
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
        return  BackCardType.allCases.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BackCell", for: indexPath) as! BackCell
        
        
        cell.backType.text = backDescriptions[indexPath.row].description
        cell.backView.layer.addSublayer(backDescriptions[indexPath.row].backView)
        if selectedBacks.contains(backDescriptions[indexPath.row].backType) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EditBackController.cellHeight
    }
    override func viewDidDisappear(_ animated: Bool) {
        doAfterBackSelected?(selectedBacks)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBack = backDescriptions[indexPath.row].backType
        if selectedBacks.contains(selectedBack) {
            guard let firstIndex = selectedBacks.firstIndex(of: selectedBack) else { return }
            selectedBacks.remove(at: firstIndex)
            tableView.reloadData()
        } else {
            selectedBacks.append(selectedBack)
            tableView.reloadData()
        }
    }
   
}
