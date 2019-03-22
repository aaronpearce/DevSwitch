//
//  Realm+Limit.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 26/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import RealmSwift

extension Results {
    
    func get <T:Object> (offset: Int, limit: Int ) -> Array<T>{
        //create variables
        var lim = 0 // how much to take
        var off = 0 // start from
        var l: Array<T> = Array<T>() // results list
        
        //check indexes
        if off<=offset && offset<self.count - 1 {
            off = offset
        }
        if limit > self.count {
            lim = self.count
        }else{
            lim = limit
        }
        
        //do slicing
        for i in off..<lim {
            let obj = self[i] as! T
            l.append(obj)
        }
        
        //results
        return l
    }
}
