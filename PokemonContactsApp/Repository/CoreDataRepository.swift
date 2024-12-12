//
//  CoreDataRepository.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/12/24.
//

import Foundation
import CoreData

class CoreDataRepository {
    
    var contacts: [Contact] = []
    
    let persistentContainer: NSPersistentContainer
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetch() {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        do {
            contacts = try self.context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
    
    func saveContext() {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
