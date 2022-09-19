//
//  NetworkCallViewController.swift
//  CaseStudy1
//
//  Created by adminn on 01/09/22.
//

import UIKit

// Custom table view cell class
class  TableViewCells: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
}
struct Book {
    // MARK: Variables
    var bookTitle: String
    var bookAuthor: String
}
class NetworkCallViewController: UIViewController, XMLParserDelegate {
    // MARK: IBOutlet
    @IBOutlet weak var userTableView: UITableView!
    var jsonValues =  NSMutableArray()
    
    
    // MARK: Variables
    var books:[Book] = []
    var elementName: String = String()
    var bookTitle = String()
    var bookAuthor = String()
    var flag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JSON & XML Data"
        // Do any additional setup after loading the view.
    }
    
    // MARK: IBActions
    @IBAction func reloadData(_ sender: Any) {
        //setting flag
        flag = true
        // Creating a url session
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        // Creating a request
        let request: URLRequest = {
            // Passing url string
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1/comments")
            // Calling URLRequest passing url
            let request = URLRequest(url: url!)
            return request
        }()
        // Creating a task passing request
        let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
            if let _ = data {
                do {
                    // Serialising json file by passing json file
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: AnyObject]]
                    
                    // Declaring jsonValues array to empty
                    jsonValues = []
                    // Iterating through json key value pair
                    for jsonElement in json {
                        jsonValues.add(jsonElement)
                    }
                    // It should run on main thread as it is a background task
                    DispatchQueue.main.async {
                        self.userTableView.delegate = self
                        self.userTableView.dataSource = self
                        self.userTableView.reloadData()
                    }
                }
                catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
        // Resumes the task if it is suspended
        dataTask.resume()
    }
    
    @IBAction func xmlData(_ sender: Any) {
        flag = false
        // Declaring book array to empty
        books = []
        // Location of xml file
        if let path = Bundle.main.url(forResource: "Books", withExtension: "xml") {
            // XML parser
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    // MARK: XMLDelegate Functions
    // Parse for startElement is same
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qname: String?, attributes attributeDict: [String: String] = [:]) {
        if elementName == "book" {
            bookTitle = String()
            bookAuthor = String()
        }
        self.elementName = elementName
    }
    // Parse for endElement is same
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qname: String?) {
        if elementName == "book" {
            let book = Book(bookTitle: bookTitle, bookAuthor: bookAuthor)
            books.append(book)
        }
        DispatchQueue.main.async {
            self.userTableView.delegate = self
            self.userTableView.dataSource = self
            self.userTableView.reloadData()
        }
    }
    // Parse for charachters found
    func parser(_ parser: XMLParser, foundCharacters String: String) {
        let data = String.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            // Check if author exists in XML
            if self.elementName == "title" {
                // Storing it in bookTitle variable
                bookTitle += data
            }
            // Check if author exists in XML
            else if self.elementName == "author" {
                // Storing it in bookAuthor variable
                bookAuthor += data
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
// MARK: Extension of class NetworkCallViewController
extension NetworkCallViewController: UITableViewDelegate,UITableViewDataSource{
    
    // MARK: TableView Functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag == true {
            return jsonValues.count
        }
        return books.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.userTableView.dequeueReusableCell(withIdentifier: "TableViewCells", for: indexPath) as! TableViewCells
        if flag == true {
            let values = jsonValues[indexPath.row] as AnyObject
            cell.emailLabel.text = values.value(forKeyPath: "email") as? String
            cell.nameLabel.text = values.value(forKeyPath: "name") as? String
            
        }
        else {
            // Object of books
            let book = books[indexPath.row]
            cell.emailLabel?.text = book.bookTitle
            cell.nameLabel?.text = book.bookAuthor
        }
        return cell
    }
}
    
    

