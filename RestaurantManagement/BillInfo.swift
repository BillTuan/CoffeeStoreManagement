//
//  BillInfo.swift
//  RestaurantManagement
//
//  Created by Bill on 4/20/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import Foundation
struct BillInfo {
    var idBillInfo: Int?
    var amountFood: Int?
    var idFood: Int?
    
    init(idBill: Int, amountFood: Int, idFood: Int) {
        self.idBillInfo = idBill
        self.amountFood = amountFood
        self.idFood = idFood
    }

}

class DBBillInfo{
    static func loadBillInfo(database: OpaquePointer?) ->[BillInfo]
    {
        var BillInfos = [BillInfo]()
        let query = "SELECT * FROM BillInfo"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                var temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 1)
                let amountFood = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 2)
                let idFood = Int(exactly: temp1)
                
                
                let newBillInfo = BillInfo(idBill: id!, amountFood: amountFood!, idFood: idFood!)
                BillInfos.append(newBillInfo)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return BillInfos
    }
    
    static func insertBillInfo(database: OpaquePointer?, BillInfo: BillInfo) -> Bool
    {
        let Statement = "INSERT INTO BillInfo (idBillInfo, amountFood, idFood) VALUES (?, ?, ?);"
        var insert : OpaquePointer? = nil
        if sqlite3_prepare_v2(database, Statement, -1, &insert, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insert, 1, Int32(BillInfo.idBillInfo!))
            sqlite3_bind_int(insert, 2, Int32(BillInfo.amountFood!))
            sqlite3_bind_int(insert, 3, Int32(BillInfo.idFood!))
            if sqlite3_step(insert) == SQLITE_DONE
            {
                print("Successfully inserted row")
            }
            else
            {
                print("Could not insert row")
                return false
            }
        }
        else
        {
            print("INSERT statement could not be prepared.")
            return false
        }
        sqlite3_finalize(insert)
        return true
    }
    
    static func selectBillInfoWithID(database: OpaquePointer?, id: Int) ->[BillInfo]
    {
        var BillInfos = [BillInfo]()
        let query = "SELECT * FROM BillInfo WHERE idBillInfo = " + String(id)
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                var temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 1)
                let amountFood = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 2)
                let idFood = Int(exactly: temp1)
                
                
                let newBillInfo = BillInfo(idBill: id!, amountFood: amountFood!, idFood: idFood!)
                BillInfos.append(newBillInfo)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return BillInfos
    }
    
    static func selectBillInfoWithIDFood(database: OpaquePointer?, idInfo: Int, idFood: Int) ->[BillInfo]
    {
        var BillInfos = [BillInfo]()
        let query = "SELECT * FROM BillInfo WHERE idBillInfo = " + String(idInfo) + " and idFood = " + String(idFood)
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                var temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 1)
                let amountFood = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 2)
                let idFood = Int(exactly: temp1)
                
                
                let newBillInfo = BillInfo(idBill: id!, amountFood: amountFood!, idFood: idFood!)
                BillInfos.append(newBillInfo)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return BillInfos
    }

    static func updateBillInfo(database: OpaquePointer?, BillInfo: BillInfo) -> Bool
    {
        let update = "UPDATE BillInfo SET amountFood = ?, idFood = ? WHERE idBillInfo = ?"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(statement, 1, Int32(BillInfo.amountFood!))
            sqlite3_bind_int(statement, 2, Int32(BillInfo.idFood!))
            sqlite3_bind_int(statement, 3, Int32(BillInfo.idBillInfo!))
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("Successfully update row!")
            }
            else
            {
                print("Update row failed!")
                return false
            }
        }
        sqlite3_finalize(statement)
        return true
    }
    
}
