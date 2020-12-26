//
//  Persistence.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 10/12/2020.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for _ in 0..<10 {
//            switch Bool.random() {
//            case true:
                ClickerEntity.random(context: viewContext)
//
//            case false:
//                CounterEntity.random(context: viewContext)
//            }
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "CountUpp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension CountableEntity {
    
    private static let titles: [String] = [
        "Something happend",
        "Occurences of somthing",
        "End of thee world",
        "Days I want to die",
        "Days I am happy to live",
        "Days in human shell",
        "Leave everything and go to Bieszczady"
    ]
    
    func randomize() {
        id = UUID()
        title = Self.titles.randomElement()!
        createdAt = Date(timeIntervalSinceNow: .random(in: -31390...31390) * 1000)
        index = 0
        theme = "test theme"
    }
    
}

extension ClickerEntity {
    
    static func random(context: NSManagedObjectContext) -> ClickerEntity {
        let entity = ClickerEntity(context: context)
        
        entity.randomize()
//        entity.mode = Int16([-1, 1].randomElement()!)
        entity.initial = .random(in: 0...100)
        
        let events = (0...Int.random(in: 0...100)).map { _ -> EventEntity in
            let event = EventEntity(context: context)
            event.timestamp = Date(timeIntervalSinceNow: .random(in: -31390...31390) * 1000)
            return event
        }
        
        entity.addToEvents(NSSet(array: events))
        
        return entity
    }
    
}

extension CounterEntity {
    
    static func random(context: NSManagedObjectContext) -> CounterEntity {
        let entity = CounterEntity(context: context)
        
        entity.randomize()
        entity.date = Date(timeIntervalSinceNow: .random(in: -31390...31390) * 1000)
        entity.precision = 1
        entity.smartFormat = Bool.random()
        
        return entity
    }
    
}
