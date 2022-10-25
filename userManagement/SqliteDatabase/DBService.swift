//
//  database.swift
//  userManagement
//
//  Created by Tam on 2022/10/23.
//

import Foundation
import SQLite3
import CoreVideo

//SQLiteのDBファイル名を定義
//let dbfile = "DB.sqlite"

final class DBService {
    // インスタンス
    static let shared = DBService()
    //database を操作するのに使う変数の定義
    //宛先の不透明ポインター
    private var db: OpaquePointer? = nil
    //イニシャライザ
    private init() {
        db = openDatabase()
        if !createTable() {
            print(Constants.Error.ERROR_CREATE_TABLE)
        }
    }

    private func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        //ディレクトリのURLを取得して、URLにデータベースを追加
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(Constants.DB_FILE)
        // ファイルが存在するかどうかチェック
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            print(Constants.Alert.ALERT_FILE_EXIST)
        }
        else
        {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
        //データバースファイルを開く
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print(Constants.Error.ERROR_OPEN_DATABASE)
            sqlite3_close(db)
            return nil
        } else {
            //データベースを開くのに成功
            print(Constants.Alert.ALERT_DATABASE_OPEN)
            print("ファイルのパス: \(fileURL.path)")
            return db
        }
    }
    //SqLiteのtableの作成
    private func createTable() ->Bool {
        let createTableString = """
            CREATE TABLE IF NOT EXISTS users (
            user_id INTEGER NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            age INTEGER NULL
        );
        """
        //ステートメントハンドル用変数の定義
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMss(db))")
            return false
        }
        //コンパイルしたSQL文を評価し、実行
        if sqlite3_step(createTableStatement) != SQLITE_DONE {
            print("db error: \(getDBErrorMss(db))")
            sqlite3_finalize(createTableStatement)
            return false
        }
        sqlite3_finalize(createTableStatement)
        return true
    }
    
    //データ挿入
    func insertData(userID:Int, name: String!, age:Int) {
        var statement: OpaquePointer?
        let users = getUser()
        for i in users {
            if i.userID == userID {
                return
            }
        }
        print(name!)
        let insertStatementString = "INSERT INTO users (user_id, name, age) VALUES (?, ?, ?);"
        if sqlite3_prepare_v2(db, insertStatementString, -1, &statement, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMss(db))")
            return
        }
        
        sqlite3_bind_int(statement, 1, Int32(userID))
        sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 3, Int32(age))

        if sqlite3_step(statement) != SQLITE_DONE {
            print("db error: \(getDBErrorMss(db))")
            return
        }
       
        print("データを挿入しました。")
        sqlite3_finalize(statement)
    }

    // データ取得
    func getUser() -> [User] {
        var user: [User] = []
        var queryStatement: OpaquePointer?
        let queryStatementString = "SELECT * FROM users"
        // クエリを準備する
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMss(db))")
        }
        // クエリを実行し、取得したレコードをループする
        var record = sqlite3_step(queryStatement)
        while(record == SQLITE_ROW) {
                let userId = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                var age: Int? = nil
                if sqlite3_column_int(queryStatement, 2) == SQLITE_NULL {
                    age = nil
                } else {
                    age = Int(sqlite3_column_int(queryStatement, 2))
                }
                user.append(User(userId: Int(userId), name: name, age: age!))
                record = sqlite3_step(queryStatement)
        }
        sqlite3_finalize(queryStatement)
        return user
    }
    //データ更新
    func updateData(user: User) -> Bool {
        var statement: OpaquePointer?
        let queryString = "UPDATE users SET name = '\(user.name)', age = \(user.age) WHERE user_id == \(user.userID)"
            
        // クエリの準備
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMss(db))")
            return false
        }
        // クエリの実行
        if sqlite3_step(statement) != SQLITE_DONE {
            print("db error: \(getDBErrorMss(db))")
            return false
        }
        sqlite3_finalize(statement)
        return true
    }

    private func getDBErrorMss(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        }
        return ""
    }
   
}
