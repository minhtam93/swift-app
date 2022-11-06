//
//  UserListViewController.swift
//  userManagement
//
//  Created by USER on 2022/10/21.
//

import UIKit
import DropDown

class UserListViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vwDropDown: UIView!
    @IBOutlet weak var labelDropDown: UILabel!
    //変数の宣言
    var selectedItem: User?
    var users = Array<User>()
    //databseに接続
    let db = DBService.shared
    
    //dropdown
    let dropDown = DropDown()
    let dropDownValues = [Constants.SortBy.USER_ID_LOW_TO_HIGHT,Constants.SortBy.USER_ID_HIGHT_TO_LOW]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
//        //data dummy
//        db.insertData(name: "Mai", age: 20)
//        db.insertData(name: "Hanh", age: 25)
//        db.insertData(name: "Ha", age: 30)
//        db.insertData(name: "Hong", age: 35)
//        db.insertData(name: "Huyen", age: 40)
        initDropDown()
        //data取得
        getData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue の識別子確認
        if segue.identifier == Constants.IDENTIFIRER_DETAIL_PAGE {
        //遷移先UserDetailViewControllerの取得
            let nextView = segue.destination as? UserDetailViewController
        //値の設定
            nextView?.argString = selectedItem
        }
        if segue.identifier == "NewUser" {
            let nextPopupView = segue.destination as? NewUserViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    private func getData() {
        users = DBService.shared.getUser(statusFilter: "")
    }
    
    private func initDropDown() {
        dropDown.anchorView = vwDropDown
        dropDown.dataSource = dropDownValues
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            labelDropDown.text = dropDownValues[index]
            let lblValue = labelDropDown.text
            switch lblValue {
            case Constants.SortBy.USER_ID_HIGHT_TO_LOW:
                users = DBService.shared.getUser(statusFilter: "Descending")
            default:
                users = DBService.shared.getUser(statusFilter: "")
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func dropDownPressed(_ sender: UIButton) {
        dropDown.show()
        
    }
    
    @IBAction func popupPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "NewUser", sender: nil)
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //次の画面を戻す時には背景色を透明する
        tableView.deselectRow(at: indexPath, animated: true)
        selectedItem = users[indexPath.item]
        //画面遷移実行
        self.performSegue(withIdentifier: Constants.IDENTIFIRER_DETAIL_PAGE, sender: nil)
    }
}
extension UserListViewController: UITableViewDataSource {
    //テーブルの行数の設定
    func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        return users.count
    }
    //テーブルのデータを表示する
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cel 内容の取得
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IDENTIFIRER_TABLEVIEW_LISTPAGE, for: indexPath) as! CustomTableViewCell
        let item = users[indexPath.row]
//        cell.textLabel?.text = item.name
        cell.label.text = item.name
//        cell.detailTextLabel?.text = item.age.description
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent(item.mediaName)
        cell.iconImageView.image = UIImage(contentsOfFile: imageURL.path)!
        return cell
    }
}
