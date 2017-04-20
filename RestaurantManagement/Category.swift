//
//  Category.swift
//  RestaurantManagement
//
//  Created by Bill on 4/19/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import Foundation
struct Category {
    var idCategory: Int?
    var name: String?
    
    init(idCategory: Int, name: String) {
        self.idCategory = idCategory
        self.name = name
    }
}

class DBCategory{
    static func loadCategory(database: OpaquePointer?) ->[Category]
    {
        var Categorys = [Category]()
        let query = "SELECT * FROM Category"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                let temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                let temp = sqlite3_column_text(statement, 1)
                let name = String(cString: temp!)
                
                let newCategory = Category(idCategory: id!, name: name)
                Categorys.append(newCategory)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Categorys
    }
    
    static func insertCategory(database: OpaquePointer?, Category: Category) -> Bool
    {
        let getMaxIdQuery = " SELECT MAX(idCategory) FROM Category;"
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
        
        let Statement = "INSERT INTO Category (idCategory, name) VALUES (?, ?);"
        var insert : OpaquePointer? = nil
        if sqlite3_prepare_v2(database, Statement, -1, &insert, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insert, 1, newId!)
            sqlite3_bind_text(insert, 2, (Category.name! as NSString).utf8String, -1, nil)
            
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
    
    static func getCategoryWithName(database: OpaquePointer?, name: String) ->[Category]
    {
        var Categorys = [Category]()
        let query = "SELECT * FROM Category WHERE name = \(name)"
        var statement : OpaquePointer?
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                let temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                let temp = sqlite3_column_text(statement, 1)
                let name = String(cString: temp!)
                
                
                let newCategory = Category(idCategory: id!, name: name)
                Categorys.append(newCategory)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Categorys
    }
    
    static func getCategoryWithID(database: OpaquePointer?, id: Int) ->[Category]
    {
        var Categorys = [Category]()
        let query = "SELECT * FROM Category WHERE idCategory = " + String(id)
        var statement : OpaquePointer?
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                let temp1 = sqlite3_column_int(statement, 0)
                let id = Int(exactly: temp1)
                
                let temp = sqlite3_column_text(statement, 1)
                let name = String(cString: temp!)
                
                
                let newCategory = Category(idCategory: id!, name: name)
                Categorys.append(newCategory)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Categorys
    }
    
    static func deleteCategory(database: OpaquePointer? ,id : Int)
    {
        let delete = "DELETE FROM Category WHERE idCategory = " + String(id)
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
    
}
