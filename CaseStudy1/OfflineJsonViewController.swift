//
//  OfflineJsonViewController.swift
//  CaseStudy1
//
//  Created by adminn on 02/09/22.
//

import UIKit

// Custom Table View Cell class
class JsonTableCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var employeeIDLabel: UILabel!
    
}
class OfflineJsonViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var jsonTableView: UITableView!
    
    // MARK: Variable
    var personValues = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    // MARK: IBAction Button
    @IBAction func reloadJson(_ sender: Any) {
        
        // Fetching path location of  users.json file
        if let path = Bundle.main.url(forResource: "Users", withExtension: "json") {
            do {
                // Getting from path and storing in data
                let data = try Data(contentsOf: path, options: .mappedIfSafe)
                // JSON Serialization
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:[[String:AnyObject]]]
                // Making personValues array empty
                personValues = []
                // One key has value, inside value their is another array with key value
                for (_ , value) in json{
                    // Accessing the data key value pair inside value
                    for valueElements in value {
                        personValues.add(valueElements)
                    }
                }
                // It should run on main thread as it is a background task
                DispatchQueue.main.async {
                    self.jsonTableView.delegate = self
                    self.jsonTableView.dataSource = self
                    self.jsonTableView.reloadData()
                }
            }
            // Catch errors if any try block throws errors
            catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: Extension for OfflineJsonViewController class
extension OfflineJsonViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: TableView Functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.jsonTableView.dequeueReusableCell(withIdentifier: "JsonTableCell", for: indexPath) as! JsonTableCell
        
        // values is object of personValues to access each key inside it
        let values = personValues[indexPath.row] as AnyObject
        cell.nameLabel.text = values.value(forKeyPath: "name") as? String
        cell.ageLabel.text = values.value(forKeyPath: "age") as? String
        cell.employeeIDLabel.text = values.value(forKeyPath: "employed") as? String
        return cell
    }
    
    
}
