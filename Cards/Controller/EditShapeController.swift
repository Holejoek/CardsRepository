//
//  EditShapeController.swift
//  Cards
//
//  Created by Иван Тиминский on 01.11.2021.
//


import UIKit
typealias shapeDescription = (shape: CardType, description: String)

class EditShapeController: UITableViewController {
    var doAfterShapeSelected: (([CardType]) -> Void)?
    private let cardViewFactory = CardViewFactory()
    var availableShapes: [CardType]!
    private let shapeDescription: [shapeDescription] = [ (shape: .circle, description:"Круг"), (shape: .cross, description:"Крестик"),  (shape: .square, description:"Квадрат"),  (shape: .fill, description:"Пустой квадрат"),  (shape: .circleUnfill, description:"Пустой круг")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
     let shapeCellNib = UINib(nibName: "ShapeCell", bundle: nil)
        tableView.register(shapeCellNib, forCellReuseIdentifier: "ShapeCell")
        self.title = "Выберите фигуры"
    }
    @objc func back(_ sender: UIBarButtonItem) {
        guard availableShapes.count > 0 else {
            let alert = UIAlertController(title: "Внимание", message: "Выберете хотя бы одну фигуру", preferredStyle: .alert)
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
        return CardType.allCases.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShapeCell", for: indexPath) as! ShapeCell
        let type = CardType.allCases[indexPath.row]
        
        let typeView = cardViewFactory.getForEditScreen(type, withSize: CGSize(width: cell.bounds.height - 10, height: cell.bounds.height - 10), andColor: .black)
        
        cell.shapeView.addSubview(typeView)
        cell.shapeName.text = shapeDescription[indexPath.row].description
        if availableShapes.contains(CardType.allCases[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = CardType.allCases[indexPath.row]
        if availableShapes.contains(type) {
            guard let firstIndex = availableShapes.firstIndex(of: type) else { return }
            availableShapes.remove(at: firstIndex)
            
            tableView.reloadData()
        } else {
            availableShapes.append(type)
            
            tableView.reloadData()
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        doAfterShapeSelected?(availableShapes)
    }
   
    
}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


