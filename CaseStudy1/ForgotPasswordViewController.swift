//
//  ForgotPasswordViewController.swift
//  CaseStudy1
//
//  Created by adminn on 30/08/22.
//

import UIKit
import UserNotifications

class ForgotPasswordViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: Variable
    var emailPass: String?
    // Object of UNUserNotificationCenter
    let notificationCenter = UNUserNotificationCenter.current()
    override func viewDidLoad() {
        super.viewDidLoad()
        // If passed variable is nil then return
        guard emailPass != nil  else{
            return
        }
        emailID.text = emailPass
        notificationCenter.delegate = self
        self.localNotification()
        
        /*
        // Object of NotificationCenter
        let nc = NotificationCenter.default
        // To pass values from one view to another view
        nc.addObserver(self, selector: #selector(PasswordReset), name: Notification.Name("PassChange"), object: nil)
        // This should be called in another or same according to the requirement
        NotificationCenter.default.post(name: Notification.Name("PassChange"), object: nil)*/
        // Do any additional setup after loading the view.
    }
    /*@objc func PasswordReset(_ notification: Notification) {
        print("PasswordReset")
    }*/
    // MARK: Functions
    func actionButtonConfigure() {
        UNUserNotificationCenter.current().delegate = self
        let confirmAction = UNNotificationAction(identifier: "confirm_action", title: "Confirm", options: UNNotificationActionOptions.init(rawValue: 0))
        let ignoreAction = UNNotificationAction(identifier: "ignore_action", title: "Ignore", options: UNNotificationActionOptions.init(rawValue: 0))
        let category = UNNotificationCategory(identifier: "categories", actions: [confirmAction,ignoreAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    func localNotification() {
        //let controller: [String : String] = ["ViewController" : "Login"]
        let content = UNMutableNotificationContent()
        content.title = "Local Notification"
        content.body = "Password reset has attempted"
        content.badge = NSNumber(value: 1)
        content.categoryIdentifier = "categories"
        actionButtonConfigure()
        //content.userInfo = controller
        NotificationCenter.default.addObserver(self, selector: #selector(Resetpassword), name: Notification.Name("ResetPassword"), object: nil)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification error:", error)
            }
        }
    }
    @objc func Resetpassword() {
        print("Reset Password Function Called")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        /*let info = response.notification.request.content.userInfo;
        let redirectTo = info["ViewController"]
        if (redirectTo as! String == "Login") {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }*/
        switch response.actionIdentifier {
        case "confirm_action":
            print("Confirm password reset by you")
        case "ignore_action":
            print("Ignore the password reset")
        default:
            NotificationCenter.default.post(name: NSNotification.Name("ResetPassword"), object: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let signVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(signVC, animated: true)
            break
        }
        completionHandler()
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
