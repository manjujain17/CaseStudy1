//
//  EmployeeData+CoreDataProperties.swift
//  
//
//  Created by ALokManju on 19/09/22.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension EmployeeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeData> {
        return NSFetchRequest<EmployeeData>(entityName: "EmployeeData")
    }

    @NSManaged public var emailid: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phonenumber: String?

}

extension EmployeeData : Identifiable {

}
