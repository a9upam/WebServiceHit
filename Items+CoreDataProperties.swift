//
//  Items+CoreDataProperties.swift
//  NetworkAndCoreDataTask
//
//  Created by Anupam G on 13/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged public var image: String?

}
