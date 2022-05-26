//
//  AccountDatailVC.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/26.
//

import UIKit
import CoreData

class AccountDatailVC: UITableViewController {
   
    internal var status:Double = 0
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items = [AccountItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        getSpecItem(status: status)
    }
    
    func setUp(){
        view.backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.22, alpha: 1)
    }
    
    func getSpecItem(status:Double){
        let predicate = NSPredicate(format: "status == %@", status)
        let fetchRequest:NSFetchRequest<AccountItems> = AccountItems.fetchRequest()
        fetchRequest.predicate = predicate
        do{
            items = try context.fetch(fetchRequest)
        }
        catch{
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! Cell
        
        return cell
    }
    
}
