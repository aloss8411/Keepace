//
//  StoreIitems+CoreDataProperties.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/18.
//
//

import Foundation
import CoreData


extension StoreIitems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreIitems> {
        return NSFetchRequest<StoreIitems>(entityName: "StoreIitems")
    }

    @NSManaged public var date: String?
    @NSManaged public var descipt: String?
    @NSManaged public var status: Double
    @NSManaged public var title: String?

}

extension StoreIitems : Identifiable {

}
