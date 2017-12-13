//
//  User+CoreDataProperties.swift
//  NetworkAndCoreDataTask
//
//  Created by Anupam G on 13/12/17.
//  Copyright © 2017 Anupam G. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var items: NSObject?
    @NSManaged public var userToImage: NSSet?

}

// MARK: Generated accessors for userToImage
extension User {

    @objc(addUserToImageObject:)
    @NSManaged public func addToUserToImage(_ value: Items)

    @objc(removeUserToImageObject:)
    @NSManaged public func removeFromUserToImage(_ value: Items)

    @objc(addUserToImage:)
    @NSManaged public func addToUserToImage(_ values: NSSet)

    @objc(removeUserToImage:)
    @NSManaged public func removeFromUserToImage(_ values: NSSet)

}
