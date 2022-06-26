//
//  AddNewItemVC.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/10.
//

import UIKit
import CoreData
import Charts

class AddNewItemVC: UIViewController {

    
    
  
    @IBOutlet weak var btnStackViews: UIStackView!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var collectionViews: UICollectionView!
    @IBOutlet weak var impBtn: UIButton!
    @IBOutlet weak var norBtn: UIButton!
    @IBOutlet weak var triBtn: UIButton!
    @IBOutlet weak var desciptTextfield: UITextField!
    @IBOutlet weak var taskTextfield: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    private var status:Double = 0
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items = [StoreIitems]()
    private var date = Date()
    private let formatter = DateFormatter()
    private var selectDate = Date()
    private var dateArray = [Date]()
    private let calender = Calendar.current
    private var indexs = IndexPath(row:93, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        impBtn.layer.cornerRadius = 10
        impBtn.tintColor = .white
        norBtn.layer.cornerRadius = 10
        norBtn.tintColor = .white
        triBtn.layer.cornerRadius = 10
        triBtn.tintColor = .white
        addBtn.backgroundColor = UIColor(named: "Main")
        addBtn.titleLabel?.textColor = .white
        addBtn.layer.cornerRadius = 20
        desciptTextfield.backgroundColor = .clear
        desciptTextfield.textColor = .white
        desciptTextfield.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        taskTextfield.layer.borderColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1).cgColor
        taskTextfield.backgroundColor = .clear
        taskTextfield.textColor = .white
        pickImportance(num: 0)
        makeArrayOfDate()
        collectionViews.backgroundColor = .clear
        formatter.dateFormat = "yyyy.MM.dd"
       
        dateText.text = formatter.string(from: date)
    }
    override func viewDidAppear(_ animated: Bool) {
        configureCellSize()
        collectionViews.scrollToItem(at: indexs, at:.right, animated:true)
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
    func pickImportance(num:Int){
        impBtn.backgroundColor = .clear
        norBtn.backgroundColor = .clear
        triBtn.backgroundColor = .clear
        switch num{
        case 0:
            impBtn.backgroundColor = UIColor(named: "light-background")
            status = 0
        case 1:
            norBtn.backgroundColor = UIColor(named: "light-background")
            status = 1
        default:
            triBtn.backgroundColor = UIColor(named: "light-background")
            status = 2
        }
    }
    
    
    @IBAction func selectImp(_ sender: UIButton) {
        //改變重要程度
        //status預設為最重要事項
        pickImportance(num: sender.tag)
        
    }
    
    @IBAction func AddTask(_ sender: UIButton) {
        //確認有輸入標題才可以繼續
        ///日期與status預設為當日、最重要
        guard let taskTextfield = taskTextfield.text else{
                    noticeUserdidNotComplete()
                    return
        }
        addNewItems(title: taskTextfield, descipt: desciptTextfield.text, date: date, status: status)
       /* let VC = storyboard?.instantiateViewController(withIdentifier: "Tab Bar Controller")
        VC?.modalPresentationStyle = .fullScreen
        VC?.modalTransitionStyle = .flipHorizontal
        present(VC!, animated: true)
        */
        navigationController?.popViewController(animated: true)
    }
    
    
    func noticeUserdidNotComplete(){
        let alertVC = UIAlertController(title: "任務名稱沒有輸入喔", message:nil, preferredStyle: .alert)
        let alert = UIAlertAction(title: "請記得輸入", style: .cancel)
        alertVC.addAction(alert)
        present(alertVC, animated: true)
    }
}

extension AddNewItemVC{
    func addNewItems(title:String,descipt:String?,date:Date,status:Double){
        //儲存資料
        formatter.dateFormat = "yyyy.MM.dd"
        let SaveItems = StoreIitems(context: context)
        SaveItems.title = title
        SaveItems.descipt = descipt
        SaveItems.date = formatter.string(from: date)
        SaveItems.status = status
        do{
            try context.save()
        }
        catch{
            print(error)
        }
    }
}

extension AddNewItemVC:UICollectionViewDelegate,UICollectionViewDataSource{
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
        cell.bgViews.backgroundColor = UIColor(named: "light-background")
        if indexPath.row > 3{
            collectionViews.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        date = dateArray[indexPath.row]
        formatter.dateFormat = "yyyy.MM.dd"
        dateText.text = formatter.string(from: date)
        
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


extension AddNewItemVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
}
