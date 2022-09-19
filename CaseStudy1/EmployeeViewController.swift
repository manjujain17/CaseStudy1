//
//  EmployeeDataViewController.swift
//  CaseStudy1
//
//  Created by adminn on 18/08/22.
//

import UIKit
import CoreData

// Custom TableViewCell class
class TableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailIDLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
}

class EmployeeViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    // Created employeeData array of type EmployeeData object
    var employeeData:[EmployeeData]?
  
    // Creating a context to access persistentContainer viewcontext method
    let employeeContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.delegate = self
        fetchEmployees()
    }
    
    // MARK: Function
    // To fetch data from coredata
    func fetchEmployees() {
        do {
            // Calling fetch request
            self.employeeData = try employeeContext.fetch(EmployeeData.fetchRequest())
            
            // To run it on a main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch(let error) {
            print(error.localizedDescription)
        }
    }
   
}
// Using extension from EmployeeViewController
extension EmployeeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Functions
    // Function for table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return dynamic count of employeedata array
        return self.employeeData?.count ?? 0
    }
    
    //Function for selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowVc = storyboard?.instantiateViewController(withIdentifier: "RowSelectedViewController") as? RowSelectedViewController
        let employee = self.employeeData![indexPath.row]
        rowVc?.name = employee.name
        self.navigationController?.pushViewController(rowVc!, animated: true)
        
    }
    
    // Function for table view data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Assigning TableViewCell to cell as a constant to reuse it
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        // Passing values returned in employeedata array to labels in tableviewcell
        let employee = self.employeeData![indexPath.row]
        cell.nameLabel?.text = employee.name
        cell.emailIDLabel?.text = employee.emailid
        cell.phoneNumberLabel?.text = employee.phonenumber
        return cell
    }
}
