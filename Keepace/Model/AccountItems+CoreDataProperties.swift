//
//  AccountItems+CoreDataProperties.swift
//  Keepace
//
//  Created by Lan Ran on 2022/5/25.
//
//

import Foundation
import CoreData


extension AccountItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountItems> {
        return NSFetchRequest<AccountItems>(entityName: "AccountItems")
    }

    @NSManaged public var date: String?
    @NSManaged public var descipt: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var status: Double

}

extension AccountItems : Identifiable {

}
