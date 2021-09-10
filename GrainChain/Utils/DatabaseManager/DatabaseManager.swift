//
//  DatabaseManager.swift
//  GrainChain
//
//  Created by Javier Hernandez on 09/09/21.
//

import Foundation
import CoreData
import UIKit

enum DefaultError: Error {
    case invalidResponse(AnyObject?)
    case serverError(Error)
}

class DatabaseManager {
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    func saveTour(tour: TrackingModel) {
        guard let context = getContext() else { return }
        let entity = NSEntityDescription.entity(forEntityName: "Tour", in: context)
        let newCategory = NSManagedObject(entity: entity!, insertInto: context)
        newCategory.setValue(tour.name, forKey: "name")
        newCategory.setValue(tour.beginning, forKey: "beginning")
        newCategory.setValue(tour.end, forKey: "end")
        newCategory.setValue(tour.km, forKey: "km")
        newCategory.setValue(tour.locations, forKey: "locations")
        newCategory.setValue(tour.time, forKey: "time")
        do {
            try context.save()
          } catch {
            debugPrint(error)
        }
       
    }
    
    func getTours(result: @escaping (Result<[Tour], DefaultError>) -> Void) {
        guard let context = getContext() else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tour")
        var array: [Tour] = []
        do {
            let result = try context.fetch(request)
            if let tours = result as? [Tour] {
               array = tours
            }
        } catch {
            result(.failure(.serverError(error)))
        }
        result(.success(array))
    }
    func deleteTour(tour: Tour?) {
        guard let context = getContext() else { return }
        guard tour != nil else { return }
        context.delete(tour!)
        do {
            try context.save()
        } catch let err {
            debugPrint(err)
        }
    }
}
