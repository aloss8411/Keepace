//
//  AccountDatailVC.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/26.
//

import UIKit
import Charts
import CoreData

class AccountDatailVC: UITableViewController, ChartViewDelegate {
    ///傳值過來就已經完成items下載
    internal var status:Double = 0
    internal var itemArray = [AccountItems]()
    
    
    
    internal let fomatter = DateFormatter()
    
    @IBOutlet weak var flowName: UILabel!
    @IBOutlet weak var lineViews: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp(){
        view.backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.22, alpha: 1)
        
        switch status{
        case 0:
            flowName.text = "Case Flow"
        case 1:
            flowName.text = "Invest Flow"
        case 2:
            flowName.text = "Save Flow"
        default:
            flowName.text = "Debt Flow"
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! Cell
        cell.backgroundColor = .clear
        cell.BGViews.backgroundColor = .clear
        cell.BGViews.layer.borderColor = UIColor.white.cgColor
        cell.BGViews.layer.borderWidth = 3
        cell.BGViews.layer.cornerRadius = 10
        cell.title.text = itemArray[indexPath.row].title
        cell.descipt.text = itemArray[indexPath.row].descipt
        cell.price.text = String(itemArray[indexPath.row].price) + "元"
        cell.date.text = itemArray[indexPath.row].date
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
   
}
