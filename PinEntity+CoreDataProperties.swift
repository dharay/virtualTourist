//
//  PinEntity+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by dharay mistry on 25/10/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import Foundation
import CoreData


extension PinEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PinEntity> {
        return NSFetchRequest<PinEntity>(entityName: "PinEntity");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var hasImage: Bool
    @NSManaged public var currentPage: Int64
    @NSManaged public var totalPage: Int64
    @NSManaged public var relOfPin: NSSet?

}

// MARK: Generated accessors for relOfPin
extension PinEntity {

    @objc(addRelOfPinObject:)
    @NSManaged public func addToRelOfPin(_ value: ImageEntity)

    @objc(removeRelOfPinObject:)
    @NSManaged public func removeFromRelOfPin(_ value: ImageEntity)

    @objc(addRelOfPin:)
    @NSManaged public func addToRelOfPin(_ values: NSSet)

    @objc(removeRelOfPin:)
    @NSManaged public func removeFromRelOfPin(_ values: NSSet)

}
