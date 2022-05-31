//
//  AddAccountingItemVC.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/23.
//

import UIKit
import CoreData

class AddAccountingItemVC: UITableViewController {
    //IBOutlet
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet var tableViews: UITableView!
    @IBOutlet weak var collectionViews: UICollectionView!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var desciptText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var upViews: UIView!
    @IBOutlet var btns: [UIButton]!
    
    //DateCell Setting
    private var dateArray = [Date]()
    private let calender = Calendar.current
    private var indexs = IndexPath(row:93, section: 0)
    private var date = Date()
    private let formatter = DateFormatter()
    //Core Data
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var selectDay = Date()
    private var status:Double = 0
    private var prices:Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeArrayOfDate()
        setUpVCSetting()
        priceText.setNumberKeyboardReturn()
    }
    override func viewDidAppear(_ animated: Bool) {
        configureCellSize()
        collectionViews.scrollToItem(at: indexs, at:.right, animated:true)
    }
    
    
    func setUpVCSetting(){
        view.backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.22, alpha: 1)
        collectionViews.backgroundColor = .clear
        upViews.backgroundColor = .clear
        tableViews.backgroundColor = UIColor(red: 0.18, green: 0.2, blue: 0.22, alpha: 1)
        addbtn.tintColor = .white
        addbtn.backgroundColor = UIColor(named: "Main")
        addbtn.layer.cornerRadius = 10
        btns[0].layer.cornerRadius = 10
        btns[0].backgroundColor = UIColor(named: "Main")
        for num in 0 ... 3{
            btns[num].tintColor = .white
        }
        
    }
    
    func noticeUserdidNotComplete(){
        let alertVC = UIAlertController(title: "有東西沒有輸入喔", message:nil, preferredStyle: .alert)
        let alert = UIAlertAction(title: "請記得輸入", style: .cancel)
        alertVC.addAction(alert)
        present(alertVC, animated: true)
    }
    
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
    
    
    @IBAction func changeCategory(_ sender: UIButton) {
        for num in 0...3{
            btns[num].layer.cornerRadius = 10
            btns[num].backgroundColor = .clear
        }
        btns[sender.tag].backgroundColor = UIColor(named: "Main")
        status = Double(sender.tag)
    }
    
   
    @IBAction func addItem(_ sender: UIButton) {
        if let title = titleText.text,
           let descipt = desciptText.text,
           let price = priceText.text{
            if price.isEmpty == false{
            storeItem(title: title, descipt: descipt, status: status, date: formatter.string(from: selectDay), price: Double(price)!)
                navigationController?.popViewController(animated: true)
            }
            else{
                noticeUserdidNotComplete()
                return
            }
        }
       
    }
}


extension AddAccountingItemVC:UICollectionViewDelegate,UICollectionViewDataSource{
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
        formatter.dateFormat = "yyyy.MM.dd"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        let radius = cell.bgViews.bounds.width
        cell.bgViews.layer.cornerRadius = radius / 2
        cell.bgViews.backgroundColor = UIColor(named: "Main")
        if indexPath.row > 3{
            collectionViews.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        lazy var a:String = formatter.string(from: date)
        formatter.dateFormat = "yyyy.MM.dd"
        a = formatter.string(from: dateArray[indexPath.row])
        selectDay = formatter.date(from: a)!
        
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

extension AddAccountingItemVC{
    //Core Data
    func storeItem(title:String,descipt:String,status:Double,date:String,price:Double){
      let items = AccountItems(context: context)
        items.title = title
        items.descipt = descipt
        items.status = status
        items.date = date
        items.price = price
        do{
            try context.save()
        }
        catch{
            print(error)
        }
    }
}

extension AddAccountingItemVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
}



