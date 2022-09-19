//
//  RowSelectedViewController.swift
//  CaseStudy1
//
//  Created by adminn on 30/08/22.
//

import UIKit

class RowSelectedViewController: UIViewController {
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hello " + name!
        // Do any additional setup after loading the view.
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
