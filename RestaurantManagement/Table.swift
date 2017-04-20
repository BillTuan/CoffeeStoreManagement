//
//  Table.swift
//  RestaurantManagement
//
//  Created by Bill on 4/18/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import Foundation
struct Table {
    var idTable: Int?
    var name: String?
    var detail: String?
    var image: String?
    var status: Int?
    var area: Int?
    
    init(idTable: Int, name: String, detail: String, image: String, status: Int, area: Int) {
        self.idTable = idTable
        self.name = name
        self.detail = detail
        self.image = image
        self.status = status
        self.area = area
    }
}

class DBTable{
    static func loadTable(database: OpaquePointer?) ->[Table]
    {
        var Tables = [Table]()
        let query = "SELECT * FROM Tables"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                var temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                var temp = sqlite3_column_text(statement, 1)
                let name = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 2)
                let image = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 3)
                let detail = String(cString: temp!)
                
                temp1 = sqlite3_column_int(statement, 4)
                let status = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 5)
                let area = Int(exactly: temp1)
                
                let newTable = Table(idTable: id!, name: name, detail: detail, image: image, status: status!, area: area!)
                Tables.append(newTable)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Tables
    }
    
    static func insertTable(database: OpaquePointer?, Table: Table) -> Bool
    {
        let getMaxIdQuery = " SELECT MAX(idTable) FROM Tables;"
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
        
        let Statement = "INSERT INTO Tables (idTable, name, image, info, status, area) VALUES (?, ?, ?, ?, ?, ?);"
        var insert : OpaquePointer? = nil
        if sqlite3_prepare_v2(database, Statement, -1, &insert, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insert, 1, newId!)
            sqlite3_bind_text(insert, 2, (Table.name! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insert, 3, (Table.image! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insert, 4, (Table.detail! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insert, 5, Int32(Table.status!))
            sqlite3_bind_int(insert, 6, Int32(Table.area!))
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
    
    static func selectTableWithID(database: OpaquePointer?, idTable: Int) ->[Table]
    {
        var Tables = [Table]()
        let query = "SELECT * FROM Tables WHERE idTable = " + String(idTable)
        var statement : OpaquePointer?
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                var temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                var temp = sqlite3_column_text(statement, 1)
                let name = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 2)
                let image = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 3)
                let detail = String(cString: temp!)
                
                temp1 = sqlite3_column_int(statement, 4)
                let status = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 5)
                let area = Int(exactly: temp1)
                
                let newTable = Table(idTable: id!, name: name, detail: detail, image: image, status: status!, area: area!)
                Tables.append(newTable)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Tables
    }
    
    static func deleteTable(database: OpaquePointer? ,id : Int)
    {
        let delete = "DELETE FROM Tables WHERE idTable = " + String(id)
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, delete, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("Successfully deleted row!")
            }
            else
            {
                print("Could not delete row!")
            }
        }
        else{
            print("Delete statment could not be prepared!")
        }
        sqlite3_finalize(statement)
    }
    
    static func deleteTableWithIDArea(database: OpaquePointer? ,id : Int)
    {
        let delete = "DELETE FROM Tables WHERE area = " + String(id)
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, delete, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("Successfully deleted row!")
            }
            else
            {
                print("Could not delete row!")
            }
        }
        else{
            print("Delete statment could not be prepared!")
        }
        sqlite3_finalize(statement)
    }
    
    static func getTableWithIDArea(database: OpaquePointer?, idArea: Int) ->[Table]
    {
        var Tables = [Table]()
        let query = "SELECT * FROM Area a Join Tables b where a.idArea = b.area and a.idArea = " + String(idArea)
        var statement : OpaquePointer?
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                var temp1 = sqlite3_column_int(statement, 4)
                let id = Int(exactly: temp1)
                
                var temp = sqlite3_column_text(statement, 5)
                let name = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 6)
                let image = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 7)
                let detail = String(cString: temp!)
                
                temp1 = sqlite3_column_int(statement, 8)
                let status = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 9)
                let area = Int(exactly: temp1)
                
                let newTable = Table(idTable: id!, name: name, detail: detail, image: image, status: status!, area: area!)
                Tables.append(newTable)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Tables
    }
    
    static func updateTable(database: OpaquePointer?, Table: Table) -> Bool
    {
        let update = "UPDATE Tables SET name = ?, image = ?, info = ?, status = ?, area = ? WHERE idTable = ?"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(statement, 1, (Table.name! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (Table.image! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (Table.detail! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 4, Int32(Table.status!))
            sqlite3_bind_int(statement, 5, Int32(Table.area!))
            sqlite3_bind_int(statement, 6, Int32(Table.idTable!))
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
