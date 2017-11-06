//
//  DBManager.swift
//  UsersApp
//
//  Created by RuslanKa on 05.11.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import Foundation
import SQLite3

class DBManager {
    fileprivate let dbPointer: OpaquePointer?
    //fileprivate let dbFilePath = "db.sqlite"
    fileprivate init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    
    enum SQLiteError: Error {
        case OpenDatabase(message: String)
        case Prepare(message: String)
        case Step(message: String)
        case Bind(message: String)
    }
    
    static func open() throws -> DBManager {
        let dbFileName = "db.sqlite"
        
        let fileManager = FileManager()
        let appDirectory = fileManager.currentDirectoryPath
        let dbFilePath = appDirectory + dbFileName
        print(dbFilePath)
//        if !fileManager.fileExists(atPath: dbFilePath) {
//
//        }
        
        var db: OpaquePointer?
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            return DBManager(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String.init(cString: errorPointer)
                print(message)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "Error")
            }
        }
    }
}
