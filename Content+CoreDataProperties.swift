//
//  Content+CoreDataProperties.swift
//  News
//
//  Created by Igor Danilchenko on 23.01.18.
//
//

import Foundation
import CoreData


extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var newsID: String?
    @NSManaged public var content: String?

}
