//
//  Project.swift
//  BookWriterHelper
//
//  Created by Andrey Egorov on 11/18/15.
//  Copyright © 2015 Andrey Egorov. All rights reserved.
//

import UIKit

class Project: NSObject, NSCoding {
    // MARK: Properties
    var name: String
    var notes: [Note]
    var uuid: String
    
    // MARK: Archiving Paths
    // здесь мы создаем постоянный путь к файловой системе, где будут храниться наши проекты
    // static = применимы к классу, а не инстансу
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("projects")
    
    // MARK: Types
    struct PropertyKey {
        // static - означает что константа присуждается самому стракту, а не его инстансу
        static let nameKey = "name"
        static let notesKey = "notes"
        static let uuidKey = "uuid"
    }
    
    // MARK: Initialization
    init?(name: String, notes: [Note], uuid: String) {
        self.name = name
        self.notes = notes
        self.uuid = uuid
        
        // так как это designated init, необходимо вызвать инициализатор его superclass'a
        super.init()
        
        if name.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(notes, forKey: PropertyKey.notesKey)
        aCoder.encodeObject(uuid, forKey: PropertyKey.uuidKey)
    }
    
    // required - инициализатор должен быть во всех сабклассах основного класса, где нужен какой либо инициализатор
    // convenience - воторостепенный init для поддержки designated initializers (определяющий)
    required convenience init?(coder aDecoder: NSCoder) {
        // decodeObjectForKey - разархивирует хранящуюся инфу об объекте
        // return value - это AnyObject, поэтому надо даункастить то Стринги, чтобы назначить значение константе name
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let notes = aDecoder.decodeObjectForKey(PropertyKey.notesKey) as! [Note]
        let uuid = aDecoder.decodeObjectForKey(PropertyKey.uuidKey) as! String
        
        // зовем designated intializer
        self.init(name: name, notes: notes, uuid: uuid)
    }
    
    static func saveProjects(projects: [Project]) {
        // этот метод старается архивировать массив проектов в определенной место, если успешно - return true
        let isSuccesfulSave = NSKeyedArchiver.archiveRootObject(projects, toFile: Project.ArchiveURL.path!)
        // чтобы узнать, сохранилось ли, выведем результат в консоль
        if !isSuccesfulSave {
            print("Не получилось сохранить это")
        }
    }
    
    // return type - optional Array of Project objects
    static func loadProjects() -> [Project]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Project.ArchiveURL.path!) as? [Project]
    }
    
    static func getUUID() -> String {
        return NSUUID().UUIDString
    }
}
