//
//  TasksVC.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/10.
//

import UIKit
import CoreData

class TasksVC: UIViewController,UINavigationBarDelegate{

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let formatter = DateFormatter()
    
    private var items = [StoreIitems](){
        didSet{
            distinguishItmes(status:status)
        }
    }
    private var tableItems = [StoreIitems]()
    private var status:Double = 0
    private var date = Date()
    private var dateArray = [Date]()
    private var calender = Calendar.current
    private var indexs = IndexPath(row:93, section: 0)
    
    @IBOutlet weak var collectionViews: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var impLine: UIView!
    @IBOutlet weak var norLine: UIView!
    @IBOutlet weak var triLine: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var dateText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeArrayOfDate()
        changeBottomLine(select: 0)
        formatter.dateFormat = "yyyy.MM.dd"
        getSpecItem(pickDate:formatters(date:date))
        view.backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.22, alpha: 1)
        tableView.backgroundColor = .clear
        addBtn.backgroundColor = UIColor(red: 0.883, green: 0.648, blue: 0.291, alpha: 1)
        addBtn.titleLabel?.textColor = .white
        collectionViews.backgroundColor = .clear
        dateText.text = formatter.string(from: date)
        dateText.textColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        configureCellSize()
        collectionViews.scrollToItem(at: indexs, at:.right, animated:true)
    }

    func changeBottomLine(select number:Double){
        impLine.layer.cornerRadius = 10
        norLine.layer.cornerRadius = 10
        triLine.layer.cornerRadius = 10
        impLine.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0)
        norLine.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        triLine.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        switch number{
        case 0:impLine.backgroundColor = UIColor(red: 1, green: 0.996, blue: 0.996, alpha: 1)
        case 1:norLine.backgroundColor = UIColor(red: 1, green: 0.996, blue: 0.996, alpha: 1)
        default:triLine.backgroundColor = UIColor(red: 1, green: 0.996, blue: 0.996, alpha: 1)
        }
    }
    //創造CollectionViews時間序列
    func makeArrayOfDate(){
        let add = calender.startOfDay(for: Date())
        for number in -90 ... 300{
            lazy var countDate = calender.date(byAdding: .day, value: number, to: add)
            formatter.dateFormat = "yyyy.MM.dd"
            lazy var days = formatter.string(from: countDate!)
            lazy var count = formatter.date(from: days)
            dateArray.append(count!)
        }
        
    }
    
    func distinguishItmes(status:Double){
        tableItems.removeAll()
        if items.count > 0 {
        for number in 0 ... items.count - 1 {
            if items[number].status == status{
                tableItems.append(items[number])
            }
        }
      }
        tableView.reloadData()
    }
    
    @IBAction func calenderPick(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func changeIntoImp(_ sender: UIButton) {
        status = 0
        changeBottomLine(select: 0)
        distinguishItmes(status: 0)
        tableView.reloadData()
    }
    @IBAction func changeIntoNor(_ sender: UIButton) {
        status = 1
        changeBottomLine(select: 1)
        distinguishItmes(status: 1)
        tableView.reloadData()
    }
    @IBAction func changeIntoTri(_ sender: UIButton) {
        status = 2
        changeBottomLine(select: 2)
        distinguishItmes(status: 2)
        tableView.reloadData()
    }
  
    func formatters(date:Date)-> String{
        //日期轉換成字串
        formatter.dateFormat = "yyyy.MM.dd"
        let dates = formatter.string(from: date)
        return dates
    }
    
    
  
}

extension TasksVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.backgroundColor = .clear
        cell.BGViews.backgroundColor = .white
        cell.BGViews.layer.cornerRadius = 20
        cell.BGViews.layer.shadowColor = CGColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.5)
        cell.BGViews.layer.shadowOffset = CGSize(width: 2, height: 4)
        cell.title.text = tableItems[indexPath.row].title
        cell.descipt.text = tableItems[indexPath.row].descipt
        cell.Date.text = tableItems[indexPath.row].date
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //在這邊跟主要items做檢查，符合的話即刪除
            for number in 0 ... items.count - 1{
                if tableItems[indexPath.row].title == items[number].title && tableItems[indexPath.row].date == items[number].date{
                    deleteItem(number: number)
                }
            }
            formatter.dateFormat = "yyyy.MM.dd"
            getSpecItem(pickDate:formatter.string(from: date))
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
}

extension TasksVC{
    //CoreData
    func getSpecItem(pickDate:String){
        let predicate = NSPredicate(format:"date == %@",pickDate) //確認是否成功
        let fetch:NSFetchRequest<StoreIitems> = StoreIitems.fetchRequest()
        fetch.predicate = predicate
        do{
            items = try context.fetch(fetch)
            print(items.count)
        }
        catch{
            print(error)
        }
       
        
    }
    
    func deleteItem(number:Int){
        context.delete(items[number])
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        
    }
}

extension TasksVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        cell.bgViews.backgroundColor = .clear
        formatter.dateFormat = "dd"
        cell.date.text = formatter.string(from: dateArray[indexPath.row])
        formatter.dateFormat = "EEE"
        cell.engDate.text = formatter.string(from: dateArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        let radius = cell.bgViews.bounds.width
        cell.bgViews.layer.cornerRadius = radius / 2
        cell.bgViews.backgroundColor = .gray
        if indexPath.row > 3{
            collectionViews.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        date = dateArray[indexPath.row]
        formatter.dateFormat = "yyyy.MM.dd"
        dateText.text = formatter.string(from: date)
        getSpecItem(pickDate:formatter.string(from: date))
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell else{return}
        cell.bgViews.backgroundColor = .clear
        
    }
    
    func configureCellSize(){
        let layout = collectionViews.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
        layout?.minimumLineSpacing = 0
        let width = collectionViews.bounds.width / 7
        layout?.itemSize = CGSize(width: width, height: width)
        
        
        }

    

}
