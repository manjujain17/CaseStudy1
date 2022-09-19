//
//  ViewController.swift
//  CaseStudy1
//
//  Created by adminn on 18/08/22.
//

import UIKit
import CoreData
import Security

class LoginViewController: UIViewController {
     
    
    // MARK: IBOutlets start
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func getVC() -> LoginViewController{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return VC
    }
    // MARK: IBAction
    @IBAction func loginActionButton(_ sender: Any) {
        
        // Passing emailvalue to valid email function
        let validEmail = checkEmail(emailText: emailID.text!)
        
        // Checking if the function returning true
        if validEmail {
            do {
                // Passing values to Keychainmanager class function to save
                try KeyChainManager.save(
                    account: emailID.text!, password: password.text!.data(using: .utf8) ?? Data())
            }
            catch (let error) {
                print(error.localizedDescription)
            }
            // Pushing or navigating to employee screen
            let employeeViewController = self.storyboard?.instantiateViewController(
                withIdentifier: "EmployeeViewController") as! EmployeeViewController
            self.navigationController?.pushViewController(employeeViewController, animated: true)
        }
        // Show alert if email does not exist
        else {
            showAlert(alertMessage: "User does not exist. Please signup.")
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        let forgotVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
        forgotVC?.emailPass = emailID.text
        self.navigationController?.pushViewController(forgotVC!, animated: true)
    }
    
    
    @IBAction func pushToNetworkView(_ sender: Any) {
        let networkVC = storyboard?.instantiateViewController(withIdentifier: "NetworkCallViewController") as? NetworkCallViewController
        self.navigationController?.pushViewController(networkVC!, animated: true)
    }
    // MARK: Functions
    private func showAlert(alertMessage: String) {
        
        // Dialog box contents
        let alertController = UIAlertController(title: "Invalid", message: alertMessage, preferredStyle: .alert)
        
        // Action Button
        let  okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        // Pop up dialog box with contents
        self.present(alertController, animated: true)
    }
    
    func checkEmail(emailText: String) -> Bool {
        
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
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        return result.count > 0
    }
        
}

// Creating class for KeyChain
class KeyChainManager {
    
    // Creating enum for different types of error so to access each options
    enum KeyChainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    // Function to Add email and password in keychain
    static func save(account: String, password: Data) throws {
        
        // keyChain Items
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject
            ]
        
        // Calling function SecItemAdd to add the values in dictionary
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Checking if values already added in keychain
        guard status == errSecDuplicateItem else {
            throw KeyChainError.duplicateEntry
        }
        // To check the values added sucessfully
        guard status == errSecSuccess else {
            throw KeyChainError.unknown(status)
        }
    }
}
