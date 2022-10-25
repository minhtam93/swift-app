//
//  UserListViewController.swift
//  userManagement
//
//  Created by USER on 2022/10/21.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //変数の宣言
    var selectedItem: User?
    var users = Array<User>()
    //databseに接続
    let db = DBService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //data dummy
        db.insertData(userID: 1, name: "Mai", age: 20)
        db.insertData(userID: 2, name: "Hanh", age: 25)
        db.insertData(userID: 3, name: "Ha", age: 30)
        db.insertData(userID: 4, name: "Hong", age: 35)
        db.insertData(userID: 5, name: "Huyen", age: 40)
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    private func getData() {
        users = DBService.shared.getUser()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IDENTIFIRER_TABLEVIEW_LISTPAGE, for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].age.description
        return cell
    }
}
