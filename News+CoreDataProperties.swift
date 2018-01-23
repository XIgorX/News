//
//  News+CoreDataProperties.swift
//  News
//
//  Created by Igor Danilchenko on 23.01.18.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var newsID: String?
    @NSManaged public var text: String?
    @NSManaged public var publicationDate: Int64

}
