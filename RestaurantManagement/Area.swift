//
//  Area.swift
//  RestaurantManagement
//
//  Created by Bill on 4/18/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import Foundation
struct Area {
    var idArea: Int?
    var name: String?
    var detail: String?
    var image: String?
    
    init(idArea: Int, name: String, detail: String, image: String) {
        self.idArea = idArea
        self.name = name
        self.detail = detail
        self.image = image
    }
}

class DBArea{
    static func loadArea(database: OpaquePointer?) ->[Area]
    {
        var Areas = [Area]()
        let query = "SELECT * FROM Area"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                let temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                var temp = sqlite3_column_text(statement, 1)
                let name = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 2)
                let image = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 3)
                let detail = String(cString: temp!)
                
                
                let newArea = Area(idArea: id!, name: name, detail: detail, image: image)
                Areas.append(newArea)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Areas
    }
    
    static func insertArea(database: OpaquePointer?, Area: Area) -> Bool
    {
        let getMaxIdQuery = " SELECT MAX(idArea) FROM Area;"
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
        
        let Statement = "INSERT INTO Area (idArea, name, image, info) VALUES (?, ?, ?, ?);"
        var insert : OpaquePointer? = nil
        if sqlite3_prepare_v2(database, Statement, -1, &insert, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insert, 1, newId!)
            sqlite3_bind_text(insert, 2, (Area.name! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insert, 3, (Area.image! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insert, 4, (Area.detail! as NSString).utf8String, -1, nil)
            
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
    
    static func deleteArea(database: OpaquePointer? ,id : Int)
    {
        let delete = "DELETE FROM Area WHERE idArea = " + String(id)
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
    
    static func selectAreaWithID(database: OpaquePointer?, id: Int) ->[Area]
    {
        var Areas = [Area]()
        let query = "SELECT * FROM Area WHERE idArea = " + String(id)
        var statement : OpaquePointer?
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                let temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                var temp = sqlite3_column_text(statement, 1)
                let name = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 2)
                let image = String(cString: temp!)
                
                temp = sqlite3_column_text(statement, 3)
                let detail = String(cString: temp!)
                
                
                let newArea = Area(idArea: id!, name: name, detail: detail, image: image)
                Areas.append(newArea)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Areas
    }
    
}
