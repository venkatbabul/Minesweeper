//
//  Interactor.swift
//  MineSweeper
//
//  Created by Venkatram G V on 11/05/22.
//

import Foundation
import CoreData

class Interactor{
    let container: PersistentContainer = PersistentContainer.shared

    func saveToCoreData(score: String) {
        let context  = container.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Score", in: context)!

        //Instance of our custom class, reference to entity
        let theNewHighScore = Score(entity: entity, insertInto: context)

        //Fill in the Core Data
        theNewHighScore.highScore = score
        do{
            try context.save()
        }catch{
            print("Error while saving to core data!")
        }
    }
    
    func fetchFromCoreData() -> String{
        var highScore = ""
        let context  = container.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Score", in: context)!
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        fetchRequest.returnsObjectsAsFaults = false
        do{
        guard let results = try context.fetch(fetchRequest) as? [Score] else{ return "" }
            if results.count == 0{
                highScore = "0"
                print("no highScore")
                return "\(highScore)"
            }else{
                highScore = results[0].highScore ?? "0 as optional"
                return highScore
            }
        }catch{
            print("Error while fetching from core data!")
        }
        return highScore
    }
    
    func deleteAllData(entity: String){
        let context  = container.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
                try context.save()
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
}

struct info{
    internal init(score: String){
        self.score = score
    }
    let score: String
}
