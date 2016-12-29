//
//  YHDBManager.swift
//  SQLite
//
//  Created by baiwei－mac on 16/12/28.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit
import FMDB


class YHDBManager {
    
    
    private static var dbDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/DB")
    static var defaultName = "FMDB"
    
    
    //MARK: - 数据库操作
    /**初始化或者找到数据库*/
    static func createOrFindDB(fileName: String = defaultName) -> FMDatabase? {

        var isDir: ObjCBool = false
        //fileExists:判断文件是否存在    isDir:判断路径是否为目录
        let isExit = FileManager.default.fileExists(atPath: dbDirPath!, isDirectory: &isDir)
        if !isExit || !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(atPath: dbDirPath!, withIntermediateDirectories: true, attributes: nil)
            } catch let err as NSError {
                print("创建\(dbDirPath)失败：\(err.localizedFailureReason)")
                return nil
            }
        }
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        print("数据库路劲：\(dbPath)")
        return FMDatabase(path: dbPath)
    }
    
    
    /**删除数据库*/
    static func deleteDB(fileName: String = defaultName) {
        
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        if FileManager.default.fileExists(atPath: dbPath) {
            do {
                try FileManager.default.removeItem(atPath: dbPath)
                print("移除\(fileName)成功！")
            } catch let err as NSError {
                print("移除\(fileName)失败：\(err.localizedFailureReason)")
            }
        }else {
            print("无该文件\(fileName)！移除什么？")
        }
    }
    
    
    //MARK: - 数据库中表操作
    /**获得数据库中所有的表名------------采用手动打开数据库的方式*/
    static func getAllTable(fileName: String = defaultName) -> [String]? {
        
        var tableNames = [String]()
        let db = createOrFindDB(fileName: fileName)
        if (db?.open())! {
            do {
                let set = try db?.executeQuery("SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name", values: nil)
                while (set?.next())! {
                    tableNames.append((set?.string(forColumn: "name"))!)
                }
            } catch let err as NSError {
                print("读取列表失败：\(err.localizedFailureReason)")
            }
        }else {
            print("打开数据库失败！")
            return nil
        }
        db?.close()
        print("数据库中有的表：\(tableNames)")
        return tableNames
    }
    
    
    /**删除指定数组内的表------------------采用FMDBQueue---inTransaction的方式，更新等操作用该方式最好*/
    static func deleteDBTables(tableNames: [String]? , fileName: String = defaultName) {
        
        if (tableNames?.count)! < 1 {
            return
        }
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        let dbQueue = FMDatabaseQueue(path: dbPath)
        dbQueue?.inTransaction({ (db, roolback) in
            for name in tableNames! {
                do {
                    try db?.executeUpdate("DROP TABLE IF EXISTS \(name)", values: nil)
                    print("删除表\(name)成功！")
                }catch let err as NSError {
                    print("删除表\(name)失败:\(err.localizedFailureReason)")
                    roolback?.pointee = true
                    /*事务回滚
                     oc: roolback = yes
                     swift: roolback.pointee = true
                     */
                    return
                }
                
            }
        })
    }
    
    
    /**创建表*/
    static func createTable(tableName: String, parameter: String, fileName: String = defaultName) {
        
        if tableName.characters.count < 1 {
            return
        }
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        let dbQueue = FMDatabaseQueue(path: dbPath)
        dbQueue?.inDatabase({ (db) in
            do {
                try db?.executeUpdate("CREATE TABLE IF NOT EXISTS \(tableName) (\(parameter))", values: nil)
                print("创建表\(tableName)成功！")
            }catch let err as NSError {
                print("创建表\(tableName)失败：\(err.localizedFailureReason)")
                return
            }
        })
    }
    
    
    //MARK: - 表内部数据操作
    /**获得指定表的字段名-------------采用FMDBQueue---inDatabase的方式，查询数据最好使用该方式*/
    static func getTableFields(tableName: String, fileName: String = defaultName) -> [String]? {
        
        if tableName.characters.count < 1 {
            return nil
        }
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        let dbQueue = FMDatabaseQueue(path: dbPath)
        var tables = [String]()
        dbQueue?.inDatabase({ (db) in
            do {
                let set = try db?.executeQuery("PRAGMA table_info(\(tableName))", values: nil)
                while (set?.next())! {
                    tables.append((set?.string(forColumn: "name"))!)
                }
            }catch let err as NSError {
                print("查询\(tableName)字段名失败：\(err.localizedFailureReason)")
            }
        })
        print("所有字段名:\(tables)")
        return tables
    }
    
    /**增*/
    static func saveData(tableName: String, key_value_dic: Dictionary<String, String>, fileName: String = defaultName) {
        
        if tableName.characters.count < 1 {
            return
        }
        
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        let dbQueue = FMDatabaseQueue(path: dbPath)
        dbQueue?.inTransaction({ (db, roolback) in
            let res = db?.executeUpdate("INSERT INTO \(tableName) (name, password) VALUES (:name, :password)", withParameterDictionary: key_value_dic)//后面个参数withParameterDictionary可以有很多种方式，一般选择自己习惯的就好，本demo尝试着用所有的参数
            res! ? print("插入\(key_value_dic)成功！") : print("插入\(key_value_dic)失败！")
        })
    }
    
    
    /**删*/
    static func deleteData(tableName: String, condition: String, fileName: String = defaultName) {
        
        if tableName.characters.count < 1 {
            return
        }
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        let dbQueue = FMDatabaseQueue(path: dbPath)
        dbQueue?.inTransaction({ (db, roolback) in
            let res = db?.executeUpdate("DELETE FROM \(tableName) WHERE \(condition)", withArgumentsIn: nil)
            res! ? print("删除\(condition)成功！") : print("删除\(condition)失败！")
        })
    }
    
    
    /**改*/
    static func changeData(tableName: String, key_value_dic: Dictionary<String, String>, fileName: String = defaultName) {
        
        if tableName.characters.count < 1 {
            return
        }
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        let dbQueue = FMDatabaseQueue(path: dbPath)
        dbQueue?.inTransaction({ (db, roolback) in
            let res = db?.executeUpdate("UPDATE \(tableName) SET password = (:password) WHERE name = (:name)", withParameterDictionary: key_value_dic)
            res! ? print("修改\(key_value_dic)成功！") : print("修改\(key_value_dic)失败！")
        })
    }
    
    
    /**查*/
    static func getData(tableName: String, condition: String?, fileName: String = defaultName) -> [Dictionary<String, String>]? {
        
        if tableName.characters.count < 1 {
            return nil
        }
        var result = [Dictionary<String, String>]()
        let dbPath = (dbDirPath?.appending("/\(fileName).db"))!
        let dbQueue = FMDatabaseQueue(path: dbPath)
        dbQueue?.inDatabase({ (db) in
            let set = condition == nil ? db?.executeQuery("SELECT * FROM \(tableName)", withParameterDictionary: nil) : db?.executeQuery("SELECT * FROM \(tableName) WHERE \(condition!)", withParameterDictionary: nil)
            while (set?.next())! {
                var dic = [String: String]()
                dic.updateValue((set?.string(forColumn: "name"))!, forKey: "name")
                dic.updateValue((set?.string(forColumn: "password"))!, forKey: "password")
                result.append(dic)
            }
        })
        print("查询结果：\(result)")
        return result
    }
    
}
