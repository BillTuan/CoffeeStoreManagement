//
//  Food.swift
//  RestaurantManagement
//
//  Created by Bill on 4/19/17.
//  Copyright © 2017 Bill. All rights reserved.
//

import Foundation
struct Food {
    var idFood: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: Int?
    
    init(idFood: Int, name: String, image: String, price: Int, category: Int) {
        self.idFood = idFood
        self.name = name
        self.image = image
        self.price = price
        self.category = category
    }
}

class DBFood{
    static func loadFood(database: OpaquePointer?) ->[Food]
    {
        var Foods = [Food]()
        let query = "SELECT * FROM Food"
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
                
                temp1 = sqlite3_column_int(statement, 3)
                let price = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 4)
                let catefory = Int(exactly: temp1)
                
                
                let newFood = Food(idFood: id!, name: name, image: image, price: price!, category: catefory!)
                Foods.append(newFood)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Foods
    }
    
    static func insertFood(database: OpaquePointer?, Food: Food) -> Bool
    {
        
        let Statement = "INSERT INTO Food (idFood, name, image, price, category) VALUES (?, ?, ?, ?, ?);"
        var insert : OpaquePointer? = nil
        if sqlite3_prepare_v2(database, Statement, -1, &insert, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insert, 1, Int32(Food.idFood!))
            sqlite3_bind_text(insert, 2, (Food.name! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insert, 3, (Food.image! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insert, 4, Int32(Food.price!))
            sqlite3_bind_int(insert, 5, Int32(Food.category!))

            
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
    
    static func deleteFood(database: OpaquePointer? ,id : Int)
    {
        let delete = "DELETE FROM Food WHERE idFood = " + String(id)
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
    static func selectFoodWithID(database: OpaquePointer?, id: Int) ->[Food]
    {
        var Foods = [Food]()
        let query = "SELECT * FROM Food WHERE idFood = " + String(id)
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
                
                temp1 = sqlite3_column_int(statement, 3)
                let price = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 4)
                let category = Int(exactly: temp1)
                
                let newFood = Food(idFood: id!, name: name, image: image, price: price!, category: category!)
                Foods.append(newFood)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Foods
    }
    
    static func selectFoodWithIDCategory(database: OpaquePointer?, id: Int) ->[Food]
    {
        var Foods = [Food]()
        let query = "SELECT * FROM Food WHERE category = " + String(id)
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
                
                temp1 = sqlite3_column_int(statement, 3)
                let price = Int(exactly: temp1)
                
                temp1 = sqlite3_column_int(statement, 4)
                let category = Int(exactly: temp1)
                
                let newFood = Food(idFood: id!, name: name, image: image, price: price!, category: category!)
                Foods.append(newFood)
            }
            print("Successfully load data from SQLite!")
        }
        else{
            print("SELECT statement could not be prepared!")
        }
        sqlite3_finalize(statement)
        return Foods
    }


    static func updateFood(database: OpaquePointer?, Food: Food) -> Bool
    {
        let update = "UPDATE Food SET name = ?, image = ?, price = ?, category = ? WHERE idFood = ?"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(statement, 1, (Food.name! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (Food.image! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(Food.price!))
            sqlite3_bind_int(statement, 4, Int32(Food.category!))
            sqlite3_bind_int(statement, 5, Int32(Food.idFood!))
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
