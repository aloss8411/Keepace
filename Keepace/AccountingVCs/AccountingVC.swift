//
//  AccountingVC.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/19.
//

import UIKit
import Charts
import CoreData

class AccountingVC: UIViewController {

    @IBOutlet var btns: [UIButton]!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var earning: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var tableViews: UITableView!
    //CoreData
    private var array = [AccountItems]()
    private let formatter = DateFormatter()
    private var totalCost:Double = 0
    private var totalEarning:Double = 0
    private var status:Double = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        getAllItem()
        countTotalMoneyOfItems()
    }
    
    func setUp(){
        view.backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.22, alpha: 1)
        tableViews.backgroundColor = .clear
        views.backgroundColor = .clear
        for num in 0...3{
            btns[num].layer.cornerRadius = 10
            btns[num].tintColor = .white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalMoney.text = String(totalCost + totalEarning)
        earning.text = String(totalEarning)
        cost.text = String(totalCost)
    }
    
    func countTotalMoneyOfItems(){
        for number in 0 ... array.count - 1{
            if array[number].status == 3{
                totalCost = totalCost + array[number].price
            }
            else{
                totalEarning = totalEarning + array[number].price
            }
        }
        
    }
    
    @IBAction func selectCatelogy(_ sender: UIButton) {
        status = Double(sender.tag)
        for num in 0...3{
            btns[num].backgroundColor = .clear
        }
        btns[sender.tag].backgroundColor = .gray
        let VC = storyboard?.instantiateViewController(withIdentifier: "Detail") as! AccountDatailVC
        VC.status = Double(sender.tag)
        present(VC, animated: true)
    }
    
}

extension AccountingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingCell", for: indexPath) as! Cell
        cell.title.text = array[indexPath.row].title
        cell.descipt.text = array[indexPath.row].descipt
        cell.price.text = String(array[indexPath.row].price)
        cell.date.text = array[indexPath.row].date
        cell.BGViews.layer.cornerRadius = 10
        cell.BGViews.backgroundColor = .gray
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}


extension AccountingVC{
    //Core Data
    func getAllItem(){
        let fetchRequest:NSFetchRequest<AccountItems> = AccountItems.fetchRequest()
        do{
            array = try context.fetch(fetchRequest)
            print("successful")
        }
        catch{
            print(error)
        }
    }
    
}

