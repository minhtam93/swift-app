//
//  Constants.swift
//  userManagement
//
//  Created by USER on 2022/10/25.
//

struct Constants {
    static let DB_FILE = "DB.sqlite"
    static let IDENTIFIRER_DETAIL_PAGE = "showDetailFlow"
    static let IDENTIFIRER_TABLEVIEW_LISTPAGE = "cell"
    
    struct Error {
        static let ERROR_CREATE_TABLE = "テーブルの作成に失敗しました。"
        static let ERROR_OPEN_DATABASE = "データベースを開くのに失敗"
        static let ERROR_UPDATE = "アップデート失敗"
    }
    
    struct Alert {
        static let ALERT_FILE_EXIST = "ファイルが存在しています。"
        static let ALERT_DATABASE_OPEN = "データベースを開きました。"
        static let ALERT_EDIT = "編集しました。"
        static let ALERT_UPDATE = "アップデート成功"
    }
    
    struct Warning {
        static let WARNING_NAME = "名前を入力してください"
        static let WARNING_NUMBER_1 = "0〜200まで入力してください。"
    }
    
    struct SortBy {
        static let USER_ID_LOW_TO_HIGHT = "User Id: Low to Hight"
        static let USER_ID_HIGHT_TO_LOW = "User Id: Hight to Low"
    }

}
