//
//  Bill.swift
//  RestaurantManagement
//
//  Created by Bill on 4/20/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import Foundation
struct Bill {
    var idBill: Int?
    var dateCheckIn: String?
    var totalPrice: Int?
    var status: Int?
    var idTable: Int?
    
    init(idBill: Int, dateCheckIn: String, totalPrice: Int, status: Int, idTable: Int) {
        self.idBill = idBill
        self.dateCheckIn = dateCheckIn
        self.totalPrice = totalPrice
        self.status = status
        self.idTable = idTable
    }
}

class DBBill{
    static func loadBill(database: OpaquePointer?) ->[Bill]
    {
        var Bills = [Bill]()
        let query = "SELECT * FROM Bill"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                var temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                let temp = sqlite3_column_text(statement, 1)
                let dateCheckIn = String(cString: temp!)
                
                temp1 = sqlite3_column_int(statement, 2)
                let totalPrice = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 3)
                let status = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 4)
                let idTable = Int(exactly: temp1)
                
                
                let newBill = Bill(idBill: id!, dateCheckIn: dateCheckIn, totalPrice: totalPrice!, status: status!, idTable: idTable!)
                Bills.append(newBill)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Bills
    }
    
    static func insertBill(database: OpaquePointer?, Bill: Bill) -> Bool
    {
        let getMaxIdQuery = " SELECT MAX(idBill) FROM Bill;"
        var newId : Int32?
        var getMaxId : OpaquePointer?
        if sqlite3_prepare_v2(database, getMaxIdQuery, -1, &getMaxId, nil) == SQLITE_OK
        {
            //get max id
            let kq = sqlite3_step(getMaxId)
            if  kq == SQLITE_ROW
            {
                newId = sqlite3_column_int(getMaxId, 0)
                newId! += 1
                print("Get max id successfully!")
            }
        }
        else
        {
            print("Get max id failed")
        }
        sqlite3_finalize(getMaxId)
        
        let Statement = "INSERT INTO Bill (idBill, dateCheckIn, totalPrice, status, idTable) VALUES (?, ?, ?, ?, ?);"
        var insert : OpaquePointer? = nil
        if sqlite3_prepare_v2(database, Statement, -1, &insert, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insert, 1, newId!)
            sqlite3_bind_text(insert, 2, (Bill.dateCheckIn! as NSString).utf8String, -1,nil)
            sqlite3_bind_int(insert, 3, Int32(Bill.totalPrice!))
            sqlite3_bind_int(insert, 4, Int32(Bill.status!))
            sqlite3_bind_int(insert, 5, Int32(Bill.idTable!))
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

    static func selectBillWithIDTable(database: OpaquePointer?, id: Int) ->[Bill]
    {
        var Bills = [Bill]()
        let query = "SELECT * FROM Bill WHERE status = 0 and idTable = " + String(id)
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                var temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                let temp = sqlite3_column_text(statement, 1)
                let dateCheckIn = String(cString: temp!)
                
                temp1 = sqlite3_column_int(statement, 2)
                let totalPrice = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 3)
                let status = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 4)
                let idTable = Int(exactly: temp1)
                
                
                let newBill = Bill(idBill: id!, dateCheckIn: dateCheckIn, totalPrice: totalPrice!, status: status!, idTable: idTable!)
                Bills.append(newBill)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Bills
    }
    
    static func updateBill(database: OpaquePointer?, Bill: Bill) -> Bool
    {
        let update = "UPDATE Bill SET dateCheckIn = ?, totalPrice = ?, status = ?, idTable = ? WHERE idBill = ?"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(statement, 1, (Bill.dateCheckIn! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(Bill.totalPrice!))
            sqlite3_bind_int(statement, 3, Int32(Bill.status!))
            sqlite3_bind_int(statement, 4, Int32(Bill.idTable!))
            sqlite3_bind_int(statement, 5, Int32(Bill.idBill!))
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
