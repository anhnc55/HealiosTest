//
//  Post+CoreData.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Foundation
import CoreData
import UIKit
import Combine

extension Post {
    init(postMO: PostMO) {
        self.id = postMO.id
        self.userId = postMO.userId
        self.title = postMO.title
        self.body = postMO.body
    }
}

extension Post {
    static func savePostsToDB(_ posts: [Post]) -> AnyPublisher<Bool, Error> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let postEntity = NSEntityDescription.entity(forEntityName: "PostMO",
                                                    in: managedContext)!
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "PostMO")

        for i in 0..<posts.count {
            fetchRequest.predicate = NSPredicate(format: "id = %d", posts[i].id)
            do {
                let existPost = try managedContext.fetch(fetchRequest).first
                if let updateObject = existPost as? PostMO {
                    updateObject.setValue(posts[i].userId, forKey: "userId")
                    updateObject.setValue(posts[i].title, forKey: "title")
                    updateObject.setValue(posts[i].body, forKey: "body")
                } else {
                    let post = NSManagedObject(entity: postEntity,
                                               insertInto: managedContext)
                    post.setValue(posts[i].id, forKey: "id")
                    post.setValue(posts[i].userId, forKey: "userId")
                    post.setValue(posts[i].title, forKey: "title")
                    post.setValue(posts[i].body, forKey: "body")
                }
            } catch {
                print("Could not save: \(error.localizedDescription)")
            }
        }
        return Future<Bool, Error> { promise in
            do {
                try managedContext.save()
                promise(.success(true))
            } catch {
                print("Could not save: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func retrievePostFromDB() -> AnyPublisher<[Post], Error> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostMO")
        return Future<[Post], Error> { promise in
            
            do {
                let results = try managedContext.fetch(fetchRequest) as! [PostMO]
                promise(.success(results.map({ Post(postMO: $0) })))
            } catch {
                print("Retrieve Data Failed")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
