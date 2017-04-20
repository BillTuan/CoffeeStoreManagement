//
//  Database.swift
//  RestaurantManagement
//
//  Created by Bill on 4/17/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import Foundation



class DB {
    //private var database : OpaquePointer?
    
    static func openDatabase()->OpaquePointer?{
        //Create database in direction
        let link = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = link.appendingPathComponent("Restaurant.db").path
        
        var dataTempPointer: OpaquePointer?
        if sqlite3_open(dataPath, &dataTempPointer) == SQLITE_OK{
            print("Database created!")
            print(dataPath)
            return dataTempPointer
        }else{
            print("Database create failed!")
            return nil
        }
    }
    static func createAreaTable(database: OpaquePointer?)
    {
        let createTableString = "CREATE TABLE Area(idArea INT PRIMARY KEY, name CHAR(255), image CHAR(255), info CHAR(255));"
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Area table created.")
            } else {
                print("Area table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    static func createTableTable(database: OpaquePointer?)
    {
        let createTableString = "CREATE TABLE Tables(idTable INT PRIMARY KEY, name CHAR(255), image CHAR(255), info CHAR(255), status INT," +
        "area INT, FOREIGN KEY(area) REFERENCES Area(idArea));"
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Table table created.")
            } else {
                print("Table table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    static func createTableCategory(database: OpaquePointer?)
    {
        let createTableString = "CREATE TABLE Category(idCategory INT PRIMARY KEY, name CHAR(255));"

        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Category table created.")
            } else {
                print("Category table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    static func createTableFood(database: OpaquePointer?)
    {
        let createTableString = "CREATE TABLE Food(idFood INT PRIMARY KEY, name CHAR(255), image CHAR(255), price INT," +
        "category INT, FOREIGN KEY(category) REFERENCES Category(idCategory));"
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Food table created.")
            } else {
                print("Food table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    static func createTableBill(database: OpaquePointer?)
    {
        let createTableString = "CREATE TABLE Bill(idBill INT PRIMARY KEY, dateCheckIn CHAR(255), totalPrice INT, status INT," +
        "idTable INT, FOREIGN KEY(idTable) REFERENCES Tables(idTable));"
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Bill table created.")
            } else {
                print("Bill table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    static func createTableBillInfo(database: OpaquePointer?)
    {
        let createTableString = "CREATE TABLE BillInfo(idBillInfo INT, amountFood INT," + "idFood INT, FOREIGN KEY(idBillInfo) REFERENCES Bill(idBill), FOREIGN KEY(idFood) REFERENCES Food(idFood));"
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("BillInfo table created.")
            } else {
                print("BillInfo table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }


}
