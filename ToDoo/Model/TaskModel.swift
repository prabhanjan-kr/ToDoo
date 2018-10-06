//
//  TaskModel.swift
//  ToDoo
//
//  Created by prabhanjan on 01/10/18.
//  Copyright © 2018 manorishi. All rights reserved.
//

import Foundation
import RealmSwift
class Task : Object {
    
   @objc dynamic var taskTitle : String = ""
   @objc  dynamic var isTaskCompleted : Bool = false
    
}
