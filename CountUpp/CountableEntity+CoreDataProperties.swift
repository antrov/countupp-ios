//
//  CountableEntity+CoreDataProperties.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 23/12/2020.
//
//

import Foundation
import CoreData


extension CountableEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountableEntity> {
        return NSFetchRequest<CountableEntity>(entityName: "CountableEntity")
    }
    
    static func getSpecificAccounts(id: UUID) -> NSFetchRequest<CountableEntity> {
        let request: NSFetchRequest<CountableEntity> =  NSFetchRequest<CountableEntity>(entityName: "CountableEntity")
        
        let findDescriptor = NSPredicate(format: "id == %@", id as CVarArg)
        
        request.predicate = findDescriptor
        
        return request
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var index: Int32
    @NSManaged public var theme: String?
    @NSManaged public var title: String

    var currentValue: String {
        switch self {
        case is ClickerEntity:
            return "\((self as! ClickerEntity).value)"
            
        case is CounterEntity:
            return Self.itemFormatter.string(from: (self as! CounterEntity).date!)
            
        default:
            return ""
        }
    }
    
    enum EntityType: String, CaseIterable {
        case clicker
        case counter
    }
    
    var entityType: EntityType {
        switch self {
        case is ClickerEntity: return .clicker
        case is CounterEntity: return .counter
        default: return .clicker
        }
    }
    
    private static let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

extension CountableEntity : Identifiable {

}
