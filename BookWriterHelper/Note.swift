//
//  Note.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/30/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class Note: NSObject, NSCoding {
    // MARK: Properties
    var name: String
    var content: String
    var project: Project
    
    // MARK: Initialization
    init?(name: String, content: String, project: Project) {
        self.name = name
        self.content = content
        self.project = project
        
        super.init()
        
        if name.isEmpty && project != project {
            return nil
        }
    }
    
    //MARK: NSCoding    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.content = aDecoder.decodeObjectForKey("content") as! String
        self.project = aDecoder.decodeObjectForKey("project") as! Project
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(content, forKey: "content")
        aCoder.encodeObject(project, forKey: "project")
    }
    
}
