
import Foundation
import CoreData

class CoreDataStore {
  
  static var instance: CoreDataStore = CoreDataStore(dataModel: "AppointmentModel")
  
  var persistentContainer: NSPersistentContainer
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  init(dataModel: String) {
    persistentContainer = NSPersistentContainer(name: dataModel)
    persistentContainer.loadPersistentStores { (desc, error) in
      if let error = error as NSError? {
        print("Persist container failed", error.localizedDescription)
      }
    }
  }
  
  func save() {
    guard context.hasChanges else {
      return
    }
    do {
      try context.save()
    }
    catch {
      print("Saving didn't work!", error)
    }
  }
}

