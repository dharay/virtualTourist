//
//  ImageEntity+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by dharay mistry on 25/10/16.
//  Copyright © 2016 forever knights. All rights reserved.
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity");
    }

    @NSManaged public var image: NSData?
    @NSManaged public var id: Int64
    @NSManaged public var relOfImage: PinEntity?

}
