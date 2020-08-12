//
//  Recipes+CoreDataProperties.swift
//  classProject
//
//  Created by Minoshi K on 11/18/19.
//  Copyright © 2019 Minoshi K. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipes> {
        return NSFetchRequest<Recipes>(entityName: "Recipes")
    }

    @NSManaged public var ingredient: String?
    @NSManaged public var recipeName: String?
    @NSManaged public var image: NSData?

}
