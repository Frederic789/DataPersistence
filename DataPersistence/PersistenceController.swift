//
//  PersistenceController.swift
//  DataPersistence
//
//  Created by Student Account on 11/2/23.
//



import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataPersistenceModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Here you can add some sample data for the preview
        for _ in 0..<5 {
            let newItem = Movie(context: viewContext)
            newItem.title = "Sample Movie"
            newItem.year = 2023
            newItem.director = "Sample Director"
        }
        do {
            try viewContext.save()
        } catch {
            // Handle the Core Data error.
            fatalError("Error: \(error.localizedDescription)")
        }
        return result
    }()
}
