//
//  Post+CoreData.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Foundation
import CoreData
import UIKit
import RxSwift

extension Post {
    init(postMO: PostMO) {
        self.id = postMO.id
        self.userId = postMO.userId
        self.title = postMO.title
        self.body = postMO.body
    }
}

extension Post {
    static func savePostsToDB(_ posts: [Post]) -> Observable<Bool> {
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
        return Observable.create { observer in
            do {
                try managedContext.save()
                observer.onNext(true)
            } catch {
                print("Could not save: \(error.localizedDescription)")
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    static func retrievePostFromDB() -> Observable<[Post]> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostMO")
        return Observable.create { observer in
            do {
                let results = try managedContext.fetch(fetchRequest) as! [PostMO]
                let posts = results.map({ Post(postMO: $0) })
                observer.onNext(posts)
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
