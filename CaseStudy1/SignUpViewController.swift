//
//  SignUpViewController.swift
//  CaseStudy1
//
//  Created by adminn on 18/08/22.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    // Creating a context to access persistentContainer viewcontext method
    let employeeContext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    
    // Created variables of type array to store different alert messages
    var alerts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
              
    }
    
    // MARK: IBActionButton
    @IBAction func onSignUpButtonClick(_ sender: Any) {
        
        // Calling all the functions
        let duplicateEmailCheck = checkDuplicateEmail(emailText: emailID.text!)
        let nameReturned = validateName(nameText: name.text!)
        let emailIDReturned = validateEmail(emailIDText:emailID.text!)
        let mobileReturned = validateMobile(mobile: phoneNumber.text!)
        let passwordReturned = validatePassword(passwordText:password.text!)
        let passwordSameReturned = isPasswordSame(passwordText: password.text!, confirmPasswordText: confirmPassword.text!)
               
        // Checking if all the functions return true value so to save data into coredata
        if duplicateEmailCheck && nameReturned && emailIDReturned && mobileReturned && passwordReturned && passwordSameReturned == true{
            let newEmployee = EmployeeData(context: self.employeeContext)
            newEmployee.name = name.text
            newEmployee.emailid = emailID.text
            newEmployee.password = password.text
            newEmployee.phonenumber = phoneNumber.text
                       
            do {
                // Calling save function from persistent container class
                try self.employeeContext.save()
                
                // After saving data navigating to employee view controller
                let employeeViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeViewController") as! EmployeeViewController
                self.navigationController?.pushViewController(employeeViewController, animated: true)
                
            }
            catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Functions

    // Function to show alert
    func showAlert() {
        
        // Using guard If alerts array doesnt have any value in it
        guard alerts.count > 0 else { return }
        
        // Passing first value of alerts array
        let alertMessage = alerts.first
        
        // Created function to show multiple alerts one after another or recursively
        func  removeAndShowNewAlert() {
                self.alerts.removeFirst()
                self.showAlert()
        }
        // Dialog box contents
        let alertController = UIAlertController(title: "Invalid", message: alertMessage, preferredStyle: .alert)
        alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertController.addAction(UIAlertAction(title: "OK", style: .default) {
            (action) in removeAndShowNewAlert()
        })
        self.present(alertController, animated: true)
    }
    // Function to check duplicate email 
    func checkDuplicateEmail (emailText: String) -> Bool {
        
        // Checking if the managed object is not returning exit code zero
        guard let appDelegate = UIApplication.shared
            .delegate as? AppDelegate else { return 0 != 0}
        
        // Creating context to access persistentContainer class
        let context = appDelegate.persistentContainer.viewContext
        
        // Passing fetch request method to request variable
        let request: NSFetchRequest<EmployeeData> = EmployeeData.fetchRequest()
        
        // Comparing text provided by user with email present in the core data
        request.predicate = NSPredicate(format: "%K == %@", argumentArray: ["emailid", emailText])
        
        // Creating variable of type NSManagedObject
        var result: [NSManagedObject] = []
        do {
            // Storing email value if exist in core data by calling fetch request
            result = try context.fetch(request)
            
            // If email value exist it will pop alert
            if result.count == 1 {
                alerts.append("Email Id already exists")
                showAlert()
            }
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        // If email doesnt exist returns true
        return result.count == 0
    }
    
    // Function to validate name
    func validateName(nameText: String) -> Bool {
        
        // Created result variable to return bool value
        var result: Bool = false
        
        // Regex for name
        let regex = "^[A-Za-z]{4,15}$"
        do {
            // Using NSregularExpression
            let expression = try NSRegularExpression(pattern: regex, options: [ .caseInsensitive])
            
            // Comparing the name provided
            let validName = expression.firstMatch(in: nameText, options: [], range: NSRange(location: 0, length: nameText.count)) != nil
            
            // If valid then setting result to true
            if validName {
                result = true
            }
            else {
                alerts.append("Name is Invalid")
                showAlert()
            }
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        return result
    }
    
    // Function to validate email
    func validateEmail(emailIDText: String) -> Bool {
        var result: Bool = false
        let regex = "^[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}$"
        do {
            let expression = try NSRegularExpression(pattern: regex, options: [ .caseInsensitive])
            let validEmail = expression.firstMatch(in: emailIDText, options: [], range: NSRange(location: 0, length: emailIDText.count)) != nil
            
            if validEmail {
                result = true
            }
            else {
                alerts.append("Email ID is Invalid")
                showAlert()
            }
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        return result
    }
    
    // Function to validate phone number
    func validateMobile (mobile: String) -> Bool {
        
        // Function to validate name
        var result: Bool = false
        
        // Regex for phonenumber
        let regex = "^[0-9]{10}$"
        do {
            let expression = try NSRegularExpression(pattern: regex)
            let validPhoneNumber = expression.firstMatch(in: mobile, options: [], range: NSRange(location: 0, length: mobile.count)) != nil
            if validPhoneNumber {
                result = true
            }
            else {
                alerts.append("Phone Number is Invalid")
                showAlert()
            }
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        return result
    }
    
    // Function to validate password
    func validatePassword(passwordText: String) -> Bool  {
        
        // Regex for password
        let regex = "^(?=.*[A-Z])(?=.*[$@$#!%?&])(?=.*[0-9])(?=.*[a-z]).{6,15}$"
        
        // Comparing password provided satisfies the regex
        let validPassword = NSPredicate(format: "SELF MATCHES %@", regex)
        
        // Returns bool value after evaluating
        return validPassword.evaluate(with: passwordText)
    }
    
    // Function to check if password is same
    func isPasswordSame (passwordText: String, confirmPasswordText: String) -> Bool {
        var result: Bool = false
        
        // Check if both password and confirm password are same
        if passwordText == confirmPasswordText && passwordText.count > 0 {
            result = true
            print("accepted")
        }
        // Show alert if not same
        else {
            alerts.append("Re Enter Confirm Password")
            showAlert()
        }
        return result
    }
}
