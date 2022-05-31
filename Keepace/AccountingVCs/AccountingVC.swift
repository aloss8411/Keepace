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
    @IBOutlet weak var chartViews: UIView!
    @IBOutlet weak var btnStackView: UIStackView!
    
    //CoreData
    private var array = [AccountItems]()
    private var items = [AccountItems]()
    private let formatter = DateFormatter()
    private var totalCost:Double = 0
    private var totalEarning:Double = 0
    private var status:Double = 0
    private var barView = PieChartView()
    private var entries = [PieChartDataEntry]()
    //Views
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        barView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllItem()
        tableViews.reloadData()
        makeAchartView()
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
    }
    
    func makeAchartView(){
        //在Entiries中登入資料設計內容
        //現在我有一個Array可以去計算
        entries.removeAll()
        for num in 0 ... 3{
            items.removeAll()
            let items = array.filter({ $0.status == Double(num) })
            let sum = items.reduce(0,{$0 + $1.price})
            var label:String?
            if sum != 0{
            switch num{
            case 0 :
                label = "Cash"
            case 1 :
                label = "Invest"
            case 2 :
                label = "Save"
            default :
                label = "Debt"
                }
            }
            let data = PieChartDataEntry(value: sum, label: label)
            entries.append(data)
        }
        var dataSet = PieChartDataSet()
        if array.count != 0 {
        dataSet = PieChartDataSet(entries: entries, label: "收入支出顏色圖")
        }else{
            dataSet = PieChartDataSet(label: "目前沒有資料")
        }
        let data = PieChartData(dataSet: dataSet)
        
        data.setValueFormatter(DigitValueFormatter())
        
        dataSet.sliceSpace = 5
        dataSet.entryLabelColor = .white
        dataSet.automaticallyDisableSliceSpacing = true
        dataSet.highlightColor = .lightGray
        dataSet.valueLineColor = .gray
        dataSet.colors = ChartColorTemplates.pastel()
    
        
        //設定Label顯示
        barView.legend.horizontalAlignment = .center
        barView.legend.horizontalAlignment = .center
        barView.legend.verticalAlignment = .bottom
        barView.legend.orientation = .horizontal
        barView.legend.textColor = .white
    
        
        barView.tintColor = .white
        barView.transparentCircleColor = .white
        barView.usePercentValuesEnabled = true
        barView.backgroundColor = .clear
        barView.noDataTextColor = .white
        
        barView.tintColor = .white
        barView.holeColor = .clear
        barView.data = data
        barView.layer.cornerRadius = 10
        barView.center = views.center
        barView.frame = chartViews.bounds
        
        //Animation
        barView.animate(xAxisDuration: 1, yAxisDuration: 1)
        chartViews.addSubview(barView)
    }
    
   
    
    
    func setUp(){
        view.backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.22, alpha: 1)
        tableViews.backgroundColor = .clear
        views.backgroundColor = .clear
        for num in 0...3{
            btns[num].layer.cornerRadius = 10
            btns[num].tintColor = .white
        }
        btnStackView.layer.borderWidth = 2
        btnStackView.layer.borderColor = UIColor.white.cgColor
        btnStackView.layer.cornerRadius = 10
    }
    
 
   
    
    func distinguishItems(status:Double){
        if array.count > 0{
        for number in 0 ... array.count - 1{
            if array[number].status == status{
                items.append(array[number])
                }
            }
        }
    }
    
    @IBAction func selectCatelogy(_ sender: UIButton) {
        
        for num in 0...3{
            btns[num].backgroundColor = .clear
        }
        btns[sender.tag].backgroundColor = UIColor(named: "Main")
        let VC = storyboard?.instantiateViewController(withIdentifier: "Detail") as! AccountDatailVC
        getAllItem()
        items.removeAll()
        distinguishItems(status: Double(sender.tag))
        VC.status = Double(sender.tag)
        VC.itemArray = items
        present(VC, animated: true)
    }
    
}

extension AccountingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingCell", for: indexPath) as! Cell
        
        cell.icons.image = UIImage(named: "\(Int(array[indexPath.row].status))")
        cell.title.text = array[indexPath.row].title
        cell.descipt.text = array[indexPath.row].descipt
        cell.price.text = String(array[indexPath.row].price) + "元"
        formatter.dateFormat = "yyyy.MM.dd"
        cell.date.text = array[indexPath.row].date
        //deal with views
        cell.BGViews.layer.cornerRadius = 10
        cell.BGViews.backgroundColor = .clear
        cell.BGViews.layer.borderWidth = 3
        cell.BGViews.layer.borderColor = UIColor.white.cgColor
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteItem(number: indexPath.row)
        }
        getAllItem()
        makeAchartView()
        tableViews.reloadData()
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
        }
        catch{
            print(error)
        }
        //change total counting
        if array.count > 0{
            totalCost = 0
            totalEarning = 0
        for number in 0 ... array.count - 1{
            if array[number].status == 3.0{
                totalCost = totalCost + array[number].price
            }
            else{
                totalEarning = totalEarning + array[number].price
                }
            }
        }
        totalMoney.text = String(totalCost + totalEarning)
        earning.text = String(totalEarning)
        cost.text = String(totalCost)
    }
    
    func deleteItem(number:Int){
        context.delete(array[number])
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        
    }
    
}

extension AccountingVC:ChartViewDelegate{
    
    //present chartViews
    
}

class DigitValueFormatter: NSObject, IValueFormatter{
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if value == 0{
            return ""
        }
        let valueWithoutDecimalPart = String(format: "%.1f%%", value)
        return valueWithoutDecimalPart
        
    }
}
