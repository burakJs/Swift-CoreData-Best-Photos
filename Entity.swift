//
//  Entity.swift
//  PhotoList
//
//  Created by Burak İmdat on 3.09.2021.
//

import Foundation
import CoreData

@objc(Entity)

public class Entity: NSManagedObject {
    
}

extension Entity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }
    
    @NSManaged public var titleText: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var image: NSData?
}
